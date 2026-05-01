extends Control

func _ready() -> void:
	show_screen("world_select")

func show_screen(name: String) -> void:
	$WorldSelectScreen.visible = (name == "world_select")
	$DashboardScreen.visible   = (name == "dashboard")
	$GameScreen.visible        = (name == "game")
	$CompleteScreen.visible    = (name == "complete")

	if name == "dashboard":
		$DashboardScreen.build_lessons()

	if name == "game":
		$GameScreen.load_lesson(GameManager.lesson_id)
