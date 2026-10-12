extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")

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
	# Halftone comic page behind everything
	var bg := Comic.make_halftone()
	bg.z_index = -10
	add_child(bg)

	# Ink title bar with a yellow edge
	var tb_bg := ColorRect.new()
	tb_bg.color         = Comic.INK
	tb_bg.anchor_right  = 1.0
	tb_bg.offset_bottom = 62.0
	tb_bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_bg.z_index       = -1
	add_child(tb_bg)

	var tb_line := ColorRect.new()
	tb_line.color         = Comic.YELLOW
	tb_line.anchor_right  = 1.0
	tb_line.offset_top    = 62.0
	tb_line.offset_bottom = 67.0
	tb_line.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_line.z_index       = -1
	add_child(tb_line)

	# Room around the bar buttons for their hard shadows
	$TopBar.offset_top    = 7.0
	$TopBar.offset_bottom = 55.0
	$TopBar.offset_right  = -14.0
	$TopBar.add_theme_constant_override("separation", 12)
	$ContentRow.offset_top = 74.0

	_back_btn.pressed.connect(_on_change_world)
	_style_btn(_back_btn, "secondary", 20)
	_back_btn.text = "← Worlds"

	_build_glossary()

	var sim_btn := Button.new()
	sim_btn.text = "🎮  Simulation"
	sim_btn.pressed.connect(_toggle_sim_picker)
	_style_btn(sim_btn, "primary", 20)
	$TopBar.add_child(sim_btn)

	_build_sim_picker()

	Comic.heading(_screen_lbl, 26, Comic.YELLOW)

	# Preview title styling
	Comic.heading(_preview_title, 24, Comic.INK)
	_preview_title.add_theme_constant_override("outline_size", 0)

	# Chunky ink divider between the lesson list and the preview
	var divider: ColorRect = $ContentRow/Divider
	divider.color = Comic.INK
	divider.custom_minimum_size = Vector2(5, 0)

	_apply_v2()


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

	Comic.title(_world_title, 50, Comic.YELLOW, 10)

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
			btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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

			# Stars sit on top of the finished lesson, so they never take row width
			var item := VBoxContainer.new()
			item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			item.add_theme_constant_override("separation", 0)
			var stars: int = GameManager.get_stars(GameManager.world, captured_id)
			if stars > 0:
				var star_lbl := Label.new()
				star_lbl.text = "★".repeat(stars) + "☆".repeat(3 - stars)
				star_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				star_lbl.add_theme_font_size_override("font_size", 24)
				star_lbl.add_theme_color_override("font_color", Comic.YELLOW)
				star_lbl.add_theme_color_override("font_outline_color", Comic.INK)
				star_lbl.add_theme_constant_override("outline_size", 6)
				item.add_child(star_lbl)
			item.add_child(row)

			box.add_child(item)

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
			qbtn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
	_decorate_v2()

