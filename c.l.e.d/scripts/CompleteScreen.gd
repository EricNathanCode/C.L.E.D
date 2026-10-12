extends Control
const Comic = preload("res://scripts/ComicStyle.gd")

const Dashboard = preload("res://scripts/DashboardScreen.gd")

@onready var _vbox        := $CenterContainer/CardPanel/VBoxContainer
@onready var _icon_lbl    := $CenterContainer/CardPanel/VBoxContainer/IconLabel
@onready var _title_lbl   := $CenterContainer/CardPanel/VBoxContainer/Title
@onready var _sub_lbl     := $CenterContainer/CardPanel/VBoxContainer/LessonLabel
@onready var _hub_btn     := $CenterContainer/CardPanel/VBoxContainer/BackToHubButton
@onready var _world_btn   := $CenterContainer/CardPanel/VBoxContainer/ChangeWorldButton

func _ready() -> void:
	_hub_btn.pressed.connect(_on_back)
	_world_btn.pressed.connect(_on_change_world)
	_vbox.add_theme_constant_override("separation", 10)

	# Celebration page: yellow halftone burst behind an ink-outlined card
	Comic.apply_halftone($FullBG, Comic.PAPER, Comic.YELLOW_HI, 18.0, 0.10, 0.46)
	Comic.apply_panel($CenterContainer/CardPanel, Comic.PAPER_HI, 22, 10, 40, 20, 5)
	$CenterContainer/CardPanel.custom_minimum_size = Vector2(460, 0)

	# Sub label
	Comic.heading(_sub_lbl, 26, Comic.INK_SOFT)

	# Buttons (the dynamic "next step" button, when present, is the primary CTA)
	_style_btn(_hub_btn,   "secondary", 24)
	_style_btn(_world_btn, "ghost", 22)

func set_mode(mode: String) -> void:
	# Remove any dynamic nodes from a previous call immediately (not deferred)
	for tag in ["_stars_row", "_recap_box", "_next_btn", "_replay_btn"]:
		var old = _vbox.get_node_or_null(tag)
		if old:
			old.free()

	if mode == "failed":
		_icon_lbl.text = "✗"
		Comic.title(_icon_lbl, 64, Comic.RED, 12)
		_title_lbl.text = "Lesson Failed"
		Comic.title(_title_lbl, 54, Comic.RED_HI, 10)
		_sub_lbl.text = "Review the material and try again."
		_add_replay_btn()
	else:
		_icon_lbl.text = "✓"
		Comic.title(_icon_lbl, 64, Comic.GREEN_HI, 12)
		_title_lbl.text = "Lesson Complete!"
		Comic.title(_title_lbl, 54, Comic.YELLOW, 10)
		_sub_lbl.text = "Lesson  " + str(GameManager.lesson_id)
		_add_complete_extras()

func _on_back() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func _add_replay_btn() -> void:
	var replay_btn := Button.new()
	replay_btn.name = "_replay_btn"
	replay_btn.text = "↺  Replay Lesson"
	replay_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("game")
	)
	_style_btn(replay_btn, "secondary", 22)
	_vbox.add_child(replay_btn)
	_vbox.move_child(replay_btn, _sub_lbl.get_index() + 1)

