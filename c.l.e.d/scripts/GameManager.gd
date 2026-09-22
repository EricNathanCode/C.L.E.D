extends Node
# ═══════════════════════════════════════════════════════
#  GAME MANAGER  |  scripts/GameManager.gd  (Autoload)
# ═══════════════════════════════════════════════════════

var world:       String = ""
var lesson_id           = null

# ── Accounts ───────────────────────────────────────────
const ACCOUNTS_PATH := "user://accounts.cfg"
const SAVES_DIR      := "user://saves/"

var current_user: String = ""

# ── Toggles | persist across scenes ──────────────────
var tts_enabled:         bool = false
var music_enabled:       bool = true
var dark_overlay_enabled: bool = false

# ── Progress & scoring ────────────────────────────────
var completed_lessons:       Dictionary = {}   # "world_lid"  → star_count (1–3)
var completed_folder_quizzes: Dictionary = {}  # "world_fi"   → true
var current_quiz_folder_idx: int = 0
var last_stars:        int        = 0
var _wrongs_this_lesson:      int   = 0
var _sql_commands_this_lesson: Array = []

# ── Settings (global — shared by the whole PC, not per-user) ──
# Audio/display preferences aren't tied to a login, since the
# Login Screen itself needs to read/save them before anyone
# is signed in.
const SETTINGS_PATH := "user://settings.cfg"

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return  # no settings file yet — first launch
	tts_enabled          = cfg.get_value("settings", "tts_enabled",          false)
	music_enabled        = cfg.get_value("settings", "music_enabled",        true)
	dark_overlay_enabled = cfg.get_value("settings", "dark_overlay_enabled", false)

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("settings", "tts_enabled",          tts_enabled)
	cfg.set_value("settings", "music_enabled",        music_enabled)
	cfg.set_value("settings", "dark_overlay_enabled", dark_overlay_enabled)
	cfg.save(SETTINGS_PATH)

# ── Save / load ───────────────────────────────────────
# Progress persists between sessions, one file per user account
# in user://saves/<username>.cfg

func _save_path() -> String:
	return SAVES_DIR + current_user + ".cfg"

func save_game() -> void:
	if current_user.is_empty():
		return  # nobody logged in yet — nothing to save to
	DirAccess.make_dir_recursive_absolute(SAVES_DIR)
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "completed_lessons",        completed_lessons)
	cfg.set_value("progress", "completed_folder_quizzes", completed_folder_quizzes)
	cfg.save(_save_path())

func load_game() -> void:
	completed_lessons        = {}
	completed_folder_quizzes = {}
	if current_user.is_empty():
		return
	var cfg := ConfigFile.new()
	if cfg.load(_save_path()) != OK:
		return  # no save yet for this user — first login
	completed_lessons        = cfg.get_value("progress", "completed_lessons",        {})
	completed_folder_quizzes = cfg.get_value("progress", "completed_folder_quizzes", {})

# ── Accounts ───────────────────────────────────────────
# Plain local credential store — offline single-PC use only, no server.
func account_exists(username: String) -> bool:
	var cfg := ConfigFile.new()
	if cfg.load(ACCOUNTS_PATH) != OK:
		return false
	return cfg.has_section_key("accounts", username)

func check_password(username: String, password: String) -> bool:
	var cfg := ConfigFile.new()
	if cfg.load(ACCOUNTS_PATH) != OK:
		return false
	return cfg.get_value("accounts", username, null) == password

func create_account(username: String, password: String) -> void:
	var cfg := ConfigFile.new()
	cfg.load(ACCOUNTS_PATH)  # ok if this fails — file may not exist yet
	cfg.set_value("accounts", username, password)
	cfg.save(ACCOUNTS_PATH)

func login(username: String) -> void:
	current_user = username
	load_game()
	_remember_session(username)

# ── Session (remember the last signed-in user across launches) ──
# Set automatically on every login. Only cleared on an explicit
# logout, so quitting the app (without logging out) keeps the
# player signed in for next time — no need to log in again.
const SESSION_PATH := "user://session.cfg"

func _remember_session(username: String) -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("session", "username", username)
	cfg.save(SESSION_PATH)

func _forget_session() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("session", "username", "")
	cfg.save(SESSION_PATH)

func get_remembered_user() -> String:
	var cfg := ConfigFile.new()
	if cfg.load(SESSION_PATH) != OK:
		return ""
	return cfg.get_value("session", "username", "")

# Called once at app startup. Returns true if a remembered user was
# found and signed back in automatically (skipping the Login Screen).
func try_auto_login() -> bool:
	var username: String = get_remembered_user()
	if username.is_empty() or not account_exists(username):
		return false
	current_user = username
	load_game()
	return true

func logout() -> void:
	_forget_session()
	current_user             = ""
	world                    = ""
	lesson_id                = null
	completed_lessons        = {}
	completed_folder_quizzes = {}

func reset_progress() -> void:
	completed_lessons        = {}
	completed_folder_quizzes = {}
	save_game()

func start_lesson() -> void:
	_wrongs_this_lesson       = 0
	_sql_commands_this_lesson = []

func record_wrong() -> void:
	_wrongs_this_lesson += 1

func record_sql(display_name: String) -> void:
	if display_name not in _sql_commands_this_lesson:
		_sql_commands_this_lesson.append(display_name)

func finish_lesson() -> int:
	var stars: int
	if _wrongs_this_lesson == 0:
		stars = 3
	elif _wrongs_this_lesson <= 2:
		stars = 2
	else:
		stars = 1
	last_stars = stars
	var key: String = world + "_" + str(lesson_id)
	if not completed_lessons.has(key) or completed_lessons[key] < stars:
		completed_lessons[key] = stars
	save_game()
	return stars

func get_stars(w: String, lid) -> int:
	return completed_lessons.get(w + "_" + str(lid), 0)

func is_folder_quiz_done(w: String, fi: int) -> bool:
	return completed_folder_quizzes.get(w + "_" + str(fi), false)

func complete_folder_quiz(w: String, fi: int) -> void:
	completed_folder_quizzes[w + "_" + str(fi)] = true
	save_game()

func get_sql_recap() -> Array:
	return _sql_commands_this_lesson.duplicate()

# ── Voice profiles per character ──────────────────────────
# Each entry: [volume, pitch, rate]
const VOICE_PROFILES: Dictionary = {
	"guest":           [85, 1.15, 1.05],
	"guest2":          [80, 1.40, 0.85],
	"guest3":          [95, 0.72, 1.30],
	"mgr":             [88, 0.68, 0.80],
	"manager":         [88, 0.68, 0.80],
	"cafe_customer":   [85, 1.30, 1.10],
	"cafe_supervisor": [87, 0.75, 0.85],
	"cafe_owner":      [87, 0.75, 0.85],
	"visitor":         [78, 1.20, 0.93],
	"librarian":       [74, 0.88, 0.80],
	"passenger":       [82, 1.05, 0.95],
	"pilot":           [90, 0.65, 0.82],
	"you":             [82, 1.00, 1.00],
	"scene":           [78, 0.90, 0.85],
}

const DEFAULT_PROFILE := [80, 1.00, 1.00]

func speak(text: String, char_key: String = "") -> void:
	if not tts_enabled:
		return
	DisplayServer.tts_stop()
	var profile: Array = VOICE_PROFILES.get(char_key, DEFAULT_PROFILE)
	var vol:   int   = profile[0]
	var pitch: float = profile[1]
	var rate:  float = profile[2]
	DisplayServer.tts_speak(text, "", vol, pitch, rate)

func stop_speaking() -> void:
	DisplayServer.tts_stop()
