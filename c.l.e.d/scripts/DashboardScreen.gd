extends Control

# ── Data script paths for comic-strip previews ────────────
const _DATA_PATHS: Dictionary = {
	"hotel":   "res://scripts/data/HotelData.gd",
	"cafe":    "res://scripts/data/CafeData.gd",
	"airport": "res://scripts/data/AirportData.gd",
	"library": "res://scripts/data/LibraryData.gd",
}

# ── Lesson metadata ───────────────────────────────────────
const HOTEL_LESSONS  := [1,2,3,4,5, 8,16,17,18,19,20, 6,21,7,22,23,24]
const CAFE_LESSONS   := ["C1","C2","C4","C5","C6", "C8","C16","C17","C18","C19","C20", "C7","C21","C3","C22","C23","C24"]
const AIRPORT_LESSONS:= ["A1","A2","A3","A4","A5", "A8","A16","A17","A18","A19","A20", "A6","A21","A7","A22","A23","A24"]
const LIBRARY_LESSONS:= ["L1","L2","L3","L4","L5", "L8","L16","L17","L18","L19","L20", "L6","L21","L7","L22","L23","L24"]

const HOTEL_NAMES: Dictionary = {
	1:  "SELECT | View All Guest Records",
	2:  "INSERT INTO | Book a New Guest",
	3:  "SELECT WHERE | Search a Guest Record",
	4:  "UPDATE SET | Fix a Wrong Record",
	5:  "DELETE | Cancel a Booking",
	6:  "ORDER BY | Sort Guest Records",
	7:  "GROUP BY | Generate a Report",
	8:  "IS NULL | Find Missing Guest Emails",
	16: "SELECT DISTINCT | Unique Guest Types",
	17: "AND / OR | Filter Multiple Conditions",
	18: "BETWEEN | Guests in a Price Range",
	19: "LIKE | Search by Partial Name",
	20: "IN | Guests from Specific Cities",
	21: "LIMIT | Show Top 5 Bookings",
	22: "COUNT / SUM / AVG | Booking Statistics",
	23: "HAVING | Rooms with Many Bookings",
	24: "AS | Rename a Calculated Column",
}
const CAFE_NAMES: Dictionary = {
	"C1":  "SELECT | View All Orders",
	"C2":  "INSERT INTO | Log a New Order",
	"C3":  "GROUP BY | End-of-Day Report",
	"C4":  "SELECT WHERE | Find an Order",
	"C5":  "UPDATE SET | Fix a Wrong Order",
	"C6":  "DELETE | Cancel an Order",
	"C7":  "ORDER BY | Sort the Menu Items",
	"C8":  "IS NULL | Find Orders with No Notes",
	"C16": "SELECT DISTINCT | Unique Drink Types",
	"C17": "AND / OR | Filter Multiple Conditions",
	"C18": "BETWEEN | Orders in a Price Range",
	"C19": "LIKE | Search by Partial Item Name",
	"C20": "IN | Orders from Specific Categories",
	"C21": "LIMIT | Show Top 5 Orders",
	"C22": "COUNT / SUM / AVG | Sales Statistics",
	"C23": "HAVING | Items Ordered Many Times",
	"C24": "AS | Rename a Calculated Column",
}
const AIRPORT_NAMES: Dictionary = {
	"A1":  "SELECT | View the Passenger Manifest",
	"A2":  "INSERT INTO | Check In a New Passenger",
	"A3":  "SELECT WHERE | Find a Lost Boarding Pass",
	"A4":  "UPDATE SET | Fix a Misspelled Name",
	"A5":  "DELETE | Cancel a Booking",
	"A6":  "ORDER BY | Sort the Passenger Manifest",
	"A7":  "GROUP BY | Seat Class Load Report",
	"A8":  "IS NULL | Find Missing Meal Preferences",
	"A16": "SELECT DISTINCT | Unique Destinations",
	"A17": "AND / OR | Filter Multiple Conditions",
	"A18": "BETWEEN | Fares in a Price Range",
	"A19": "LIKE | Search by Partial Name",
	"A20": "IN | Bookings to Specific Destinations",
	"A21": "LIMIT | Show Top 5 Passengers",
	"A22": "COUNT / SUM / AVG | Passenger Statistics",
	"A23": "HAVING | Destinations with Many Bookings",
	"A24": "AS | Rename a Calculated Column",
}
const LIBRARY_NAMES: Dictionary = {
	"L1":  "SELECT | View the Full Catalog",
	"L2":  "INSERT INTO | Register a New Borrower",
	"L3":  "SELECT WHERE | Find a Book Record",
	"L4":  "UPDATE SET | Update a Return Date",
	"L5":  "DELETE | Remove an Overdue Record",
	"L6":  "ORDER BY | Sort Books Alphabetically",
	"L7":  "GROUP BY | Books by Genre Report",
	"L8":  "IS NULL | Find Unreturned Books",
	"L16": "SELECT DISTINCT | Unique Book Genres",
	"L17": "AND / OR | Filter Multiple Conditions",
	"L18": "BETWEEN | Books in a Publication Range",
	"L19": "LIKE | Search by Partial Title",
	"L20": "IN | Books of Specific Genres",
	"L21": "LIMIT | Show Top 5 Books",
	"L22": "COUNT / SUM / AVG | Collection Statistics",
	"L23": "HAVING | Genres with Many Books",
	"L24": "AS | Rename a Calculated Column",
}
const WORLD_DISPLAY: Dictionary = {
	"hotel":   "Hotel World",
	"cafe":    "Cafe World",
	"airport": "Airport World",
	"library": "Library",
}

