extends Control
# ═══════════════════════════════════════════════════════
#  MAIN  —  scripts/Main.gd
# ═══════════════════════════════════════════════════════

const BGM_MAP: Dictionary = {
	"menu":    "res://audio/bgm/Menu.mp3",
	"hotel":   "res://audio/bgm/Hotel_Lobby.mp3",
	"cafe":    "res://audio/bgm/Cafe.mp3",
	"police":  "res://audio/bgm/Police_Station.mp3",
	"library": "res://audio/bgm/Library.mp3",
}

var _current_bgm_key: String = ""

func _ready() -> void:
	_setup_bgm_player()
	_play_bgm("menu")
	show_screen("world_select")

func _setup_bgm_player() -> void:
	if has_node("BGM"):
		return
	var bgm := AudioStreamPlayer.new()
	bgm.name = "BGM"
	bgm.bus = "Master"
	bgm.volume_db = 0.0
	add_child(bgm)

func _play_bgm(key: String) -> void:
	if not GameManager.music_enabled:
		return
	if _current_bgm_key == key and $BGM.playing:
		return
	_current_bgm_key = key
	var stream = load(BGM_MAP.get(key, BGM_MAP["menu"]))
	if stream == null:
		push_error("BGM: Could not load track: " + key)
		return
	if stream is AudioStreamMP3:
		stream.loop = true
	$BGM.stream = stream
	$BGM.play()

func resume_bgm() -> void:
	if _current_bgm_key == "":
		_play_bgm("menu")
	else:
		var stream = load(BGM_MAP.get(_current_bgm_key, BGM_MAP["menu"]))
		if stream and stream is AudioStreamMP3:
			stream.loop = true
		if stream:
			$BGM.stream = stream
		$BGM.play()

func pause_bgm() -> void:
	$BGM.stop()

func show_screen(name: String) -> void:
	$WorldSelectScreen.visible = (name == "world_select")
	$DashboardScreen.visible   = (name == "dashboard")
	$GameScreen.visible        = (name == "game")
	$CompleteScreen.visible    = (name == "complete" or name == "failed")

	match name:
		"world_select":
			_play_bgm("menu")
		"game", "dashboard":
			_play_bgm(GameManager.world)
		"complete", "failed":
			pass

	if name == "dashboard":
		$DashboardScreen.build_lessons()
	if name == "game":
		$GameScreen.load_lesson(GameManager.lesson_id)
	if name == "complete" or name == "failed":
		$CompleteScreen.set_mode(name)
