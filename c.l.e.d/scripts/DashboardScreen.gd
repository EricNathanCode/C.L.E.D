extends Control

# ── Data script paths for comic-strip previews ────────────
const _DATA_PATHS: Dictionary = {
	"hotel":   "res://scripts/data/HotelData.gd",
	"cafe":    "res://scripts/data/CafeData.gd",
	"police":  "res://scripts/data/PoliceData.gd",
	"library": "res://scripts/data/LibraryData.gd",
}

# ── Lesson metadata ───────────────────────────────────────
const HOTEL_LESSONS  := [1,2,3,4,5, 6,8,16,17,18,19,20,21, 7,12,22,23,24,28, 9,10,11,13,14,15,25,29,32, 26,27,30,31,33,34]
const CAFE_LESSONS   := ["C1","C2","C4","C5","C6", "C7","C8","C16","C17","C18","C19","C20","C21", "C3","C12","C22","C23","C24","C28", "C9","C10","C11","C13","C14","C15","C25","C29","C32", "C26","C27","C30","C31","C33","C34"]
const POLICE_LESSONS := ["P1","P2","P3","P4","P5", "P6","P8","P16","P17","P18","P19","P20","P21", "P7","P12","P22","P23","P24","P28", "P9","P10","P11","P13","P14","P15","P25","P29","P32", "P26","P27","P30","P31","P33","P34"]
const LIBRARY_LESSONS:= ["L1","L2","L3","L4","L5", "L6","L8","L16","L17","L18","L19","L20","L21", "L7","L12","L22","L23","L24","L28", "L9","L10","L11","L13","L14","L15","L25","L29","L32", "L26","L27","L30","L31","L33","L34"]