# ── Folder groupings per world ────────────────────────────
const HOTEL_FOLDERS := [
	{ "name": "Basic SQL",            "ids": [1,2,3,4,5] },
	{ "name": "Filtering Rows",       "ids": [8,16,17,18,19,20] },
	{ "name": "Sorting & Aggregates", "ids": [6,21,7,22,23,24] },
]
const CAFE_FOLDERS := [
	{ "name": "Basic SQL",            "ids": ["C1","C2","C4","C5","C6"] },
	{ "name": "Filtering Rows",       "ids": ["C8","C16","C17","C18","C19","C20"] },
	{ "name": "Sorting & Aggregates", "ids": ["C7","C21","C3","C22","C23","C24"] },
]
const AIRPORT_FOLDERS := [
	{ "name": "Basic SQL",            "ids": ["A1","A2","A3","A4","A5"] },
	{ "name": "Filtering Rows",       "ids": ["A8","A16","A17","A18","A19","A20"] },
	{ "name": "Sorting & Aggregates", "ids": ["A6","A21","A7","A22","A23","A24"] },
]
const LIBRARY_FOLDERS := [
	{ "name": "Basic SQL",            "ids": ["L1","L2","L3","L4","L5"] },
	{ "name": "Filtering Rows",       "ids": ["L8","L16","L17","L18","L19","L20"] },
	{ "name": "Sorting & Aggregates", "ids": ["L6","L21","L7","L22","L23","L24"] },
]

const SQL_GLOSSARY: Array = [
	["SELECT",       "Retrieves data from one or more columns in a table.",
		"SELECT column1, column2\nFROM table_name;"],
	["INSERT INTO",  "Adds a new row of data into a table.",
		"INSERT INTO table_name (col1, col2)\nVALUES ('value1', 'value2');"],
	["SELECT WHERE", "Retrieves rows filtered by a specific condition.",
		"SELECT * FROM table_name\nWHERE column = 'value';"],
	["UPDATE SET",   "Modifies values in existing rows of a table.",
		"UPDATE table_name\nSET column = 'new_value'\nWHERE condition;"],
	["DELETE",       "Removes rows from a table based on a condition.",
		"DELETE FROM table_name\nWHERE column = 'value';"],
	["ORDER BY",     "Sorts result rows in ascending or descending order.",
		"SELECT * FROM table_name\nORDER BY column ASC;"],
	["GROUP BY",           "Groups rows that share the same column value.",
		"SELECT column, COUNT(*)\nFROM table_name\nGROUP BY column;"],
	["IS NULL / IS NOT NULL", "Checks whether a column's value is missing or present.",
		"SELECT * FROM table_name\nWHERE column IS NULL;\n\nSELECT * FROM table_name\nWHERE column IS NOT NULL;"],
	["SELECT DISTINCT", "Returns only unique (non-duplicate) values in a result column.", "SELECT DISTINCT column\nFROM table_name;"],
	["AND / OR",        "AND requires ALL conditions. OR requires AT LEAST ONE condition.", "SELECT * FROM t WHERE a=1 AND b=2;\nSELECT * FROM t WHERE a=1 OR b=2;"],
	["BETWEEN",         "Filters rows where a value falls within an inclusive range.", "SELECT * FROM t\nWHERE price BETWEEN 10 AND 50;"],
	["LIKE",            "Pattern matching. % = any characters, _ = one character.", "SELECT * FROM t\nWHERE name LIKE 'S%';"],
	["IN",              "Filters rows where a column value matches any item in a list.", "SELECT * FROM t\nWHERE city IN ('Manila','Cebu');"],
	["LIMIT",           "Restricts how many rows are returned by a query.", "SELECT * FROM t\nLIMIT 10;"],
	["COUNT / SUM / AVG","Aggregate functions: COUNT counts rows, SUM adds values, AVG averages them.", "SELECT COUNT(id) FROM t;\nSELECT SUM(price) FROM t;\nSELECT AVG(price) FROM t;"],
	["HAVING",          "Filters groups after GROUP BY like WHERE but for grouped data.", "SELECT col, COUNT(*) FROM t\nGROUP BY col\nHAVING COUNT(*) > 1;"],
	["AS (Alias)",      "Renames a column or expression in the result. Does not change the table.", "SELECT price * 1.12 AS price_with_tax\nFROM orders;"],
]

# ── Node refs ─────────────────────────────────────────────
@onready var _screen_lbl    := $TopBar/ScreenLabel
@onready var _back_btn      := $TopBar/ChangeWorldButton
@onready var _world_title   := $ContentRow/LeftPanel/LeftPad/WorldTitle
@onready var _lesson_list   := $ContentRow/LeftPanel/ListPad/ScrollContainer/LessonList
@onready var _preview_title := $ContentRow/RightPanel/RightPad/PreviewArea/PreviewTitle
@onready var _comic_strip   := $ContentRow/RightPanel/RightPad/PreviewArea/ComicStrip

# Hovering lesson buttons rebuilds the comic-strip preview on every
# mouse_entered event, so textures must be cached — without this,
# any background/sprite not yet Godot-imported gets fully re-decoded
# from disk on every single hover.
var _preview_tex_cache: Dictionary = {}
var _glossary_overlay: Control = null
var _sim_picker_overlay: Control = null
var _sim_picker_title_lbl: Label = null
var _sim_picker_body: VBoxContainer = null

