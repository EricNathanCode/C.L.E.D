extends Node
# ═══════════════════════════════════════════════════════
#  GAME MANAGER  —  scripts/GameManager.gd  (Autoload)
#
#  Global state + TTS with pitch/rate per character.
#  No named voice IDs — uses system default voice,
#  pitch and rate make each character sound unique.
#
#  volume: 0–100
#  pitch:  0.5 = very deep  │  1.0 = normal  │  2.0 = very high
#  rate:   0.5 = very slow  │  1.0 = normal  │  2.0 = very fast
# ═══════════════════════════════════════════════════════

var world:     String = ""
var lesson_id         = null

# ── TTS toggle — persists across scenes ──────────────────
var tts_enabled: bool = false

# ── Voice profiles per character ──────────────────────────
# Each entry: [volume, pitch, rate]
# ─────────────────────────────────────────────────────────
const VOICE_PROFILES: Dictionary = {

	# ── Hotel World ──────────────────────────────────────
	# guest   — friendly regular guest, warm and casual
	"guest":           [85, 1.15, 1.05],

	# guest2  — Maya, nervous/timid; higher pitch, hesitates
	"guest2":          [80, 1.40, 0.85],

	# guest3  — Mr. H, frustrated/angry; loud, deep, fast
	"guest3":          [95, 0.72, 1.30],

	# mgr     — hotel manager, calm authority; deep and measured
	"mgr":             [88, 0.68, 0.80],

	# ── Cafe World ───────────────────────────────────────
	# cafe_customer   — upbeat, cheerful; bright and quick
	"cafe_customer":   [85, 1.30, 1.10],

	# cafe_supervisor — composed authority; low and steady
	"cafe_supervisor": [87, 0.75, 0.85],

	# ── Police World ─────────────────────────────────────
	# citizen  — nervous civilian reporting a case; slightly shaky
	"citizen":         [80, 1.10, 0.90],

	# chief    — police chief, commanding; very deep and slow/firm
	"chief":           [93, 0.62, 0.78],

	# ── Library World ────────────────────────────────────
	# visitor  — curious library visitor; soft and a bit hesitant
	"visitor":         [78, 1.20, 0.93],

	# librarian — hushed and precise; low volume, deliberate pace
	"librarian":       [74, 0.88, 0.80],

	# ── Shared ───────────────────────────────────────────
	# you   — player character; plain neutral voice
	"you":             [82, 1.00, 1.00],

	# scene — narrator; slightly low, slow and clear
	"scene":           [78, 0.90, 0.85],
}

# Fallback if char_key not in VOICE_PROFILES
const DEFAULT_PROFILE := [80, 1.00, 1.00]

# ─────────────────────────────────────────────────────────
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
