extends Node
# ═══════════════════════════════════════════════════════
#  GAME MANAGER  |  scripts/GameManager.gd  (Autoload)
# ═══════════════════════════════════════════════════════

var world:       String = ""
var lesson_id           = null
var sim_folder:  String = "all"   # "all" | "basic" | "filtering" | "sorting" — picked from the Simulation folder menu
var sim_lesson_index: int = 0     # 0 = whole folder mixed; >0 = one specific lesson within that folder

# ── Accounts ───────────────────────────────────────────
const ACCOUNTS_PATH := "user://accounts.cfg"
const SAVES_DIR      := "user://saves/"

var current_user: String = ""

# ── Toggles | persist across scenes ──────────────────
# tts_enabled / music_enabled are derived automatically whenever the
# matching volume is set (0 = off) — read them, but set the volume instead.
var tts_enabled:          bool = false
var music_enabled:        bool = true
var dark_overlay_enabled: bool = false

var tts_volume: float = 1.0:
	set(value):
		tts_volume = clamp(value, 0.0, 1.0)
		tts_enabled = tts_volume > 0.0

var music_volume: float = 1.0:
	set(value):
		music_volume = clamp(value, 0.0, 1.0)
		music_enabled = music_volume > 0.0

# Volume of the sound effects: the mouse click on buttons (0 = off). Separate from the
# music so muting one does not mute the other.
var sfx_volume: float = 1.0:
	set(value):
		sfx_volume = clamp(value, 0.0, 1.0)

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
	_setup_click_sound()
	_setup_answer_sounds()

# ── Mouse click sound ─────────────────────────────────
# Every button in the game (any BaseButton added to the tree) plays this when
# pressed down. Volume follows the "Sound Effects" setting.
const CLICK_SOUND_PATH := "res://audio/sfx/click.wav"
const CLICK_BASE_DB: float = -9.0
const CLICK_VOICES: int = 3   # overlapping clicks when clicking fast

var _click_stream: AudioStream = null
var _click_players: Array = []
var _click_next: int = 0

# Hover tick: a soft sound when the mouse moves onto an enabled button.
const HOVER_SOUND_PATH := "res://audio/sfx/hover.wav"
const HOVER_BASE_DB: float = -13.0
const HOVER_MIN_GAP_MS: int = 45         # ignore hovers that follow too quickly
const HOVER_AFTER_CLICK_MS: int = 250    # a new screen appearing under the mouse isn't a hover

var _hover_player: AudioStreamPlayer = null
var _last_hover_ms: int = -1000
var _last_click_ms: int = -1000

func _setup_click_sound() -> void:
	_click_stream = load(CLICK_SOUND_PATH)
	_hover_player = AudioStreamPlayer.new()
	_hover_player.bus = "Master"
	_hover_player.stream = load(HOVER_SOUND_PATH)
	add_child(_hover_player)
	for i in CLICK_VOICES:
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		_click_players.append(player)
	get_tree().node_added.connect(_on_node_added)
	# At startup this autoload becomes ready AFTER the main scene's screens are
	# already in the tree, so node_added never announced their buttons. Hook the
	# ones that already exist (Enter World, Exit, arrows, gear, Next/Back, ...).
	_hook_existing_buttons(get_tree().root)

func _hook_existing_buttons(node: Node) -> void:
	_on_node_added(node)
	for child in node.get_children():
		_hook_existing_buttons(child)

func _on_node_added(node: Node) -> void:
	# node_added fires again when a button is moved within the tree (e.g. into a
	# challenge window), so only connect once.
	if node is BaseButton and not node.button_down.is_connected(_play_click):
		node.button_down.connect(_play_click)
		node.mouse_entered.connect(_play_hover.bind(node))
		# A disabled (locked) button never emits button_down, so listen for the
		# raw press to give it its own "locked" sound instead of silence.
		node.gui_input.connect(_on_button_gui_input.bind(node))

func _play_hover(button: BaseButton) -> void:
	if sfx_volume <= 0.0 or _hover_player == null or _hover_player.stream == null:
		return
	if button.disabled:
		return
	var now: int = Time.get_ticks_msec()
	if now - _last_hover_ms < HOVER_MIN_GAP_MS or now - _last_click_ms < HOVER_AFTER_CLICK_MS:
		return
	_last_hover_ms = now
	_hover_player.pitch_scale = randf_range(0.97, 1.03)
	_hover_player.volume_db = HOVER_BASE_DB + linear_to_db(sfx_volume)
	_hover_player.play()

func _on_button_gui_input(event: InputEvent, button: BaseButton) -> void:
	if button.disabled and event is InputEventMouseButton \
			and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		play_locked()

func _play_click() -> void:
	_last_click_ms = Time.get_ticks_msec()
	if sfx_volume <= 0.0 or _click_stream == null or _click_players.is_empty():
		return
	var player: AudioStreamPlayer = _click_players[_click_next]
	_click_next = (_click_next + 1) % _click_players.size()
	player.stream = _click_stream
	player.pitch_scale = randf_range(0.96, 1.04)
	player.volume_db = CLICK_BASE_DB + linear_to_db(sfx_volume)
	player.play()

# One sample click: previews the Sound Effects slider, and is played by
# keyboard shortcuts that do the same job as a button (arrows, Enter, Esc).
func play_click_preview() -> void:
	_play_click()

func play_click() -> void:
	_play_click()

# ── Answer feedback sounds ────────────────────────────
# A chime when an SQL answer is right, a low buzz when it is wrong. Used by the
# lesson SQL challenges, the Folder Challenge, and Simulation Mode.
const CORRECT_SOUND_PATH := "res://audio/sfx/correct.wav"
const WRONG_SOUND_PATH   := "res://audio/sfx/wrong.wav"
const CORRECT_BASE_DB: float = -8.0
const WRONG_BASE_DB:   float = -9.0