func _ready() -> void:
	# Full dark background
	var bg := ColorRect.new()
	bg.color        = Color(0.07, 0.08, 0.11, 1.0)
	bg.anchor_right  = 1.0
	bg.anchor_bottom = 1.0
	bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	bg.z_index       = -10
	add_child(bg)

	# Top bar bg strip
	var tb_bg := ColorRect.new()
	tb_bg.color         = Color(0.05, 0.06, 0.09, 1.0)
	tb_bg.anchor_right  = 1.0
	tb_bg.offset_bottom = 50.0
	tb_bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_bg.z_index       = -1
	add_child(tb_bg)

	# Top bar amber accent line
	var tb_line := ColorRect.new()
	tb_line.color         = Color("#F59E0B")
	tb_line.anchor_right  = 1.0
	tb_line.offset_top    = 49.0
	tb_line.offset_bottom = 51.0
	tb_line.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_line.z_index       = -1
	add_child(tb_line)

	_back_btn.pressed.connect(_on_change_world)
	_style_btn(_back_btn, "ghost", 14)
	_back_btn.text = "← Worlds"

	_build_glossary()

	var sim_btn := Button.new()
	sim_btn.text = "🎮  Simulation"
	sim_btn.pressed.connect(_toggle_sim_picker)
	_style_btn(sim_btn, "secondary", 13)
	$TopBar.add_child(sim_btn)

	_build_sim_picker()

	_screen_lbl.add_theme_font_size_override("font_size", 13)
	_screen_lbl.add_theme_color_override("font_color", Color(0.50, 0.55, 0.65))

	# Preview title styling
	_preview_title.add_theme_font_size_override("font_size", 11)
	_preview_title.add_theme_color_override("font_color", Color(0.40, 0.45, 0.58))
	_preview_title.add_theme_constant_override("outline_size", 0)


func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func _start_simulation(folder: String, lesson_index: int = 0) -> void:
	GameManager.sim_folder = folder
	GameManager.sim_lesson_index = lesson_index
	_toggle_sim_picker()
	get_tree().root.get_node("Main").show_screen("simulation")

func build_lessons() -> void:
	for child in _lesson_list.get_children():
		child.queue_free()

	_world_title.add_theme_font_size_override("font_size", 22)
	_world_title.add_theme_color_override("font_color", Color("#F59E0B"))

	var world_label: String = WORLD_DISPLAY.get(GameManager.world, GameManager.world.capitalize()).to_upper()
	_screen_lbl.text = "  " + world_label + "   ·   LESSONS"
	_world_title.text = WORLD_DISPLAY.get(GameManager.world, GameManager.world.capitalize())

	var ids: Array
	var names: Dictionary
	var folders: Array
	match GameManager.world:
		"hotel":
			ids = HOTEL_LESSONS;   names = HOTEL_NAMES;   folders = HOTEL_FOLDERS
		"cafe":
			ids = CAFE_LESSONS;    names = CAFE_NAMES;    folders = CAFE_FOLDERS
		"airport":
			ids = AIRPORT_LESSONS; names = AIRPORT_NAMES; folders = AIRPORT_FOLDERS
		"library":
			ids = LIBRARY_LESSONS; names = LIBRARY_NAMES; folders = LIBRARY_FOLDERS
		_:
			ids = [];              names = {};             folders = []

	# DEBUG: set true to bypass all locking for testing
	const DEBUG_UNLOCK := false

	# Build sequential number map: lesson_id → display number (01, 02…)
	var num_map: Dictionary = {}
	for i in range(ids.size()):
		num_map[ids[i]] = i + 1

	for fi in range(folders.size()):
		var folder_name: String  = folders[fi]["name"]
		var folder_ids: Array    = folders[fi]["ids"]

		# Folder locked if previous folder's challenge not yet passed
		# DEBUG: folder locking disabled | re-enable by setting DEBUG_UNLOCK to false
		var folder_locked: bool = (not DEBUG_UNLOCK) and fi > 0 and not GameManager.is_folder_quiz_done(GameManager.world, fi - 1)

		# Count completions for the progress badge
		var done: int = 0
		for fid in folder_ids:
			if GameManager.get_stars(GameManager.world, fid) > 0:
				done += 1
		var badge: String = "  (%d/%d)" % [done, folder_ids.size()]

		# ── Folder header button ─────────────────────────
		var hdr := Button.new()
		hdr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hdr.alignment = HORIZONTAL_ALIGNMENT_LEFT

		if folder_locked:
			hdr.text = "🔒  " + folder_name + badge
			hdr.disabled = true
			_style_folder_btn_locked(hdr)
		else:
			hdr.text = "▶  " + folder_name + badge
			_style_folder_btn(hdr)
		_lesson_list.add_child(hdr)

		# ── Lesson container (starts collapsed) ──────────
		var box := VBoxContainer.new()
		box.visible = false
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		box.add_theme_constant_override("separation", 4)
		_lesson_list.add_child(box)

		# Toggle collapse only for unlocked folders
		if not folder_locked:
			var cap_hdr    = hdr
			var cap_box    = box
			var cap_fname  = folder_name
			var cap_badge  = badge
			hdr.pressed.connect(func():
				cap_box.visible = not cap_box.visible
				cap_hdr.text = ("▼  " if cap_box.visible else "▶  ") + cap_fname + cap_badge
			)

		# ── Lesson buttons inside the folder ─────────────
		for fid in folder_ids:
			var captured_id = fid
			var num: int = num_map.get(fid, 0)

			# Lock if previous lesson in the full ordered list is not yet completed
			var idx_in_all: int = ids.find(fid)
			var is_locked: bool = (not DEBUG_UNLOCK) and idx_in_all > 0 and GameManager.get_stars(GameManager.world, ids[idx_in_all - 1]) == 0

			var row := HBoxContainer.new()
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_theme_constant_override("separation", 6)

			# Indent spacer
			var spacer := Control.new()
			spacer.custom_minimum_size = Vector2(18, 0)
			row.add_child(spacer)

			var btn := Button.new()
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

			if is_locked:
				btn.text = "🔒  %02d  " % num + names.get(fid, "Lesson " + str(fid))
				btn.disabled = true
				_style_btn(btn, "locked", 14)
			else:
				btn.text = "%02d  " % num + names.get(fid, "Lesson " + str(fid))
				btn.pressed.connect(func():
					GameManager.lesson_id = captured_id
					get_tree().root.get_node("Main").show_screen("game")
				)
				btn.mouse_entered.connect(func(): _show_preview(captured_id))
				_style_btn(btn, "secondary", 14)

			row.add_child(btn)

			var stars: int = GameManager.get_stars(GameManager.world, captured_id)
			if stars > 0:
				var star_lbl := Label.new()
				star_lbl.text = "★".repeat(stars) + "☆".repeat(3 - stars)
				star_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				star_lbl.add_theme_font_size_override("font_size", 14)
				star_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
				row.add_child(star_lbl)

			box.add_child(row)

		# ── Folder challenge button (every folder, including the last) ────
		if not folder_locked:
			var is_last_folder: bool = fi == folders.size() - 1
			var all_lessons_done: bool = DEBUG_UNLOCK or true
			if not DEBUG_UNLOCK:
				all_lessons_done = true
				for fid in folder_ids:
					if GameManager.get_stars(GameManager.world, fid) == 0:
						all_lessons_done = false
						break
			var quiz_done: bool = GameManager.is_folder_quiz_done(GameManager.world, fi)

			var sep := HSeparator.new()
			sep.add_theme_constant_override("separation", 4)
			box.add_child(sep)

			var quiz_row := HBoxContainer.new()
			quiz_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			quiz_row.add_theme_constant_override("separation", 6)
			var qsp := Control.new()
			qsp.custom_minimum_size = Vector2(18, 0)
			quiz_row.add_child(qsp)

			var qbtn := Button.new()
			qbtn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			qbtn.alignment = HORIZONTAL_ALIGNMENT_LEFT

			if quiz_done:
				var cap_fi2 := fi
				qbtn.text = "✓  Folder Challenge - Redo"
				qbtn.pressed.connect(func():
					GameManager.current_quiz_folder_idx = cap_fi2
					get_tree().root.get_node("Main").show_screen("folder_quiz")
				)
				_style_btn(qbtn, "ghost", 13)
			elif all_lessons_done:
				var cap_fi := fi
				qbtn.text = "⚡  FOLDER CHALLENGE - Final Test" if is_last_folder else "⚡  FOLDER CHALLENGE - Unlock Next Chapter"
				qbtn.pressed.connect(func():
					GameManager.current_quiz_folder_idx = cap_fi
					get_tree().root.get_node("Main").show_screen("folder_quiz")
				)
				_style_btn(qbtn, "quiz", 13)
			else:
				qbtn.text = "🔒  Folder Challenge - Complete all lessons first"
				qbtn.disabled = true
				_style_btn(qbtn, "locked", 13)

			quiz_row.add_child(qbtn)
			box.add_child(quiz_row)

	# Show placeholder until hover
	_reset_preview()