const HOTEL_NAMES: Dictionary = {
	1:  "SELECT — Choose Your Response",
	2:  "INSERT INTO — Book a New Guest",
	3:  "SELECT WHERE — Search a Guest Record",
	4:  "UPDATE SET — Fix a Wrong Record",
	5:  "DELETE — Cancel a Booking",
	6:  "ORDER BY — Sort Guest Records",
	7:  "GROUP BY — Generate a Report",
	8:  "IS NULL — Find Missing Guest Emails",
	9:  "CREATE DATABASE — Set Up the Hotel Database",
	10: "CREATE TABLE — Define the Guests Table",
	11: "PRIMARY KEY — What Makes a Record Unique",
	12: "JOIN — Combine Guests and Bookings",
	13: "INT — Whole Number Data Type",
	14: "TEXT — String / Word Data Type",
	15: "REAL — Decimal Number Data Type",
	16: "SELECT DISTINCT — Unique Guest Types",
	17: "AND / OR — Filter Multiple Conditions",
	18: "BETWEEN — Guests in a Price Range",
	19: "LIKE — Search by Partial Name",
	20: "IN — Guests from Specific Cities",
	21: "LIMIT — Show Top 5 Bookings",
	22: "COUNT / SUM / AVG — Booking Statistics",
	23: "HAVING — Rooms with Many Bookings",
	24: "AS — Rename a Calculated Column",
	25: "NOT NULL + UNIQUE — Guest Record Integrity",
	26: "ALTER TABLE — Add a Column",
	27: "DROP TABLE — Remove an Old Table",
	28: "LEFT JOIN — All Rooms Including Empty",
	29: "DEFAULT — Auto-fill Check-in Status",
	30: "Normalization — Remove Repeated Data",
	31: "Transactions — Atomic Room Transfer",
	32: "FOREIGN KEY — Link Tables Together",
	33: "Indexes — Speed Up Queries",
	34: "Views — Save a Query as a Table",
}
const CAFE_NAMES: Dictionary = {
	"C1":  "SELECT — Take the Order",
	"C2":  "INSERT INTO — Log a New Order",
	"C3":  "GROUP BY — End-of-Day Report",
	"C4":  "SELECT WHERE — Find an Order",
	"C5":  "UPDATE SET — Fix a Wrong Order",
	"C6":  "DELETE — Cancel an Order",
	"C7":  "ORDER BY — Sort the Menu Items",
	"C8":  "IS NULL — Find Orders with No Notes",
	"C9":  "CREATE DATABASE — Set Up the Café Database",
	"C10": "CREATE TABLE — Define the Orders Table",
	"C11": "PRIMARY KEY — What Makes a Record Unique",
	"C12": "JOIN — Combine Customers and Orders",
	"C13": "INT — Whole Number Data Type",
	"C14": "TEXT — String / Word Data Type",
	"C15": "REAL — Decimal Number Data Type",
	"C16": "SELECT DISTINCT — Unique Drink Types",
	"C17": "AND / OR — Filter Multiple Conditions",
	"C18": "BETWEEN — Orders in a Price Range",
	"C19": "LIKE — Search by Partial Item Name",
	"C20": "IN — Orders from Specific Categories",
	"C21": "LIMIT — Show Top 5 Orders",
	"C22": "COUNT / SUM / AVG — Sales Statistics",
	"C23": "HAVING — Items Ordered Many Times",
	"C24": "AS — Rename a Calculated Column",
	"C25": "NOT NULL + UNIQUE — Order Record Integrity",
	"C26": "ALTER TABLE — Add a Column",
	"C27": "DROP TABLE — Remove an Old Table",
	"C28": "LEFT JOIN — All Customers Including New",
	"C29": "DEFAULT — Auto-fill Order Status",
	"C30": "Normalization — Remove Repeated Data",
	"C31": "Transactions — Atomic Order Processing",
	"C32": "FOREIGN KEY — Link Tables Together",
	"C33": "Indexes — Speed Up Queries",
	"C34": "Views — Save a Query as a Table",
}
const POLICE_NAMES: Dictionary = {
	"P1":  "SELECT — Handle a Citizen Report",
	"P2":  "INSERT INTO — Log a New Case",
	"P3":  "SELECT WHERE — Search a Suspect",
	"P4":  "UPDATE SET — Update Case Status",
	"P5":  "DELETE — Close a Cleared Case",
	"P6":  "ORDER BY — Sort Cases by Priority",
	"P7":  "GROUP BY — Crime Category Report",
	"P8":  "IS NULL — Find Unassigned Suspects",
	"P9":  "CREATE DATABASE — Set Up the Police Database",
	"P10": "CREATE TABLE — Define the Cases Table",
	"P11": "PRIMARY KEY — What Makes a Record Unique",
	"P12": "JOIN — Combine Cases and Officers",
	"P13": "INT — Whole Number Data Type",
	"P14": "TEXT — String / Word Data Type",
	"P15": "REAL — Decimal Number Data Type",
	"P16": "SELECT DISTINCT — Unique Case Types",
	"P17": "AND / OR — Filter Multiple Conditions",
	"P18": "BETWEEN — Fines in a Range",
	"P19": "LIKE — Search by Partial Suspect Name",
	"P20": "IN — Cases of Specific Types",
	"P21": "LIMIT — Show Top 5 Open Cases",
	"P22": "COUNT / SUM / AVG — Case Statistics",
	"P23": "HAVING — Case Types with Many Incidents",
	"P24": "AS — Rename a Calculated Column",
	"P25": "NOT NULL + UNIQUE — Case Record Integrity",
	"P26": "ALTER TABLE — Add a Column",
	"P27": "DROP TABLE — Remove an Old Table",
	"P28": "LEFT JOIN — All Officers Including Unassigned",
	"P29": "DEFAULT — Auto-fill Suspect Status",
	"P30": "Normalization — Remove Repeated Data",
	"P31": "Transactions — Atomic Case Transfer",
	"P32": "FOREIGN KEY — Link Tables Together",
	"P33": "Indexes — Speed Up Queries",
	"P34": "Views — Save a Query as a Table",
}
const LIBRARY_NAMES: Dictionary = {
	"L1":  "SELECT — Help a Visitor",
	"L2":  "INSERT INTO — Register a New Borrower",
	"L3":  "SELECT WHERE — Find a Book Record",
	"L4":  "UPDATE SET — Update a Return Date",
	"L5":  "DELETE — Remove an Overdue Record",
	"L6":  "ORDER BY — Sort Books Alphabetically",
	"L7":  "GROUP BY — Books by Genre Report",
	"L8":  "IS NULL — Find Unreturned Books",
	"L9":  "CREATE DATABASE — Set Up the Library Database",
	"L10": "CREATE TABLE — Define the Borrowers Table",
	"L11": "PRIMARY KEY — What Makes a Record Unique",
	"L12": "JOIN — Combine Borrowers and Books",
	"L13": "INT — Whole Number Data Type",
	"L14": "TEXT — String / Word Data Type",
	"L15": "REAL — Decimal Number Data Type",
	"L16": "SELECT DISTINCT — Unique Book Genres",
	"L17": "AND / OR — Filter Multiple Conditions",
	"L18": "BETWEEN — Books in a Publication Range",
	"L19": "LIKE — Search by Partial Title",
	"L20": "IN — Books of Specific Genres",
	"L21": "LIMIT — Show Top 5 Books",
	"L22": "COUNT / SUM / AVG — Collection Statistics",
	"L23": "HAVING — Genres with Many Books",
	"L24": "AS — Rename a Calculated Column",
	"L25": "NOT NULL + UNIQUE — Borrower Record Integrity",
	"L26": "ALTER TABLE — Add a Column",
	"L27": "DROP TABLE — Remove an Old Table",
	"L28": "LEFT JOIN — All Books Including Unborrowed",
	"L29": "DEFAULT — Auto-fill Book Status",
	"L30": "Normalization — Remove Repeated Data",
	"L31": "Transactions — Atomic Borrow Processing",
	"L32": "FOREIGN KEY — Link Tables Together",
	"L33": "Indexes — Speed Up Queries",
	"L34": "Views — Save a Query as a Table",
}
const WORLD_DISPLAY: Dictionary = {
	"hotel":   "Hotel World",
	"cafe":    "Cafe World",
	"police":  "Police Station",
	"library": "Library",
}

