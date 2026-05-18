extends Node
# ═══════════════════════════════════════════════════════
#  GAME MANAGER  —  scripts/GameManager.gd  (Autoload)
#
#  Global state + TTS with pitch/rate per character.
#  No named voice IDs — uses system default voice,
#  pitch and rate make each character sound unique.
#
#  pitch:  < 1.0 = deeper/lower,  > 1.0 = higher
#  rate:   < 1.0 = slower,        > 1.0 = faster
#  volume: 0–100
# ═══════════════════════════════════════════════════════

var world:     String = ""
var lesson_id         = null

# ── Voice profiles per character ──────────────────────────
# Each entry: [volume, pitch, rate]
# Tweak these numbers until you like the sound.
# ─────────────────────────────────────────────────────────
const VOICE_PROFILES: Dictionary = {
	# ── Hotel World ──────────────────────────────────────
	"guest":              [85, 1.20, 1.0],   # friendly — slightly high, normal speed
	"guest2":             [85, 1.30, 0.9],   # Maya — higher pitch, slightly slow (nervous)
	"guest3":             [90, 0.80, 1.2],   # Mr. H — deep, fast (angry)
	"mgr":                [85, 0.75, 0.85],  # manager — deep, calm, authoritative
	# ── Cafe World ───────────────────────────────────────
	"cafe_customer":      [85, 1.25, 1.0],   # bright, cheerful
	"cafe_supervisor":    [85, 0.80, 0.90],  # calm authority
	# ── Police World ─────────────────────────────────────
	"citizen":            [85, 1.10, 1.05],  # slightly nervous
	"chief":              [90, 0.70, 0.85],  # very deep, firm
	# ── Library World ────────────────────────────────────
	"visitor":            [80, 1.20, 0.95],  # soft, curious
	"librarian":          [80, 0.85, 0.85],  # calm, measured
	# ── Shared ───────────────────────────────────────────
	"you":                [80, 1.00, 1.00],  # neutral — default voice
	"scene":              [75, 0.95, 0.90],  # narrator — slightly low, slow
}

# Fallback if char_key not in VOICE_PROFILES
const DEFAULT_PROFILE := [80, 1.00, 1.00]

# ─────────────────────────────────────────────────────────
func speak(text: String, char_key: String = "") -> void:
	DisplayServer.tts_stop()
	var profile: Array = VOICE_PROFILES.get(char_key, DEFAULT_PROFILE)
	var vol:   int   = profile[0]
	var pitch: float = profile[1]
	var rate:  float = profile[2]
	DisplayServer.tts_speak(text, "", vol, pitch, rate)

func stop_speaking() -> void:
	DisplayServer.tts_stop()
