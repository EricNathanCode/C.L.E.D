extends Control

const HOTEL_LESSONS := [1, 2, 3, 4, 5, 6, 7]
const CAFE_LESSONS    := ["C1", "C2", "C3", "C4", "C5", "C6", "C7"]
const POLICE_LESSONS  := ["P1", "P2", "P3", "P4", "P5", "P6", "P7"]
const LIBRARY_LESSONS := ["L1", "L2", "L3", "L4", "L5", "L6", "L7"]

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

const POLICE_NAMES: Dictionary = {
	"P1": "SELECT — Handle a Citizen Report",
	"P2": "INSERT INTO — Log a New Case",
	"P3": "SELECT WHERE — Search a Suspect",
	"P4": "UPDATE SET — Update Case Status",
	"P5": "DELETE — Close a Cleared Case",
	"P6": "ORDER BY — Sort Cases by Priority",
	"P7": "GROUP BY — Crime Category Report",
}

const LIBRARY_NAMES: Dictionary = {
	"L1": "SELECT — Help a Visitor",
	"L2": "INSERT INTO — Register a New Borrower",
	"L3": "SELECT WHERE — Find a Book Record",
	"L4": "UPDATE SET — Update a Return Date",
	"L5": "DELETE — Remove an Overdue Record",
	"L6": "ORDER BY — Sort Books Alphabetically",
	"L7": "GROUP BY — Books by Genre Report",
}

func _ready() -> void:
	$TopBar/ChangeWorldButton.pressed.connect(_on_change_world)

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func build_lessons() -> void:
	var list := $CenterContainer/ScrollContainer/LessonList

	for child in list.get_children():
		child.queue_free()

	var ids: Array
	var names: Dictionary
	match GameManager.world:
		"hotel":   ids = HOTEL_LESSONS;   names = HOTEL_NAMES
		"cafe":    ids = CAFE_LESSONS;    names = CAFE_NAMES
		"police":  ids = POLICE_LESSONS;  names = POLICE_NAMES
		"library": ids = LIBRARY_LESSONS; names = LIBRARY_NAMES
		_:         ids = [];              names = {}

	for id in ids:
		var btn := Button.new()
		btn.text = names.get(id, "Lesson " + str(id))
		var captured_id = id
		btn.pressed.connect(func():
			GameManager.lesson_id = captured_id
			get_tree().root.get_node("Main").show_screen("game")
		)
		list.add_child(btn)
