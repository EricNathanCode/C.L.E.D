extends Control

func _ready() -> void:
	_setup_bgm()
	show_screen("world_select")

func _setup_bgm() -> void:
	# Create the BGM player in code — no tscn dependency
	if has_node("BGM"):
		return  # already exists, skip

	var bgm := AudioStreamPlayer.new()
	bgm.name = "BGM"
	bgm.bus = "Master"
	bgm.volume_db = 0.0
	add_child(bgm)

	var stream = load("res://audio/bgm/Menu.mp3")
	if stream == null:
		push_error("BGM: Could not load res://audio/bgm/Menu.mp3 — check the file is in the right folder")
		return

	# Force loop on MP3
	if stream is AudioStreamMP3:
		stream.loop = true

	bgm.stream = stream
	bgm.play()

func show_screen(name: String) -> void:
	$WorldSelectScreen.visible = (name == "world_select")
	$DashboardScreen.visible   = (name == "dashboard")
	$GameScreen.visible        = (name == "game")
	$CompleteScreen.visible    = (name == "complete" or name == "failed")

	if has_node("BGM"):
		if name == "world_select":
			if not $BGM.playing:
				$BGM.play()
		else:
			$BGM.stop()

	if name == "dashboard":
		$DashboardScreen.build_lessons()

	if name == "game":
		$GameScreen.load_lesson(GameManager.lesson_id)

	if name == "complete" or name == "failed":
		$CompleteScreen.set_mode(name)