# ── Comic panel preview ───────────────────────────────────
func _reset_preview() -> void:
	for child in _comic_strip.get_children():
		child.queue_free()
	# Placeholder panel | styled like a blank comic page
	var wrap := PanelContainer.new()
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrap.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	var ws := StyleBoxFlat.new()
	ws.bg_color = Color(0.08, 0.09, 0.13, 1.0)
	ws.border_color = Color(0.22, 0.27, 0.38)
	ws.set_border_width_all(2)
	ws.set_corner_radius_all(4)
	wrap.add_theme_stylebox_override("panel", ws)
	var ph := Label.new()
	ph.text = "Hover a lesson\nto preview its story"
	ph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ph.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	ph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ph.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	ph.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ph.add_theme_font_size_override("font_size", 15)
	ph.add_theme_color_override("font_color", Color(0.28, 0.32, 0.44))
	wrap.add_child(ph)
	_comic_strip.add_child(wrap)

func _get_lesson_steps(lesson_id) -> Array:
	var path: String = _DATA_PATHS.get(GameManager.world, "")
	if path.is_empty():
		return []
	var node = load(path).new()
	var steps: Array = node.LESSONS.get(lesson_id, [])
	node.free()
	return steps

func _collect_frames(lesson_id) -> Array:
	var steps: Array = _get_lesson_steps(lesson_id)
	var frames: Array = []

	# Grab scene opener + up to 3 NPC lines, carrying npc sprite path
	var got_scene := false
	for step in steps:
		if step.get("type", "") != "dialogue":
			continue
		var ch: String = step.get("char", "")
		var npc_raw: String = step.get("npc", "")
		if ch == "scene" and not got_scene:
			frames.append({ "name": "SCENE", "text": step.get("text", ""), "is_scene": true,  "npc": npc_raw })
			got_scene = true
		elif ch != "you" and ch != "scene":
			frames.append({ "name": step.get("name", ch.to_upper()), "text": step.get("text", ""), "is_scene": false, "npc": npc_raw })
		if frames.size() >= 4:
			break
	return frames

func _load_preview_texture(res_path: String) -> Texture2D:
	if _preview_tex_cache.has(res_path):
		return _preview_tex_cache[res_path]

	var tex: Texture2D = null

	if ResourceLoader.exists(res_path):
		tex = ResourceLoader.load(res_path) as Texture2D

	# Fallback for assets Godot hasn't generated an .import cache entry
	# for yet (e.g. a background just added to the project) — read the
	# raw file bytes directly instead of relying on the resource cache.
	if tex == null:
		var abs_path: String = ProjectSettings.globalize_path(res_path)
		var fa := FileAccess.open(abs_path, FileAccess.READ)
		if fa:
			var data: PackedByteArray = fa.get_buffer(fa.get_length())
			fa.close()
			var img := Image.new()
			var loaded := false
			if res_path.ends_with(".jpg") or res_path.ends_with(".jpeg"):
				loaded = img.load_jpg_from_buffer(data) == OK
			else:
				loaded = img.load_png_from_buffer(data) == OK
			if loaded:
				if img.get_format() != Image.FORMAT_RGBA8:
					img.convert(Image.FORMAT_RGBA8)
				tex = ImageTexture.create_from_image(img)

	if tex == null:
		var img2 := Image.new()
		var abs_path2: String = ProjectSettings.globalize_path(res_path)
		if img2.load(abs_path2) == OK:
			if img2.get_format() != Image.FORMAT_RGBA8:
				img2.convert(Image.FORMAT_RGBA8)
			tex = ImageTexture.create_from_image(img2)

	if tex != null:
		_preview_tex_cache[res_path] = tex
	return tex