# ── Comic panel preview ───────────────────────────────────
func _reset_preview() -> void:
	for child in _comic_strip.get_children():
		child.queue_free()
	# Placeholder panel | styled like a blank comic page
	var wrap := PanelContainer.new()
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrap.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	wrap.add_theme_stylebox_override("panel", Comic.box(Comic.PAPER_HI, Comic.INK, 5, 6, 8, 12, 12))
	var ph := Label.new()
	ph.text = "Hover a lesson\nto preview its story"
	ph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ph.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	ph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ph.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	ph.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	Comic.heading(ph, 30, Comic.INK_SOFT)
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
	# A comic page: cream gutters, thick ink frame, hard shadow
	page.add_theme_stylebox_override("panel", Comic.box(Comic.PAPER_HI, Comic.INK, 5, 6, 8, 9, 9))
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
	cta.size_flags_horizontal = Control.SIZE_SHRINK_END
	Fx.tag(cta, Comic.YELLOW, Comic.INK, 28, true, Comic.RED, 18, 4)
	_comic_strip.add_child(cta)
	Fx.tilt(cta, -1.5)

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
	# Hard square comic-panel border
	outer.add_theme_stylebox_override("panel", Comic.box(Comic.INK, Comic.INK, 4, 0, 0, 0, 0))

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

	# Soft paper wash so the ink lines stay crisp
	var overlay := ColorRect.new()
	overlay.anchor_right  = 1.0
	overlay.anchor_bottom = 1.0
	overlay.color         = Color(1.0, 0.96, 0.84, 0.30)
	overlay.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	img_area.add_child(overlay)

	# NPC sprite | fills width, extends below panel so only upper half is visible (close-up crop)
	var npc_node: TextureRect = null
	if npc_raw != "":
		var npc_tex := TextureRect.new()
		# TextureRect spans 1.6× the panel height starting from top.
		# CENTERED keeps aspect ratio and auto-pads | character scales to fit the width,
		# extends below the panel boundary, clip_contents cuts the lower half so we see
		# the upper body (head → waist) naturally without aggressive zoom.
		npc_tex.anchor_left   = 0.05 if is_scene else 0.46
		npc_tex.anchor_right  = 0.95 if is_scene else 1.04
		npc_tex.anchor_top    = 0.0
		npc_tex.anchor_bottom = 1.6 if is_scene else 1.9
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
		npc_node = npc_tex

	# ── Caption box (narration) or speech bubble (NPC) over the art ──
	var cap_panel: Container
	if is_scene:
		# Narration caption sits along the bottom so it never covers a face
		cap_panel = PanelContainer.new()
		cap_panel.add_theme_stylebox_override("panel", Comic.box(Comic.YELLOW, Comic.INK, 3, 2, 4, 9, 5))
		cap_panel.anchor_top = 1.0
		cap_panel.anchor_bottom = 1.0
		cap_panel.anchor_right = 0.78
		cap_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	else:
		var bub := Fx.Bubble.new()
		bub.radius = 22
		bub.outline = 3.0
		bub.shadow = 4.0
		bub.tail_width = 18.0
		bub.tail_at = 0.18
		bub.add_theme_constant_override("margin_left", 10)
		bub.add_theme_constant_override("margin_right", 10)
		bub.add_theme_constant_override("margin_top", 6)
		bub.add_theme_constant_override("margin_bottom", 8)
		bub.anchor_right = 0.52
		# Tail ends just left of the speaker's mouth
		var npc_ref: TextureRect = npc_node
		var aim := func():
			var target := Vector2(img_area.size.x * 0.66, img_area.size.y * 0.17)
			if npc_ref != null and is_instance_valid(npc_ref):
				target = Fx.mouth_point(npc_ref) - Vector2(5, 0)
			bub.tail_tip = target - bub.position
		bub.resized.connect(aim)
		img_area.resized.connect(aim)
		if npc_ref != null:
			npc_ref.resized.connect(aim)
		cap_panel = bub
	cap_panel.offset_left = 8.0
	cap_panel.offset_top = -8.0 if is_scene else 8.0
	cap_panel.offset_bottom = -8.0 if is_scene else 0.0
	cap_panel.offset_right = 0.0
	cap_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	img_area.add_child(cap_panel)

	var cap_vbox := VBoxContainer.new()
	cap_vbox.add_theme_constant_override("separation", 2)
	cap_panel.add_child(cap_vbox)

	# Character name
	var name_lbl := Label.new()
	name_lbl.text = frame["name"]
	Comic.heading(name_lbl, 15, Comic.INK if is_scene else Comic.RED)
	cap_vbox.add_child(name_lbl)

	# Dialogue text
	var dial_lbl := Label.new()
	var raw: String  = frame["text"]
	var max_ch: int  = 85 if (stretch >= 2.0 or full_width) else 52
	if not is_scene:
		max_ch = 70 if (stretch >= 2.0 or full_width) else 40
	var trunc: String = raw.substr(0, max_ch) + ("..." if raw.length() > max_ch else "")
	dial_lbl.text              = trunc
	dial_lbl.autowrap_mode     = TextServer.AUTOWRAP_WORD_SMART
	dial_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.body(dial_lbl, 13, Comic.INK)
	cap_vbox.add_child(dial_lbl)

	return outer

# ── Locked folder header style ──────────────────────────
func _style_folder_btn_locked(btn: Button) -> void:
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	Comic.apply_button(btn, "locked", 19, true, 14, 8)

# ── Folder header button style ───────────────────────────
# An ink ribbon with yellow lettering, like a comic chapter banner.
func _style_folder_btn(btn: Button) -> void:
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	Comic.apply_button(btn, "dark", 21, true, 14, 8)