# ── Folder groupings per world ────────────────────────────
const HOTEL_FOLDERS := [
	{ "name": "Basic SQL",            "ids": [1,2,3,4,5] },
	{ "name": "Filtering & Sorting",  "ids": [6,8,16,17,18,19,20,21] },
	{ "name": "Aggregates & Joins",   "ids": [7,12,22,23,24,28] },
	{ "name": "Database Design",      "ids": [9,10,11,13,14,15,25,29,32] },
	{ "name": "Schema & Concepts",    "ids": [26,27,30,31,33,34] },
]
const CAFE_FOLDERS := [
	{ "name": "Basic SQL",            "ids": ["C1","C2","C4","C5","C6"] },
	{ "name": "Filtering & Sorting",  "ids": ["C7","C8","C16","C17","C18","C19","C20","C21"] },
	{ "name": "Aggregates & Joins",   "ids": ["C3","C12","C22","C23","C24","C28"] },
	{ "name": "Database Design",      "ids": ["C9","C10","C11","C13","C14","C15","C25","C29","C32"] },
	{ "name": "Schema & Concepts",    "ids": ["C26","C27","C30","C31","C33","C34"] },
]
const POLICE_FOLDERS := [
	{ "name": "Basic SQL",            "ids": ["P1","P2","P3","P4","P5"] },
	{ "name": "Filtering & Sorting",  "ids": ["P6","P8","P16","P17","P18","P19","P20","P21"] },
	{ "name": "Aggregates & Joins",   "ids": ["P7","P12","P22","P23","P24","P28"] },
	{ "name": "Database Design",      "ids": ["P9","P10","P11","P13","P14","P15","P25","P29","P32"] },
	{ "name": "Schema & Concepts",    "ids": ["P26","P27","P30","P31","P33","P34"] },
]
const LIBRARY_FOLDERS := [
	{ "name": "Basic SQL",            "ids": ["L1","L2","L3","L4","L5"] },
	{ "name": "Filtering & Sorting",  "ids": ["L6","L8","L16","L17","L18","L19","L20","L21"] },
	{ "name": "Aggregates & Joins",   "ids": ["L7","L12","L22","L23","L24","L28"] },
	{ "name": "Database Design",      "ids": ["L9","L10","L11","L13","L14","L15","L25","L29","L32"] },
	{ "name": "Schema & Concepts",    "ids": ["L26","L27","L30","L31","L33","L34"] },
]

