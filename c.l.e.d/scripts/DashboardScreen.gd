extends Control

const HOTEL_LESSONS  := [1, 2, 3, 4, 5, 6, 7]
const CAFE_LESSONS   := ["C1", "C2", "C3", "C4", "C5", "C6", "C7"]
const POLICE_LESSONS := ["P1", "P2", "P3", "P4", "P5", "P6", "P7"]
const LIBRARY_LESSONS:= ["L1", "L2", "L3", "L4", "L5", "L6", "L7"]

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

const WORLD_DISPLAY: Dictionary = {
	"hotel":   "Hotel World",
	"cafe":    "Cafe World",
	"police":  "Police Station",
	"library": "Library",
}

func _ready() -> void:
	# Full dark background
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.08, 0.11, 1.0)
	bg.anchor_right  = 1.0
	bg.anchor_bottom = 1.0
	bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	bg.z_index       = -10
	add_child(bg)

	# Top bar background strip
	var tb_bg := ColorRect.new()
	tb_bg.color        = Color(0.05, 0.06, 0.09, 1.0)
	tb_bg.anchor_right = 1.0
	tb_bg.offset_bottom = 50.0
	tb_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tb_bg.z_index      = -1
	add_child(tb_bg)

	# Top bar bottom accent line
	var tb_line := ColorRect.new()
	tb_line.color        = Color("#F59E0B")
	tb_line.anchor_right = 1.0
	tb_line.offset_top   = 49.0
	tb_line.offset_bottom = 51.0
	tb_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tb_line.z_index      = -1
	add_child(tb_line)

	$TopBar/ChangeWorldButton.pressed.connect(_on_change_world)

	# Style TopBar content
	$TopBar/ScreenLabel.add_theme_font_size_override("font_size", 13)
	$TopBar/ScreenLabel.add_theme_color_override("font_color", Color(0.50, 0.55, 0.65))

	_style_btn($TopBar/ChangeWorldButton, "ghost", 14)
	$TopBar/ChangeWorldButton.text = "← Worlds"

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func build_lessons() -> void:
	var list := $CenterContainer/ScrollContainer/LessonList

	for child in list.get_children():
		child.queue_free()

	# Update TopBar label with current world
	var world_label: String = WORLD_DISPLAY.get(GameManager.world, GameManager.world.capitalize()).to_upper()
	$TopBar/ScreenLabel.text = "  " + world_label + "   ·   LESSONS"

	# World title — amber accent header
	$WorldTitle.text = WORLD_DISPLAY.get(GameManager.world, GameManager.world.capitalize())
	$WorldTitle.add_theme_font_size_override("font_size", 26)
	$WorldTitle.add_theme_color_override("font_color", Color("#F59E0B"))
	$WorldTitle.add_theme_constant_override("outline_size", 1)
	$WorldTitle.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.6))

	var ids: Array
	var names: Dictionary
	match GameManager.world:
		"hotel":   ids = HOTEL_LESSONS;   names = HOTEL_NAMES
		"cafe":    ids = CAFE_LESSONS;    names = CAFE_NAMES
		"police":  ids = POLICE_LESSONS;  names = POLICE_NAMES
		"library": ids = LIBRARY_LESSONS; names = LIBRARY_NAMES
		_:         ids = [];              names = {}

	var num: int = 0
	for id in ids:
		num += 1
		var btn := Button.new()
		btn.text = "%02d  " % num + names.get(id, "Lesson " + str(id))
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
		var captured_id = id
		btn.pressed.connect(func():
			GameManager.lesson_id = captured_id
			get_tree().root.get_node("Main").show_screen("game")
		)
		_style_btn(btn, "secondary", 14)
		list.add_child(btn)

# ── 3-variant button style ────────────────────────────
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 16) -> void:
	btn.add_theme_font_size_override("font_size", font_size)
	var s := StyleBoxFlat.new()
	s.set_corner_radius_all(8)

	match variant:
		"primary":
			btn.add_theme_color_override("font_color", Color(0.10, 0.06, 0.00))
			s.bg_color     = Color("#F59E0B")
			s.border_color = Color("#D97706")
			s.set_border_width_all(0)
			s.content_margin_left   = 24; s.content_margin_right  = 24
			s.content_margin_top    = 12; s.content_margin_bottom = 12
		"secondary":
			btn.add_theme_color_override("font_color", Color(0.85, 0.88, 0.93))
			s.bg_color     = Color(0.12, 0.14, 0.20, 0.95)
			s.border_color = Color(0.26, 0.31, 0.42)
			s.set_border_width_all(2)
			s.content_margin_left   = 16; s.content_margin_right  = 16
			s.content_margin_top    = 10; s.content_margin_bottom = 10
		"ghost":
			btn.add_theme_color_override("font_color", Color(0.55, 0.60, 0.70))
			s.bg_color     = Color(0, 0, 0, 0)
			s.border_color = Color(0.30, 0.35, 0.46)
			s.set_border_width_all(2)
			s.content_margin_left   = 14; s.content_margin_right  = 14
			s.content_margin_top    = 8;  s.content_margin_bottom = 8

	var h := s.duplicate() as StyleBoxFlat
	var p := s.duplicate() as StyleBoxFlat

	match variant:
		"primary":
			h.bg_color = Color("#FBBF24")
			p.bg_color = Color("#D97706")
		"secondary":
			h.bg_color     = Color(0.18, 0.22, 0.30, 0.95)
			h.border_color = Color("#F59E0B")
			p.bg_color     = Color(0.08, 0.10, 0.15, 0.95)
		"ghost":
			h.bg_color     = Color(0.12, 0.15, 0.21, 0.50)
			h.border_color = Color(0.52, 0.58, 0.70)
			p.bg_color     = Color(0.08, 0.10, 0.14, 0.50)

	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)