# ── Button styles (comic look, from ComicStyle) ──────────
# primary | yellow  secondary | cream  ghost | text only
# locked  | grey    quiz      | red
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 16) -> void:
	if font_size < 17:
		font_size = 17   # comic lettering needs a little more size to stay readable
	var display: bool = variant == "primary" or variant == "quiz" or font_size >= 19
	match variant:
		"primary":
			Comic.apply_button(btn, "primary", font_size, true, 22, 10)
		"quiz":
			Comic.apply_button(btn, "quiz", font_size, true, 14, 9)
		"ghost":
			Comic.apply_button(btn, "ghost", font_size, false, 12, 6)
		"locked":
			Comic.apply_button(btn, "locked", font_size, false, 14, 9)
		_:
			Comic.apply_button(btn, "secondary", font_size, display, 14, 9)

# ── SQL Glossary overlay ──────────────────────────────
# Lives on the Dashboard (not in a lesson) so it can't be used as a
# mid-exercise cheat sheet — students can look a term up between lessons only.
func _build_glossary() -> void:
	# Glossary toggle button in TopBar, right after "← Worlds"
	var gloss_btn := Button.new()
	gloss_btn.text = "📖  Glossary"
	gloss_btn.pressed.connect(_toggle_glossary)
	_style_btn(gloss_btn, "secondary", 20)
	$TopBar.add_child(gloss_btn)

	# Full-screen overlay | added last so it's on top of all scene children
	_glossary_overlay = Control.new()
	_glossary_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glossary_overlay.visible = false
	_glossary_overlay.z_index = 100
	_glossary_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_glossary_overlay)

	# Ink-tinted backdrop
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	Comic.apply_dim(backdrop, 0.72)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_glossary_overlay.add_child(backdrop)

	# Centered panel
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glossary_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 580)
	Comic.apply_panel(panel, Comic.PAPER, 16, 8, 28, 22, 5)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(vbox)

	# Header row
	var header_row := HBoxContainer.new()
	vbox.add_child(header_row)
	var header_lbl := Label.new()
	header_lbl.text = "SQL Glossary"
	header_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.title(header_lbl, 38, Comic.YELLOW, 8)
	header_row.add_child(header_lbl)
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.pressed.connect(_toggle_glossary)
	Comic.apply_icon_button(close_btn, "danger", 22)
	header_row.add_child(close_btn)

	# Divider
	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 4)
	sep.color = Comic.INK
	vbox.add_child(sep)

	# Filter search bar
	var filter_box := LineEdit.new()
	filter_box.placeholder_text = "🔍  Filter terms..."
	filter_box.clear_button_enabled = true
	filter_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.apply_input(filter_box, 17)
	vbox.add_child(filter_box)

	# Scrollable entries area
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	var entry_pad := MarginContainer.new()
	entry_pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_pad.add_theme_constant_override("margin_right", 22)
	scroll.add_child(entry_pad)
	var entry_list := VBoxContainer.new()
	entry_list.add_theme_constant_override("separation", 12)
	entry_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_pad.add_child(entry_list)

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
		entry_col.add_theme_constant_override("separation", 6)
		entry_list.add_child(entry_col)
		entries_meta.append([entry_col, (entry[0] + " " + entry[1]).to_lower()])

		# Main info row
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)
		entry_col.add_child(row)

		var cmd_lbl := Label.new()
		cmd_lbl.text = entry[0]
		cmd_lbl.custom_minimum_size = Vector2(150, 0)
		cmd_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		Comic.heading(cmd_lbl, 21, Comic.RED)
		row.add_child(cmd_lbl)

		var def_lbl := Label.new()
		def_lbl.text = entry[1]
		def_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		def_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		Comic.body(def_lbl, 16, Comic.INK)
		row.add_child(def_lbl)

		# Example toggle button
		var ex_btn := Button.new()
		ex_btn.text = "{ }"
		ex_btn.tooltip_text = "Show example"
		Comic.apply_button(ex_btn, "secondary", 16, false, 10, 4)
		row.add_child(ex_btn)

		# Collapsible syntax panel (hidden by default): a dark code box
		var snippet_panel := PanelContainer.new()
		snippet_panel.visible = false
		var sp := Comic.box(Comic.INK, Comic.INK, 3, 6, 0, 14, 9)
		sp.border_width_left = 8
		sp.border_color = Comic.INK
		snippet_panel.add_theme_stylebox_override("panel", sp)
		entry_col.add_child(snippet_panel)

		var snippet_lbl := Label.new()
		snippet_lbl.text = entry[2]
		Comic.body(snippet_lbl, 15, Comic.GREEN_HI)
		snippet_panel.add_child(snippet_lbl)

		# Toggle visibility on button press
		ex_btn.pressed.connect(func():
			snippet_panel.visible = not snippet_panel.visible
			ex_btn.text = "▲" if snippet_panel.visible else "{ }"
		)

		# A thin ink rule between entries
		var rule := ColorRect.new()
		rule.custom_minimum_size = Vector2(0, 2)
		rule.color = Color(Comic.INK, 0.25)
		entry_col.add_child(rule)

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
	["filtering", "Filtering Rows",        "IS NULL, DISTINCT, AND/OR, BETWEEN, LIKE, IN."],
	["sorting",   "Sorting & Aggregates",  "ORDER BY, LIMIT, GROUP BY, COUNT/SUM/AVG, HAVING, AS."],
]