func _show_preview(lesson_id) -> void:
	for child in _comic_strip.get_children():
		child.queue_free()

	var frames: Array = _collect_frames(lesson_id)
	if frames.is_empty():
		_reset_preview()
		return

	# ── Comic page outer wrapper ──────────────────────────
	# Outer dark page background
	var page := PanelContainer.new()
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	var page_s := StyleBoxFlat.new()
	page_s.bg_color = Color(0.06, 0.07, 0.10, 1.0)
	page_s.border_color = Color(0.30, 0.36, 0.50)
	page_s.set_border_width_all(3)
	page_s.set_corner_radius_all(6)
	page_s.content_margin_left   = 8
	page_s.content_margin_right  = 8
	page_s.content_margin_top    = 8
	page_s.content_margin_bottom = 8
	page.add_theme_stylebox_override("panel", page_s)
	_comic_strip.add_child(page)

	var rows := VBoxContainer.new()
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rows.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	rows.add_theme_constant_override("separation", 6)
	page.add_child(rows)

	# ── Row layouts | classic comic book grid ─────────────
	# We have up to 4 frames. Layout:
	#   Row 1: [panel0 wide (2/3)] [panel1 narrow (1/3)]
	#   Row 2: [panel2 narrow(1/3)] [panel3 wide (2/3)]
	#   Row 3: [panel4 full-width]   (only if 5th frame exists)

	var f := frames

	if f.size() >= 2:
		# Row 1: wide | narrow
		var row1 := HBoxContainer.new()
		row1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row1.size_flags_vertical   = Control.SIZE_EXPAND_FILL
		row1.add_theme_constant_override("separation", 6)
		rows.add_child(row1)
		var p0 := _build_comic_panel(f[0], 2.0)
		var p1 := _build_comic_panel(f[1], 1.0)
		row1.add_child(p0)
		row1.add_child(p1)

	if f.size() >= 4:
		# Row 2: narrow | wide
		var row2 := HBoxContainer.new()
		row2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row2.size_flags_vertical   = Control.SIZE_EXPAND_FILL
		row2.add_theme_constant_override("separation", 6)
		rows.add_child(row2)
		var p2 := _build_comic_panel(f[2], 1.0)
		var p3 := _build_comic_panel(f[3], 2.0)
		row2.add_child(p2)
		row2.add_child(p3)
	elif f.size() == 3:
		# Row 2: full-width single panel
		rows.add_child(_build_comic_panel(f[2], 1.0, true))
	elif f.size() == 1:
		# Only 1 frame | single wide panel
		rows.add_child(_build_comic_panel(f[0], 1.0, true))

	# ── CTA strip at bottom ───────────────────────────────
	var cta := Label.new()
	cta.text = "Click to start  ▶"
	cta.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	cta.add_theme_font_size_override("font_size", 11)
	cta.add_theme_color_override("font_color", Color("#F59E0B"))
	_comic_strip.add_child(cta)

func _build_comic_panel(frame: Dictionary, stretch: float, full_width: bool = false) -> Control:
	var is_scene: bool  = frame.get("is_scene", false)
	var npc_raw: String = frame.get("npc", "")          # e.g. "adult_6/talk"
	var world: String   = GameManager.world

	# ── Outer border panel ────────────────────────────────
	var outer := PanelContainer.new()
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	if not full_width:
		outer.size_flags_stretch_ratio = stretch
	var ps := StyleBoxFlat.new()
	ps.bg_color     = Color(0.04, 0.04, 0.06, 1.0)
	ps.border_color = Color(0.82, 0.86, 0.94)
	ps.set_border_width_all(3)
	ps.set_corner_radius_all(0)
	ps.content_margin_left = 0; ps.content_margin_right  = 0
	ps.content_margin_top  = 0; ps.content_margin_bottom = 0
	outer.add_theme_stylebox_override("panel", ps)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 0)
	outer.add_child(vbox)

	# ── Image area (background + NPC layered) ─────────────
	var img_area := Control.new()
	img_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	img_area.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	img_area.clip_contents         = true
	vbox.add_child(img_area)

	# Background
	var bg_tex := TextureRect.new()
	bg_tex.anchor_right  = 1.0
	bg_tex.anchor_bottom = 1.0
	bg_tex.expand_mode   = TextureRect.EXPAND_IGNORE_SIZE
	bg_tex.stretch_mode  = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var bg_path := "res://images/backgrounds/BG_" + world + ".png"
	var bg_t := _load_preview_texture(bg_path)
	if bg_t:
		bg_tex.texture = bg_t
	img_area.add_child(bg_tex)

	# Dark overlay so NPC pops
	var overlay := ColorRect.new()
	overlay.anchor_right  = 1.0
	overlay.anchor_bottom = 1.0
	overlay.color         = Color(0.0, 0.0, 0.0, 0.30)
	overlay.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	img_area.add_child(overlay)

	# NPC sprite | fills width, extends below panel so only upper half is visible (close-up crop)
	if npc_raw != "":
		var npc_tex := TextureRect.new()
		# TextureRect spans 1.6× the panel height starting from top.
		# CENTERED keeps aspect ratio and auto-pads | character scales to fit the width,
		# extends below the panel boundary, clip_contents cuts the lower half so we see
		# the upper body (head → waist) naturally without aggressive zoom.
		npc_tex.anchor_left   = 0.05
		npc_tex.anchor_right  = 0.95
		npc_tex.anchor_top    = 0.0
		npc_tex.anchor_bottom = 1.6
		npc_tex.expand_mode   = TextureRect.EXPAND_IGNORE_SIZE
		npc_tex.stretch_mode  = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var parts := npc_raw.split("/")
		var npc_path: String
		if parts.size() >= 3:
			npc_path = "res://images/characters/" + npc_raw + ".png"
		else:
			npc_path = "res://images/characters/NPC_adults/" + npc_raw + ".png"
		var npc_t := _load_preview_texture(npc_path)
		if npc_t:
			npc_tex.texture = npc_t
		img_area.add_child(npc_tex)

	# ── Caption strip (dark bar at bottom) ────────────────
	var cap_panel := PanelContainer.new()
	cap_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cap_panel.custom_minimum_size   = Vector2(0, 52)
	var cap_s := StyleBoxFlat.new()
	cap_s.bg_color             = Color(0.05, 0.06, 0.09, 0.95)
	cap_s.border_color         = Color(0.82, 0.86, 0.94)
	cap_s.border_width_top     = 2
	cap_s.content_margin_left  = 10
	cap_s.content_margin_right = 10
	cap_s.content_margin_top   = 5
	cap_s.content_margin_bottom= 5
	cap_panel.add_theme_stylebox_override("panel", cap_s)
	vbox.add_child(cap_panel)

	var cap_vbox := VBoxContainer.new()
	cap_vbox.add_theme_constant_override("separation", 2)
	cap_panel.add_child(cap_vbox)

	# Character name
	var name_lbl := Label.new()
	name_lbl.text = frame["name"]
	name_lbl.add_theme_font_size_override("font_size", 10)
	name_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
	cap_vbox.add_child(name_lbl)

	# Dialogue text
	var dial_lbl := Label.new()
	var raw: String  = frame["text"]
	var max_ch: int  = 85 if (stretch >= 2.0 or full_width) else 52
	var trunc: String = raw.substr(0, max_ch) + ("..." if raw.length() > max_ch else "")
	if not is_scene:
		trunc = "\"" + trunc + "\""
	dial_lbl.text              = trunc
	dial_lbl.autowrap_mode     = TextServer.AUTOWRAP_WORD_SMART
	dial_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dial_lbl.add_theme_font_size_override("font_size", 11)
	dial_lbl.add_theme_color_override("font_color", Color(0.90, 0.92, 0.97))
	cap_vbox.add_child(dial_lbl)

	return outer

