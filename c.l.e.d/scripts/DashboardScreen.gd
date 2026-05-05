extends Control

const HOTEL_LESSONS := [1, 2, 3, 4, 5, 6, 7]
const CAFE_LESSONS    := ["C1", "C2", "C3", "C4", "C5", "C6", "C7"]

# Lesson names: id → "SQL TYPE — Title"
const HOTEL_NAMES: Dictionary = {
	1: "SELECT — Choose Your Response",
	2: "INSERT INTO — Book a New Guest",
	3: "SELECT WHERE — Search a Guest Record",
	4: "UPDATE SET — Fix a Wrong Record",
	5: "DELETE — Cancel a Booking",
	6: "ORDER BY — Sort Guest Records",
	7: "GROUP BY — Generate a Report",
}

const CAFE_NAMES: Dictionary = {
	"C1": "SELECT — Take the Order",
	"C2": "INSERT INTO — Log a New Order",
	"C3": "GROUP BY — End-of-Day Report",
	"C4": "SELECT WHERE — Find an Order",
	"C5": "UPDATE SET — Fix a Wrong Order",
	"C6": "DELETE — Cancel an Order",
	"C7": "ORDER BY — Sort the Menu Items",
}

func _ready() -> void:
	$TopBar/ChangeWorldButton.pressed.connect(_on_change_world)

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func build_lessons() -> void:
	var list := $CenterContainer/ScrollContainer/LessonList

	for child in list.get_children():
		child.queue_free()

	var ids   = HOTEL_LESSONS if GameManager.world == "hotel" else CAFE_LESSONS
	var names = HOTEL_NAMES   if GameManager.world == "hotel" else CAFE_NAMES

	for id in ids:
		var btn := Button.new()
		btn.text = names.get(id, "Lesson " + str(id))
		var captured_id = id
		btn.pressed.connect(func():
			GameManager.lesson_id = captured_id
			get_tree().root.get_node("Main").show_screen("game")
		)
		list.add_child(btn)