var _correct_player: AudioStreamPlayer = null
var _wrong_player:   AudioStreamPlayer = null

# Played when the player presses a locked (disabled) button.
const LOCKED_SOUND_PATH := "res://audio/sfx/locked.wav"
const LOCKED_BASE_DB: float = -6.0
var _locked_player: AudioStreamPlayer = null

func _setup_answer_sounds() -> void:
	_correct_player = _make_sfx_player(CORRECT_SOUND_PATH)
	_wrong_player   = _make_sfx_player(WRONG_SOUND_PATH)
	_locked_player  = _make_sfx_player(LOCKED_SOUND_PATH)

func play_locked() -> void:
	if sfx_volume <= 0.0 or _locked_player == null or _locked_player.stream == null:
		return
	_locked_player.volume_db = LOCKED_BASE_DB + linear_to_db(sfx_volume)
	_locked_player.play()

func _make_sfx_player(path: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.bus = "Master"
	player.stream = load(path)
	add_child(player)
	return player

func play_correct() -> void:
	_play_answer_sound(_correct_player, CORRECT_BASE_DB)

func play_wrong() -> void:
	_play_answer_sound(_wrong_player, WRONG_BASE_DB)

func _play_answer_sound(player: AudioStreamPlayer, base_db: float) -> void:
	if sfx_volume <= 0.0 or player == null or player.stream == null:
		return
	_correct_player.stop()
	_wrong_player.stop()
	player.volume_db = base_db + linear_to_db(sfx_volume)
	player.play()

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return  # no settings file yet — first launch
	# Assigning through the setters above also refreshes tts_enabled/music_enabled.
	tts_volume           = cfg.get_value("settings", "tts_volume",           1.0)
	music_volume         = cfg.get_value("settings", "music_volume",         1.0)
	sfx_volume           = cfg.get_value("settings", "sfx_volume",           1.0)
	dark_overlay_enabled = cfg.get_value("settings", "dark_overlay_enabled", false)

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("settings", "tts_volume",           tts_volume)
	cfg.set_value("settings", "music_volume",         music_volume)
	cfg.set_value("settings", "sfx_volume",           sfx_volume)
	cfg.set_value("settings", "dark_overlay_enabled", dark_overlay_enabled)
	cfg.save(SETTINGS_PATH)

# ── Save / load ───────────────────────────────────────
# Progress persists between sessions, one file per user account
# in user://saves/<username>.cfg

func _save_path() -> String:
	return SAVES_DIR + current_user + ".cfg"

var sim_best_scores: Dictionary = {}   # "world" → best correct-answer streak

func save_game() -> void:
	if current_user.is_empty():
		return  # nobody logged in yet — nothing to save to
	DirAccess.make_dir_recursive_absolute(SAVES_DIR)
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "completed_lessons",        completed_lessons)
	cfg.set_value("progress", "completed_folder_quizzes", completed_folder_quizzes)
	cfg.set_value("progress", "sim_best_scores",          sim_best_scores)
	cfg.save(_save_path())

func load_game() -> void:
	completed_lessons        = {}
	completed_folder_quizzes = {}
	sim_best_scores          = {}
	if current_user.is_empty():
		return
	var cfg := ConfigFile.new()
	if cfg.load(_save_path()) != OK:
		return  # no save yet for this user — first login
	completed_lessons        = cfg.get_value("progress", "completed_lessons",        {})
	completed_folder_quizzes = cfg.get_value("progress", "completed_folder_quizzes", {})
	sim_best_scores          = cfg.get_value("progress", "sim_best_scores",          {})

func get_sim_best(world: String) -> int:
	return sim_best_scores.get(world, 0)

# Returns true if this run set a new best (caller can use that to celebrate it).
func report_sim_score(world: String, score: int) -> bool:
	var is_new_best: bool = score > get_sim_best(world)
	if is_new_best:
		sim_best_scores[world] = score
		save_game()
	return is_new_best

# ── Accounts ───────────────────────────────────────────
# Plain local credential store — offline single-PC use only, no server.
# Windows treats save files "Alice.cfg" and "alice.cfg" as the same file, so
# usernames that differ only by case must count as the same account. An exact
# match always wins; otherwise the stored spelling with the same letters is used.
func _find_account(username: String) -> String:
	var cfg := ConfigFile.new()
	if cfg.load(ACCOUNTS_PATH) != OK or not cfg.has_section("accounts"):
		return ""
	if cfg.has_section_key("accounts", username):
		return username
	var lower: String = username.to_lower()
	for key in cfg.get_section_keys("accounts"):
		if key.to_lower() == lower:
			return key
	return ""

func account_exists(username: String) -> bool:
	return _find_account(username) != ""

func check_password(username: String, password: String) -> bool:
	var key: String = _find_account(username)
	if key.is_empty():
		return false
	var cfg := ConfigFile.new()
	cfg.load(ACCOUNTS_PATH)
	return cfg.get_value("accounts", key, null) == password

func create_account(username: String, password: String) -> void:
	var cfg := ConfigFile.new()
	cfg.load(ACCOUNTS_PATH)  # ok if this fails — file may not exist yet
	cfg.set_value("accounts", username, password)
	cfg.save(ACCOUNTS_PATH)

func login(username: String) -> void:
	var stored: String = _find_account(username)
	current_user = stored if not stored.is_empty() else username
	load_game()
	_remember_session(current_user)

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
	sim_best_scores          = {}

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
	var vol:   int   = int(profile[0] * tts_volume)
	var pitch: float = profile[1]
	var rate:  float = profile[2]
	DisplayServer.tts_speak(text, "", vol, pitch, rate)

func stop_speaking() -> void:
	DisplayServer.tts_stop()