# ── Locked folder header style ──────────────────────────
func _style_folder_btn_locked(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", Color(0.28, 0.31, 0.38))
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.07, 0.08, 0.12, 0.55)
	s.border_color = Color(0.16, 0.19, 0.26)
	s.border_width_bottom = 2
	s.set_corner_radius_all(6)
	s.content_margin_left   = 12; s.content_margin_right  = 12
	s.content_margin_top    = 9;  s.content_margin_bottom = 9
	btn.add_theme_stylebox_override("normal",   s)
	btn.add_theme_stylebox_override("hover",    s)
	btn.add_theme_stylebox_override("pressed",  s)
	btn.add_theme_stylebox_override("disabled", s)

# ── Folder header button style ───────────────────────────
func _style_folder_btn(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", Color("#F59E0B"))
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.09, 0.11, 0.17, 0.90)
	s.border_color = Color(0.28, 0.33, 0.46)
	s.border_width_bottom = 2
	s.set_corner_radius_all(6)
	s.content_margin_left   = 12; s.content_margin_right  = 12
	s.content_margin_top    = 9;  s.content_margin_bottom = 9
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.14, 0.17, 0.25, 0.95)
	h.border_color = Color("#F59E0B")
	h.border_width_bottom = 2
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color(0.07, 0.08, 0.13, 0.95)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)

# ── 3-variant button style ────────────────────────────────
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
			s.content_margin_top    = 11; s.content_margin_bottom = 11
		"ghost":
			btn.add_theme_color_override("font_color", Color(0.55, 0.60, 0.70))
			s.bg_color     = Color(0, 0, 0, 0)
			s.border_color = Color(0.30, 0.35, 0.46)
			s.set_border_width_all(2)
			s.content_margin_left   = 14; s.content_margin_right  = 14
			s.content_margin_top    = 8;  s.content_margin_bottom = 8
		"locked":
			btn.add_theme_color_override("font_color", Color(0.30, 0.33, 0.40))
			s.bg_color     = Color(0.08, 0.09, 0.13, 0.50)
			s.border_color = Color(0.16, 0.19, 0.26)
			s.set_border_width_all(2)
			s.content_margin_left   = 16; s.content_margin_right  = 16
			s.content_margin_top    = 11; s.content_margin_bottom = 11
		"quiz":
			btn.add_theme_color_override("font_color", Color(0.08, 0.05, 0.00))
			s.bg_color     = Color("#D97706")
			s.border_color = Color("#F59E0B")
			s.set_border_width_all(2)
			s.set_corner_radius_all(8)
			s.content_margin_left   = 16; s.content_margin_right  = 16
			s.content_margin_top    = 10; s.content_margin_bottom = 10

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
		"locked":
			h.bg_color = s.bg_color
			p.bg_color = s.bg_color
		"quiz":
			h.bg_color = Color("#F59E0B")
			h.border_color = Color("#FBBF24")
			p.bg_color = Color("#B45309")

	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)

