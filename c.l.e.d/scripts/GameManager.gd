extends Node
# ═══════════════════════════════════════════════════════
#  GAME MANAGER  |  scripts/GameManager.gd  (Autoload)
# ═══════════════════════════════════════════════════════

var world:       String = ""
var lesson_id           = null
var merged_mode: bool   = false   # true = all worlds shown as one path

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
	return stars

func get_stars(w: String, lid) -> int:
	return completed_lessons.get(w + "_" + str(lid), 0)

func is_folder_quiz_done(w: String, fi: int) -> bool:
	return completed_folder_quizzes.get(w + "_" + str(fi), false)

func complete_folder_quiz(w: String, fi: int) -> void:
	completed_folder_quizzes[w + "_" + str(fi)] = true

func get_sql_recap() -> Array:
	return _sql_commands_this_lesson.duplicate()

# ── Voice profiles per character ──────────────────────────
# Each entry: [volume, pitch, rate]
const VOICE_PROFILES: Dictionary = {
	"guest":           [85, 1.15, 1.05],
	"guest2":          [80, 1.40, 0.85],
	"guest3":          [95, 0.72, 1.30],
	"mgr":             [88, 0.68, 0.80],
	"cafe_customer":   [85, 1.30, 1.10],
	"cafe_supervisor": [87, 0.75, 0.85],
	"citizen":         [80, 1.10, 0.90],
	"chief":           [93, 0.62, 0.78],
	"visitor":         [78, 1.20, 0.93],
	"librarian":       [74, 0.88, 0.80],
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