# ── Node refs ─────────────────────────────────────────────
@onready var _screen_lbl    := $TopBar/ScreenLabel
@onready var _back_btn      := $TopBar/ChangeWorldButton
@onready var _world_title   := $ContentRow/LeftPanel/LeftPad/WorldTitle
@onready var _lesson_list   := $ContentRow/LeftPanel/ListPad/ScrollContainer/LessonList
@onready var _preview_title := $ContentRow/RightPanel/RightPad/PreviewArea/PreviewTitle
@onready var _comic_strip   := $ContentRow/RightPanel/RightPad/PreviewArea/ComicStrip

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

	_screen_lbl.add_theme_font_size_override("font_size", 13)
	_screen_lbl.add_theme_color_override("font_color", Color(0.50, 0.55, 0.65))

	# Preview title styling
	_preview_title.add_theme_font_size_override("font_size", 11)
	_preview_title.add_theme_color_override("font_color", Color(0.40, 0.45, 0.58))
	_preview_title.add_theme_constant_override("outline_size", 0)


func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func build_lessons() -> void:
	for child in _lesson_list.get_children():
		child.queue_free()

	_world_title.add_theme_font_size_override("font_size", 22)
	_world_title.add_theme_color_override("font_color", Color("#F59E0B"))

	if GameManager.merged_mode:
		_screen_lbl.text  = "  MERGE WORLDS   ·   ALL LESSONS"
		_world_title.text = "Merge Worlds"
		_build_merged_lessons()
		_reset_preview()
		return

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
		"police":
			ids = POLICE_LESSONS;  names = POLICE_NAMES;  folders = POLICE_FOLDERS
		"library":
			ids = LIBRARY_LESSONS; names = LIBRARY_NAMES; folders = LIBRARY_FOLDERS
		_:
			ids = [];              names = {};             folders = []

	# DEBUG: set true to bypass all locking for testing
	const DEBUG_UNLOCK := true

	# Build sequential number map: lesson_id → display number (01, 02…)
	var num_map: Dictionary = {}
	for i in range(ids.size()):
		num_map[ids[i]] = i + 1

	for fi in range(folders.size()):
		var folder_name: String  = folders[fi]["name"]
		var folder_ids: Array    = folders[fi]["ids"]

		# Folder locked if previous folder's challenge not yet passed
		# DEBUG: folder locking disabled — re-enable by setting DEBUG_UNLOCK to false
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

		# ── Folder challenge button (every folder except the last) ────
		if fi < folders.size() - 1 and not folder_locked:
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
				qbtn.text = "✓  Folder Challenge — Redo"
				qbtn.pressed.connect(func():
					GameManager.current_quiz_folder_idx = cap_fi2
					get_tree().root.get_node("Main").show_screen("folder_quiz")
				)
				_style_btn(qbtn, "ghost", 13)
			elif all_lessons_done:
				var cap_fi := fi
				qbtn.text = "⚡  FOLDER CHALLENGE — Unlock Next Chapter"
				qbtn.pressed.connect(func():
					GameManager.current_quiz_folder_idx = cap_fi
					get_tree().root.get_node("Main").show_screen("folder_quiz")
				)
				_style_btn(qbtn, "quiz", 13)
			else:
				qbtn.text = "🔒  Folder Challenge — Complete all lessons first"
				qbtn.disabled = true
				_style_btn(qbtn, "locked", 13)

			quiz_row.add_child(qbtn)
			box.add_child(quiz_row)

	# Show placeholder until hover
	_reset_preview()

