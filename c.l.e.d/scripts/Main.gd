extends Control
# ═══════════════════════════════════════════════════════
#  MAIN  |  scripts/Main.gd
# ═══════════════════════════════════════════════════════

const BGM_MAP: Dictionary = {
	"menu":    "res://audio/bgm/Menu.mp3",
	"hotel":   "res://audio/bgm/Hotel_Lobby.mp3",
	"cafe":    "res://audio/bgm/Cafe.mp3",
	"library": "res://audio/bgm/Library.mp3",
}

var _current_bgm_key: String = ""
var _dark_overlay: ColorRect = null

func _ready() -> void:
	_setup_bgm_player()
	_build_dark_overlay()
	_play_bgm("menu")
	show_screen("login")

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

func _build_dark_overlay() -> void:
	_dark_overlay = ColorRect.new()
	_dark_overlay.name         = "DarkOverlay"
	_dark_overlay.color        = Color(0.0, 0.0, 0.0, 0.45)
	_dark_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dark_overlay.z_index      = 10
	_dark_overlay.anchor_right  = 1.0
	_dark_overlay.anchor_bottom = 1.0
	_dark_overlay.visible = GameManager.dark_overlay_enabled
	add_child(_dark_overlay)

func apply_dark_overlay() -> void:
	if _dark_overlay:
		_dark_overlay.visible = GameManager.dark_overlay_enabled

func show_screen(name: String) -> void:
	$LoginScreen.visible        = (name == "login")
	$WorldSelectScreen.visible  = (name == "world_select")
	$DashboardScreen.visible    = (name == "dashboard")
	$GameScreen.visible         = (name == "game")
	$CompleteScreen.visible     = (name == "complete" or name == "failed")
	$FolderQuizScreen.visible   = (name == "folder_quiz")

	match name:
		"login", "world_select":
			_play_bgm("menu")
		"game", "dashboard", "folder_quiz":
			_play_bgm(GameManager.world)
		"complete", "failed":
			pass

	if name == "dashboard":
		$DashboardScreen.build_lessons()
	if name == "game":
		$GameScreen.load_lesson(GameManager.lesson_id)
	if name == "complete" or name == "failed":
		$CompleteScreen.set_mode(name)
	if name == "folder_quiz":
		$FolderQuizScreen.start_quiz()