const SIM_BASIC_LESSONS: Array = [
	[1, "SELECT",       "View all records, or just one column."],
	[2, "INSERT INTO",  "Add a brand-new record."],
	[3, "SELECT WHERE", "Look up one specific record."],
	[4, "UPDATE SET",   "Fix a wrong value on an existing record."],
	[5, "DELETE",       "Remove a record."],
]

const SIM_FILTERING_LESSONS: Array = [
	[6,  "IS NULL",  "Find rows with a missing value."],
	[7,  "DISTINCT", "List each unique value once."],
	[8,  "AND / OR", "Combine two filter conditions."],
	[9,  "BETWEEN",  "Filter within an inclusive range."],
	[10, "LIKE",     "Match a text pattern."],
	[11, "IN",       "Match any value in a list."],
]

const SIM_SORTING_LESSONS: Array = [
	[12, "ORDER BY",            "Sort results ascending or descending."],
	[13, "LIMIT",               "Cap how many rows come back."],
	[14, "GROUP BY",            "Group rows and count each bucket."],
	[15, "COUNT / SUM / AVG",   "Collapse rows into one calculated value."],
	[16, "HAVING",              "Filter groups after they're formed."],
	[17, "AS (Alias)",          "Give a calculated column a readable name."],
]

# Worlds whose *SimData.gd has real Filtering Rows / Sorting & Aggregates
# templates built out. A future world without them yet would show "Coming soon".
const FILTERING_SORTING_READY_WORLDS: Array = ["hotel", "cafe", "airport", "library"]

func _build_sim_picker() -> void:
	_sim_picker_overlay = Control.new()
	_sim_picker_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_sim_picker_overlay.visible = false
	_sim_picker_overlay.z_index = 100
	_sim_picker_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_sim_picker_overlay)

	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	Comic.apply_dim(backdrop, 0.72)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_sim_picker_overlay.add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_sim_picker_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(500, 0)
	Comic.apply_panel(panel, Comic.PAPER, 16, 8, 28, 22, 5)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	var header_row := HBoxContainer.new()
	vbox.add_child(header_row)
	_sim_picker_title_lbl = Label.new()
	_sim_picker_title_lbl.text = "Simulation Mode"
	_sim_picker_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.title(_sim_picker_title_lbl, 38, Comic.YELLOW, 8)
	header_row.add_child(_sim_picker_title_lbl)
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.pressed.connect(_toggle_sim_picker)
	Comic.apply_icon_button(close_btn, "danger", 22)
	header_row.add_child(close_btn)

	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 4)
	sep.color = Comic.INK
	vbox.add_child(sep)

	_sim_picker_body = VBoxContainer.new()
	_sim_picker_body.add_theme_constant_override("separation", 12)
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
		var locked: bool = (key == "filtering" or key == "sorting") and not FILTERING_SORTING_READY_WORLDS.has(GameManager.world)
		var pair: Array = _build_sim_picker_row(title, desc, locked)
		var btn: Button = pair[0]
		var best_lbl: Label = pair[1]
		if not locked:
			var score_key: String = GameManager.world if key == "all" else GameManager.world + "_" + key
			best_lbl.text = "Best: %d" % GameManager.get_sim_best(score_key)
			if key == "basic":
				btn.pressed.connect(_show_sim_basic_lesson_list)
			elif key == "filtering":
				btn.pressed.connect(_show_sim_filtering_lesson_list)
			elif key == "sorting":
				btn.pressed.connect(_show_sim_sorting_lesson_list)
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