# ── SQL Glossary overlay ──────────────────────────────
# Lives on the Dashboard (not in a lesson) so it can't be used as a
# mid-exercise cheat sheet — students can look a term up between lessons only.
func _build_glossary() -> void:
	# Glossary toggle button in TopBar, right after "← Worlds"
	var gloss_btn := Button.new()
	gloss_btn.text = "📖  Glossary"
	gloss_btn.pressed.connect(_toggle_glossary)
	_style_btn(gloss_btn, "secondary", 13)
	$TopBar.add_child(gloss_btn)

	# Full-screen overlay | added last so it's on top of all scene children
	_glossary_overlay = Control.new()
	_glossary_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glossary_overlay.visible = false
	_glossary_overlay.z_index = 100
	_glossary_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_glossary_overlay)

	# Dark backdrop
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.80)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_glossary_overlay.add_child(backdrop)

	# Centered panel
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glossary_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 560)
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.09, 0.11, 0.16, 0.98)
	ps.border_color = Color("#F59E0B")
	ps.set_border_width_all(2)
	ps.set_corner_radius_all(12)
	ps.content_margin_left   = 24
	ps.content_margin_right  = 24
	ps.content_margin_top    = 20
	ps.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", ps)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(vbox)

	# Header row
	var header_row := HBoxContainer.new()
	vbox.add_child(header_row)
	var header_lbl := Label.new()
	header_lbl.text = "SQL Glossary"
	header_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_lbl.add_theme_font_size_override("font_size", 18)
	header_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
	header_row.add_child(header_lbl)
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.pressed.connect(_toggle_glossary)
	_style_btn(close_btn, "ghost", 16)
	header_row.add_child(close_btn)

	# Divider
	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(0.25, 0.30, 0.42)
	vbox.add_child(sep)

	# Filter search bar
	var filter_box := LineEdit.new()
	filter_box.placeholder_text = "🔍  Filter terms..."
	filter_box.clear_button_enabled = true
	filter_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var fns := StyleBoxFlat.new()
	fns.bg_color = Color(0.04, 0.07, 0.13, 1.0)
	fns.border_color = Color(1.0, 0.78, 0.0)
	fns.border_width_bottom = 2
	fns.content_margin_left = 8; fns.content_margin_right  = 8
	fns.content_margin_top  = 5; fns.content_margin_bottom = 5
	filter_box.add_theme_stylebox_override("normal", fns)
	var ffs := fns.duplicate() as StyleBoxFlat; ffs.border_width_bottom = 3
	filter_box.add_theme_stylebox_override("focus", ffs)
	filter_box.add_theme_color_override("font_color", Color(1.0, 0.78, 0.0))
	filter_box.add_theme_color_override("font_placeholder_color", Color(1.0, 0.78, 0.0, 0.3))
	filter_box.add_theme_font_size_override("font_size", 13)
	vbox.add_child(filter_box)

	var sep2 := ColorRect.new()
	sep2.custom_minimum_size = Vector2(0, 1)
	sep2.color = Color(0.25, 0.30, 0.42)
	vbox.add_child(sep2)

	# Scrollable entries area
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	var entry_list := VBoxContainer.new()
	entry_list.add_theme_constant_override("separation", 6)
	entry_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(entry_list)

	# entries_meta filled below | lambda captures array reference so filtering works
	var entries_meta: Array = []
	filter_box.text_changed.connect(func(query: String):
		var q := query.strip_edges().to_lower()
		for pair in entries_meta:
			pair[0].visible = q.is_empty() or pair[1].contains(q)
	)

	# Entries
	for entry in SQL_GLOSSARY:
		# Wrapper column so example panel sits below the row
		var entry_col := VBoxContainer.new()
		entry_col.add_theme_constant_override("separation", 4)
		entry_list.add_child(entry_col)
		entries_meta.append([entry_col, (entry[0] + " " + entry[1]).to_lower()])

		# Main info row
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		entry_col.add_child(row)

		var cmd_lbl := Label.new()
		cmd_lbl.text = entry[0]
		cmd_lbl.custom_minimum_size = Vector2(120, 0)
		cmd_lbl.add_theme_font_size_override("font_size", 14)
		cmd_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
		row.add_child(cmd_lbl)

		var def_lbl := Label.new()
		def_lbl.text = entry[1]
		def_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		def_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		def_lbl.add_theme_font_size_override("font_size", 13)
		def_lbl.add_theme_color_override("font_color", Color(0.80, 0.83, 0.90))
		row.add_child(def_lbl)

		# Example toggle button
		var ex_btn := Button.new()
		ex_btn.text = "{ }"
		ex_btn.tooltip_text = "Show example"
		_style_btn(ex_btn, "ghost", 12)
		row.add_child(ex_btn)

		# Collapsible syntax panel (hidden by default)
		var snippet_panel := PanelContainer.new()
		snippet_panel.visible = false
		var sp := StyleBoxFlat.new()
		sp.bg_color = Color(0.04, 0.05, 0.08, 1.0)
		sp.border_color = Color("#F59E0B")
		sp.border_width_left = 3
		sp.content_margin_left  = 12
		sp.content_margin_right = 12
		sp.content_margin_top   = 8
		sp.content_margin_bottom = 8
		snippet_panel.add_theme_stylebox_override("panel", sp)
		entry_col.add_child(snippet_panel)

		var snippet_lbl := Label.new()
		snippet_lbl.text = entry[2]
		snippet_lbl.add_theme_font_size_override("font_size", 13)
		snippet_lbl.add_theme_color_override("font_color", Color("#4ADE80"))
		snippet_panel.add_child(snippet_lbl)

		# Toggle visibility on button press
		ex_btn.pressed.connect(func():
			snippet_panel.visible = not snippet_panel.visible
			ex_btn.text = "▲" if snippet_panel.visible else "{ }"
		)

func _toggle_glossary() -> void:
	if _glossary_overlay:
		_glossary_overlay.visible = not _glossary_overlay.visible

# ── Simulation folder / lesson picker overlay ──────────
# Shown when "Simulation" is pressed. Top level picks a folder/genre;
# "Basic SQL" drills one level deeper into its individual lessons, same
# pattern (a button per option + its own tracked best score) at both
# levels, so a player can run the whole folder mixed or grind one
# specific concept.
const SIM_FOLDERS: Array = [
	["all",       "Your Progress",         "Runs problems from every lesson you've unlocked so far."],
	["basic",     "Basic SQL",             "SELECT, INSERT, WHERE, UPDATE, DELETE."],
	["filtering", "Filtering Rows",        "Coming soon."],
	["sorting",   "Sorting & Aggregates",  "Coming soon."],
]