# ── Merged-world lesson list ──────────────────────────────
func _build_merged_lessons() -> void:
	var all_worlds := [
		{ "w": "hotel",   "ids": HOTEL_LESSONS,   "names": HOTEL_NAMES,   "folders": HOTEL_FOLDERS },
		{ "w": "cafe",    "ids": CAFE_LESSONS,     "names": CAFE_NAMES,    "folders": CAFE_FOLDERS },
		{ "w": "police",  "ids": POLICE_LESSONS,   "names": POLICE_NAMES,  "folders": POLICE_FOLDERS },
		{ "w": "library", "ids": LIBRARY_LESSONS,  "names": LIBRARY_NAMES, "folders": LIBRARY_FOLDERS },
	]

	var global_num: int = 0

	for wdata in all_worlds:
		var w: String         = wdata["w"]
		var names: Dictionary = wdata["names"]
		var folders: Array    = wdata["folders"]

		# World section header — uses same style as folder headers, starts collapsed
		var world_hdr := Button.new()
		world_hdr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		world_hdr.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var w_display: String = WORLD_DISPLAY[w]
		world_hdr.text = "▶  " + w_display
		_style_folder_btn(world_hdr)
		_lesson_list.add_child(world_hdr)

		# World container — starts hidden (collapsed)
		var world_box := VBoxContainer.new()
		world_box.visible = false
		world_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		world_box.add_theme_constant_override("separation", 4)
		_lesson_list.add_child(world_box)

		var cap_whdr  = world_hdr
		var cap_wbox  = world_box
		var cap_wname = w_display
		world_hdr.pressed.connect(func():
			cap_wbox.visible = not cap_wbox.visible
			cap_whdr.text = ("▼  " if cap_wbox.visible else "▶  ") + cap_wname
		)

		for folder in folders:
			var folder_name: String = folder["name"]
			var folder_ids: Array   = folder["ids"]

			# Folder header (collapsible) — inside world_box
			var hdr := Button.new()
			hdr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hdr.alignment = HORIZONTAL_ALIGNMENT_LEFT
			var done: int = 0
			for fid in folder_ids:
				if GameManager.get_stars(w, fid) > 0:
					done += 1
			hdr.text = "▶  " + folder_name + "  (%d/%d)" % [done, folder_ids.size()]
			_style_folder_btn(hdr)
			world_box.add_child(hdr)

			var box := VBoxContainer.new()
			box.visible = false
			box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			box.add_theme_constant_override("separation", 4)
			world_box.add_child(box)

			var cap_hdr  = hdr
			var cap_box  = box
			var cap_fname = folder_name
			var cap_badge = "  (%d/%d)" % [done, folder_ids.size()]
			hdr.pressed.connect(func():
				cap_box.visible = not cap_box.visible
				cap_hdr.text = ("▼  " if cap_box.visible else "▶  ") + cap_fname + cap_badge
			)

			for fid in folder_ids:
				global_num += 1
				var captured_id  = fid
				var captured_w   = w
				var num          = global_num

				var row := HBoxContainer.new()
				row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				row.add_theme_constant_override("separation", 6)
				var sp := Control.new(); sp.custom_minimum_size = Vector2(18, 0)
				row.add_child(sp)

				var btn := Button.new()
				btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.text = "%02d  " % num + names.get(fid, "Lesson " + str(fid))
				btn.pressed.connect(func():
					GameManager.world     = captured_w
					GameManager.lesson_id = captured_id
					get_tree().root.get_node("Main").show_screen("game")
				)
				btn.mouse_entered.connect(func():
					GameManager.world = captured_w
					_show_preview(captured_id)
				)
				_style_btn(btn, "secondary", 14)
				row.add_child(btn)

				var stars: int = GameManager.get_stars(w, fid)
				if stars > 0:
					var star_lbl := Label.new()
					star_lbl.text = "★".repeat(stars) + "☆".repeat(3 - stars)
					star_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
					star_lbl.add_theme_font_size_override("font_size", 14)
					star_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
					row.add_child(star_lbl)

				box.add_child(row)

# ── Comic panel preview ───────────────────────────────────
func _reset_preview() -> void:
	for child in _comic_strip.get_children():
		child.queue_free()
	# Placeholder panel — styled like a blank comic page
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
	if ResourceLoader.exists(res_path):
		var tex := ResourceLoader.load(res_path) as Texture2D
		if tex:
			return tex
	return null

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

	# ── Row layouts — classic comic book grid ─────────────
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
		# Only 1 frame — single wide panel
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

	# NPC sprite — fills width, extends below panel so only upper half is visible (close-up crop)
	if npc_raw != "":
		var npc_tex := TextureRect.new()
		# TextureRect spans 1.6× the panel height starting from top.
		# CENTERED keeps aspect ratio and auto-pads — character scales to fit the width,
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