func _show_sim_filtering_lesson_list() -> void:
	_sim_picker_title_lbl.text = "Filtering Rows"
	for c in _sim_picker_body.get_children():
		c.queue_free()

	var back_btn := Button.new()
	back_btn.text = "← Back"
	_style_btn(back_btn, "ghost", 13)
	back_btn.pressed.connect(_show_sim_folder_list)
	_sim_picker_body.add_child(back_btn)

	var all_pair: Array = _build_sim_picker_row("All of Filtering Rows", "Mixes every concept you've unlocked in this folder.", false)
	var all_btn: Button = all_pair[0]
	var all_best: Label = all_pair[1]
	all_best.text = "Best: %d" % GameManager.get_sim_best(GameManager.world + "_filtering")
	all_btn.pressed.connect(_start_simulation.bind("filtering", 0))
	_sim_picker_body.add_child(all_btn)

	for entry in SIM_FILTERING_LESSONS:
		var idx: int = entry[0]
		var title: String = entry[1]
		var desc: String = entry[2]
		var pair: Array = _build_sim_picker_row(title, desc, false)
		var btn: Button = pair[0]
		var best_lbl: Label = pair[1]
		best_lbl.text = "Best: %d" % GameManager.get_sim_best(GameManager.world + "_filtering_" + str(idx))
		btn.pressed.connect(_start_simulation.bind("filtering", idx))
		_sim_picker_body.add_child(btn)

func _show_sim_sorting_lesson_list() -> void:
	_sim_picker_title_lbl.text = "Sorting & Aggregates"
	for c in _sim_picker_body.get_children():
		c.queue_free()

	var back_btn := Button.new()
	back_btn.text = "← Back"
	_style_btn(back_btn, "ghost", 13)
	back_btn.pressed.connect(_show_sim_folder_list)
	_sim_picker_body.add_child(back_btn)

	var all_pair: Array = _build_sim_picker_row("All of Sorting & Aggregates", "Mixes every concept you've unlocked in this folder.", false)
	var all_btn: Button = all_pair[0]
	var all_best: Label = all_pair[1]
	all_best.text = "Best: %d" % GameManager.get_sim_best(GameManager.world + "_sorting")
	all_btn.pressed.connect(_start_simulation.bind("sorting", 0))
	_sim_picker_body.add_child(all_btn)

	for entry in SIM_SORTING_LESSONS:
		var idx: int = entry[0]
		var title: String = entry[1]
		var desc: String = entry[2]
		var pair: Array = _build_sim_picker_row(title, desc, false)
		var btn: Button = pair[0]
		var best_lbl: Label = pair[1]
		best_lbl.text = "Best: %d" % GameManager.get_sim_best(GameManager.world + "_sorting_" + str(idx))
		btn.pressed.connect(_start_simulation.bind("sorting", idx))
		_sim_picker_body.add_child(btn)

# Builds one picker row: a styled Button containing a title/description
# column and (if unlocked) a best-score Label. Returns [Button, Label-or-null]
# so the caller can set the score text and connect the press handler.
func _build_sim_picker_row(title: String, desc: String, locked: bool) -> Array:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 74)
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
	Comic.heading(title_lbl, 21, Comic.GREY_TEXT if locked else Comic.INK)
	title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var desc_lbl := Label.new()
	desc_lbl.text = desc
	Comic.body(desc_lbl, 13, Comic.GREY_TEXT if locked else Comic.INK_SOFT)
	desc_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_lbl.custom_minimum_size.x = 120
	text_col.add_child(title_lbl)
	text_col.add_child(desc_lbl)
	row.add_child(text_col)

	var best_lbl: Label = null
	if not locked:
		best_lbl = Label.new()
		Comic.title(best_lbl, 19, Comic.YELLOW, 5)
		best_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(best_lbl)

	btn.add_child(row)
	return [btn, best_lbl]