const SIM_BASIC_LESSONS: Array = [
	[1, "SELECT",       "View all records, or just one column."],
	[2, "INSERT INTO",  "Add a brand-new record."],
	[3, "SELECT WHERE", "Look up one specific record."],
	[4, "UPDATE SET",   "Fix a wrong value on an existing record."],
	[5, "DELETE",       "Remove a record."],
]

func _build_sim_picker() -> void:
	_sim_picker_overlay = Control.new()
	_sim_picker_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_sim_picker_overlay.visible = false
	_sim_picker_overlay.z_index = 100
	_sim_picker_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_sim_picker_overlay)

	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.80)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_sim_picker_overlay.add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_sim_picker_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(440, 0)
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.09, 0.11, 0.16, 0.98)
	ps.border_color = Color("#F59E0B")
	ps.set_border_width_all(2)
	ps.set_corner_radius_all(12)
	ps.content_margin_left   = 24
	ps.content_margin_right  = 24
	ps.content_margin_top    = 20
	ps.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", ps)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var header_row := HBoxContainer.new()
	vbox.add_child(header_row)
	_sim_picker_title_lbl = Label.new()
	_sim_picker_title_lbl.text = "Simulation Mode"
	_sim_picker_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_sim_picker_title_lbl.add_theme_font_size_override("font_size", 18)
	_sim_picker_title_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
	header_row.add_child(_sim_picker_title_lbl)
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.pressed.connect(_toggle_sim_picker)
	_style_btn(close_btn, "ghost", 16)
	header_row.add_child(close_btn)

	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(0.25, 0.30, 0.42)
	vbox.add_child(sep)

	_sim_picker_body = VBoxContainer.new()
	_sim_picker_body.add_theme_constant_override("separation", 10)
	vbox.add_child(_sim_picker_body)

func _toggle_sim_picker() -> void:
	if not _sim_picker_overlay:
		return
	_sim_picker_overlay.visible = not _sim_picker_overlay.visible
	if _sim_picker_overlay.visible:
		_show_sim_folder_list()

func _show_sim_folder_list() -> void:
	_sim_picker_title_lbl.text = "Simulation Mode"
	for c in _sim_picker_body.get_children():
		c.queue_free()

	for entry in SIM_FOLDERS:
		var key: String = entry[0]
		var title: String = entry[1]
		var desc: String = entry[2]
		var locked: bool = (key == "filtering" or key == "sorting")
		var pair: Array = _build_sim_picker_row(title, desc, locked)
		var btn: Button = pair[0]
		var best_lbl: Label = pair[1]
		if not locked:
			var score_key: String = GameManager.world if key == "all" else GameManager.world + "_" + key
			best_lbl.text = "Best: %d" % GameManager.get_sim_best(score_key)
			if key == "basic":
				btn.pressed.connect(_show_sim_basic_lesson_list)
			else:
				btn.pressed.connect(_start_simulation.bind(key, 0))
		_sim_picker_body.add_child(btn)

func _show_sim_basic_lesson_list() -> void:
	_sim_picker_title_lbl.text = "Basic SQL"
	for c in _sim_picker_body.get_children():
		c.queue_free()

	var back_btn := Button.new()
	back_btn.text = "← Back"
	_style_btn(back_btn, "ghost", 13)
	back_btn.pressed.connect(_show_sim_folder_list)
	_sim_picker_body.add_child(back_btn)

	var all_pair: Array = _build_sim_picker_row("All of Basic SQL", "Mixes every concept you've unlocked in this folder.", false)
	var all_btn: Button = all_pair[0]
	var all_best: Label = all_pair[1]
	all_best.text = "Best: %d" % GameManager.get_sim_best(GameManager.world + "_basic")
	all_btn.pressed.connect(_start_simulation.bind("basic", 0))
	_sim_picker_body.add_child(all_btn)

	for entry in SIM_BASIC_LESSONS:
		var idx: int = entry[0]
		var title: String = entry[1]
		var desc: String = entry[2]
		var pair: Array = _build_sim_picker_row(title, desc, false)
		var btn: Button = pair[0]
		var best_lbl: Label = pair[1]
		best_lbl.text = "Best: %d" % GameManager.get_sim_best(GameManager.world + "_basic_" + str(idx))
		btn.pressed.connect(_start_simulation.bind("basic", idx))
		_sim_picker_body.add_child(btn)

# Builds one picker row: a styled Button containing a title/description
# column and (if unlocked) a best-score Label. Returns [Button, Label-or-null]
# so the caller can set the score text and connect the press handler.
func _build_sim_picker_row(title: String, desc: String, locked: bool) -> Array:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 56)
	if locked:
		btn.disabled = true
		_style_btn(btn, "locked", 14)
	else:
		_style_btn(btn, "secondary", 14)

	var row := HBoxContainer.new()
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	row.offset_left = 14; row.offset_right = -14
	row.offset_top = 6;   row.offset_bottom = -6
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 4)

	var text_col := VBoxContainer.new()
	text_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var title_lbl := Label.new()
	title_lbl.text = title
	title_lbl.add_theme_color_override("font_color", Color(0.30, 0.33, 0.40) if locked else Color(0.90, 0.92, 0.96))
	title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var desc_lbl := Label.new()
	desc_lbl.text = desc
	desc_lbl.add_theme_font_size_override("font_size", 11)
	desc_lbl.add_theme_color_override("font_color", Color(0.30, 0.33, 0.40) if locked else Color(0.55, 0.60, 0.70))
	desc_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_col.add_child(title_lbl)
	text_col.add_child(desc_lbl)
	row.add_child(text_col)

	var best_lbl: Label = null
	if not locked:
		best_lbl = Label.new()
		best_lbl.add_theme_font_size_override("font_size", 13)
		best_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
		best_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(best_lbl)

	btn.add_child(row)
	return [btn, best_lbl]