func _add_complete_extras() -> void:
	var insert_idx: int = _sub_lbl.get_index() + 1

	# ── Stars row ─────────────────────────────────────
	var stars_row := HBoxContainer.new()
	stars_row.name = "_stars_row"
	stars_row.alignment = BoxContainer.ALIGNMENT_CENTER
	stars_row.add_theme_constant_override("separation", 6)
	_vbox.add_child(stars_row)
	_vbox.move_child(stars_row, insert_idx)
	insert_idx += 1

	var star_count: int = GameManager.last_stars
	for i in range(3):
		var s := Label.new()
		s.text = "★"
		s.add_theme_font_size_override("font_size", 46)
		s.add_theme_color_override("font_color", Comic.YELLOW if i < star_count else Comic.PAPER_DARK)
		s.add_theme_color_override("font_outline_color", Comic.INK)
		s.add_theme_constant_override("outline_size", 10)
		stars_row.add_child(s)

	# ── SQL Recap box ─────────────────────────────────
	var recap: Array = GameManager.get_sql_recap()
	if recap.size() > 0:
		var recap_box := VBoxContainer.new()
		recap_box.name = "_recap_box"
		recap_box.add_theme_constant_override("separation", 4)
		_vbox.add_child(recap_box)
		_vbox.move_child(recap_box, insert_idx)
		insert_idx += 1

		var recap_panel := PanelContainer.new()
		recap_panel.add_theme_stylebox_override("panel", Comic.box(Comic.PAPER, Comic.INK, 3, 10, 0, 16, 10))
		recap_box.add_child(recap_panel)

		var inner := VBoxContainer.new()
		inner.add_theme_constant_override("separation", 4)
		recap_panel.add_child(inner)

		var rt := Label.new()
		rt.text = "SQL Commands in this Lesson"
		Comic.heading(rt, 22, Comic.RED)
		inner.add_child(rt)

		for cmd in recap:
			var cl := Label.new()
			cl.text = "  " + cmd
			Comic.body(cl, 20, Color("#1E8E4F"))
			inner.add_child(cl)

	# ── Next step button (Next Lesson / Folder Challenge) ──
	var next_data: Dictionary = _next_step_data()
	if not next_data.is_empty():
		var next_btn := Button.new()
		next_btn.name = "_next_btn"
		next_btn.text = next_data["label"]
		if next_data["action"] == "quiz":
			var cap_fi: int = next_data["folder_idx"]
			next_btn.pressed.connect(func():
				GameManager.current_quiz_folder_idx = cap_fi
				get_tree().root.get_node("Main").show_screen("folder_quiz")
			)
		else:
			var cap_lid = next_data["lesson_id"]
			next_btn.pressed.connect(func():
				GameManager.lesson_id = cap_lid
				get_tree().root.get_node("Main").show_screen("game")
			)
		_style_btn(next_btn, "primary", 32)
		_vbox.add_child(next_btn)
		_vbox.move_child(next_btn, insert_idx)
		insert_idx += 1

	# ── Replay button ─────────────────────────────────
	var replay_btn := Button.new()
	replay_btn.name = "_replay_btn"
	replay_btn.text = "↺  Replay Lesson"
	replay_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("game")
	)
	_style_btn(replay_btn, "ghost", 15)
	_vbox.add_child(replay_btn)
	_vbox.move_child(replay_btn, insert_idx)

# ── Determine what comes after the just-completed lesson ──
# Mirrors DashboardScreen's own unlock rules so this button
# never offers something the Dashboard would still show as locked.
func _next_step_data() -> Dictionary:
	var world: String = GameManager.world
	var lid = GameManager.lesson_id
	var ids: Array
	var folders: Array
	match world:
		"hotel":   ids = Dashboard.HOTEL_LESSONS;   folders = Dashboard.HOTEL_FOLDERS
		"cafe":    ids = Dashboard.CAFE_LESSONS;    folders = Dashboard.CAFE_FOLDERS
		"airport": ids = Dashboard.AIRPORT_LESSONS; folders = Dashboard.AIRPORT_FOLDERS
		"library": ids = Dashboard.LIBRARY_LESSONS; folders = Dashboard.LIBRARY_FOLDERS
		_: return {}

	var folder_idx: int = -1
	var is_last_in_folder: bool = false
	for fi in range(folders.size()):
		var fids: Array = folders[fi]["ids"]
		if fids.has(lid):
			folder_idx = fi
			is_last_in_folder = fids[fids.size() - 1] == lid
			break

	if folder_idx == -1:
		return {}

	# Just finished the last lesson in this folder and haven't passed its
	# challenge yet — that's the next thing to do, not the next folder.
	if is_last_in_folder and not GameManager.is_folder_quiz_done(world, folder_idx):
		var is_final: bool = folder_idx == folders.size() - 1
		return {
			"label":  "⚡  Final Test  →" if is_final else "⚡  Folder Challenge  →",
			"action": "quiz",
			"folder_idx": folder_idx,
		}

	var idx: int = ids.find(lid)
	if idx >= 0 and idx < ids.size() - 1:
		return {
			"label":  "Next Lesson  →",
			"action": "lesson",
			"lesson_id": ids[idx + 1],
		}

	return {}

# ── Button styles (comic look, from ComicStyle) ──────
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 16) -> void:
	var pad_h: int = 26 if variant == "primary" else 22
	Comic.apply_button(btn, variant, font_size, true, pad_h, 10)