# ═══════════════════════════════════════════════════════
#  COMIC V2 LOOK (decoration only)
#  Comic-book masthead, 3D world logo, "issue" tags and lesson cards with a
#  number badge, stars, a PLAY tag / NEW! sticker and caution tape on locks.
# ═══════════════════════════════════════════════════════
const V2_ISSUE: Dictionary = { "hotel": 1, "cafe": 2, "airport": 3, "library": 4 }
var _v2_logo = null
var _v2_issue_tag: Label = null
var _v2_count_tag: Label = null

func _apply_v2() -> void:
	# Masthead: mini logo at the left of the ink bar, red print shadows on nav
	var mini := Fx.Logo.new()
	mini.text = "C.L.I.D."
	mini.font_size = 40
	mini.depth = 4
	mini.outline = 7
	mini.align_left = true
	mini.custom_minimum_size = Vector2(132, 48)
	$TopBar.add_child(mini)
	$TopBar.move_child(mini, 0)
	Comic.heading(_screen_lbl, 22, Comic.PAPER)
	for b in $TopBar.get_children():
		if b is Button:
			Fx.red_shadow(b)

	# World name as 3D logo lettering (the label keeps its text, just hidden)
	_world_title.custom_minimum_size = Vector2(0, 92)
	_v2_logo = Fx.Logo.new()
	_v2_logo.set_anchors_preset(Control.PRESET_FULL_RECT)
	_v2_logo.font_size = 66
	_v2_logo.depth = 7
	_v2_logo.outline = 11
	_v2_logo.align_left = true
	_v2_logo.rotation_degrees = -2.0
	_world_title.add_child(_v2_logo)

	# "Issue" + lesson count tags under the logo
	var tags_pad := MarginContainer.new()
	tags_pad.add_theme_constant_override("margin_left", 24)
	tags_pad.add_theme_constant_override("margin_top", 0)
	tags_pad.add_theme_constant_override("margin_bottom", 6)
	var tags := HBoxContainer.new()
	tags.add_theme_constant_override("separation", 14)
	tags_pad.add_child(tags)
	_v2_issue_tag = Label.new()
	Fx.tag(_v2_issue_tag, Comic.RED, Color.WHITE, 20)
	tags.add_child(_v2_issue_tag)
	_v2_count_tag = Label.new()
	Fx.tag(_v2_count_tag, Comic.PAPER_HI, Comic.INK, 20)
	tags.add_child(_v2_count_tag)
	$ContentRow/LeftPanel.add_child(tags_pad)
	$ContentRow/LeftPanel.move_child(tags_pad, 1)
	Fx.tilt(_v2_issue_tag, -2.0)

func _decorate_v2() -> void:
	if _v2_logo == null:
		return
	var world: String = GameManager.world
	_world_title.self_modulate = Color(1, 1, 1, 0)
	_v2_logo.text = _world_title.text.to_upper()
	_v2_issue_tag.text = "ISSUE #%d" % V2_ISSUE.get(world, 1)
	var done: int = 0
	var total: int = 0
	for c in _lesson_list.get_children():
		if c.is_queued_for_deletion():
			continue
		if c is Button:
			# Chapter ribbons: ink with a yellow print shadow
			if not c.disabled:
				for st in ["normal", "hover", "pressed", "hover_pressed"]:
					var sb = c.get_theme_stylebox(st)
					if sb is StyleBoxFlat:
						var cp: StyleBoxFlat = sb.duplicate()
						cp.shadow_color = Comic.YELLOW
						cp.shadow_offset = Vector2(5, 5) if not st.contains("pressed") else Vector2(2, 2)
						c.add_theme_stylebox_override(st, cp)
			continue
		if not (c is VBoxContainer):
			continue
		for item in c.get_children():
			if not (item is VBoxContainer):
				continue
			var star_lbl: Label = null
			var btn: Button = null
			for k in item.get_children():
				if k is Label:
					star_lbl = k
				elif k is HBoxContainer:
					for kk in k.get_children():
						if kk is Button:
							btn = kk
			if btn == null:
				continue
			var stars: int = 0
			if star_lbl != null:
				stars = star_lbl.text.count("★")
				star_lbl.visible = false
			total += 1
			if stars > 0:
				done += 1
			_card_v2(btn, stars)
	_v2_count_tag.text = "★ %d / %d LESSONS" % [done, total]

