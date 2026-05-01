extends Control

const HOTEL_LESSONS := [1, 2, 3, 4, 5, 6, 7]
const FF_LESSONS    := ["FF1", "FF2", "FF3"]

func _ready() -> void:
	$TopBar/ChangeWorldButton.pressed.connect(_on_change_world)

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func build_lessons() -> void:
	var list := $CenterContainer/ScrollContainer/LessonList

	for child in list.get_children():
		child.queue_free()

	var ids = HOTEL_LESSONS if GameManager.world == "hotel" else FF_LESSONS

	for id in ids:
		var btn := Button.new()
		btn.text = "Play Lesson " + str(id)
		var captured_id = id
		btn.pressed.connect(func():
			GameManager.lesson_id = captured_id
			get_tree().root.get_node("Main").show_screen("game")
		)
		list.add_child(btn)