# Turns one lesson button into a comic card (text moves into child labels)
func _card_v2(btn: Button, stars: int) -> void:
	var raw: String = btn.text
	var locked: bool = btn.disabled
	var current: bool = not locked and stars == 0
	raw = raw.replace("🔒", "").strip_edges()
	var num: String = raw.substr(0, 2)
	var rest: String = raw.substr(2).strip_edges()
	var parts: PackedStringArray = rest.split(" | ", false, 1)
	var title: String = parts[0]
	var sub: String = parts[1] if parts.size() > 1 else ""
	btn.text = ""
	btn.tooltip_text = rest
	btn.custom_minimum_size = Vector2(0, 58)
	var variant: String = "locked" if locked else ("primary" if current else "secondary")
	Comic.apply_button(btn, variant, 17, false, 10, 4)
	for st in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
		var sb = btn.get_theme_stylebox(st)
		if sb is StyleBoxFlat:
			var cp: StyleBoxFlat = sb.duplicate()
			cp.set_border_width_all(4)
			cp.set_corner_radius_all(10)
			if not locked:
				cp.shadow_offset = Vector2(5, 5) if not st.contains("pressed") else Vector2(2, 2)
			btn.add_theme_stylebox_override(st, cp)

	var ink: Color = Comic.GREY_TEXT if locked else Comic.INK
	var row := HBoxContainer.new()
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	row.offset_left = 8.0
	row.offset_right = -10.0
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(row)

	var badge := Label.new()
	badge.text = num
	badge.custom_minimum_size = Vector2(38, 38)
	badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var bs := Comic.box(Comic.GREY if locked else Comic.PAPER_HI, Comic.GREY_TEXT if locked else Comic.INK, 3, 19, 0, 0, 0)
	badge.add_theme_stylebox_override("normal", bs)
	Comic.heading(badge, 19, ink)
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(badge)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", -2)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(col)
	var t := Label.new()
	t.text = title
	t.clip_text = true
	Comic.body(t, 17, ink)
	col.add_child(t)
	if sub != "":
		var s := Label.new()
		s.text = sub
		s.clip_text = true
		s.add_theme_font_override("font", Comic.body_regular_font())
		s.add_theme_font_size_override("font_size", 14)
		s.add_theme_color_override("font_color", Comic.GREY_TEXT if locked else Comic.INK_SOFT)
		col.add_child(s)

	if locked:
		var tape := Fx.Tape.new()
		tape.anchor_left = 1.0
		tape.anchor_right = 1.0
		tape.offset_left = -150.0
		tape.offset_right = -4.0
		tape.offset_top = 15.0
		tape.offset_bottom = 41.0
		tape.pivot_offset = Vector2(73, 13)
		tape.rotation_degrees = -8.0
		btn.add_child(tape)
		var lk := Label.new()
		lk.text = "LOCKED"
		Fx.tag(lk, Comic.INK, Color.WHITE, 16, true, Comic.INK, 8, 0)
		lk.anchor_left = 1.0
		lk.anchor_right = 1.0
		lk.offset_left = -112.0
		lk.offset_top = 14.0
		lk.rotation_degrees = -8.0
		lk.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(lk)
	elif current:
		var play := Label.new()
		play.text = "PLAY ▶"
		play.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		play.add_theme_stylebox_override("normal", Comic.box(Comic.INK, Comic.INK, 0, 6, 0, 10, 2))
		Comic.heading(play, 19, Comic.YELLOW)
		play.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(play)
		var new_s := Fx.sticker("NEW!", "", Comic.RED, Color.WHITE, Vector2(80, 54), 19, 10, -10.0)
		new_s.shadow = 3.0
		new_s.outline = 3.0
		new_s.inner = 0.7
		new_s.anchor_left = 1.0
		new_s.anchor_right = 1.0
		new_s.offset_left = -134.0
		new_s.offset_top = -28.0
		new_s.offset_right = -54.0
		new_s.offset_bottom = 26.0
		btn.add_child(new_s)
	else:
		var st_row := Fx.Stars.new()
		st_row.filled = stars
		st_row.outline = 2.5
		st_row.shadow = 2.0
		st_row.custom_minimum_size = Vector2(76, 26)
		st_row.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(st_row)
