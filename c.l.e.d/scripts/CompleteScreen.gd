extends Control

@onready var _vbox        := $CenterContainer/CardPanel/VBoxContainer
@onready var _icon_lbl    := $CenterContainer/CardPanel/VBoxContainer/IconLabel
@onready var _title_lbl   := $CenterContainer/CardPanel/VBoxContainer/Title
@onready var _sub_lbl     := $CenterContainer/CardPanel/VBoxContainer/LessonLabel
@onready var _hub_btn     := $CenterContainer/CardPanel/VBoxContainer/BackToHubButton
@onready var _world_btn   := $CenterContainer/CardPanel/VBoxContainer/ChangeWorldButton

func _ready() -> void:
	_hub_btn.pressed.connect(_on_back)
	_world_btn.pressed.connect(_on_change_world)

	# Card panel dark styling
	var card := StyleBoxFlat.new()
	card.bg_color = Color(0.10, 0.12, 0.17, 0.97)
	card.border_color = Color(0.26, 0.31, 0.44)
	card.set_border_width_all(2)
	card.set_corner_radius_all(16)
	card.content_margin_left   = 36
	card.content_margin_right  = 36
	card.content_margin_top    = 32
	card.content_margin_bottom = 32
	$CenterContainer/CardPanel.add_theme_stylebox_override("panel", card)

	# Icon — large result symbol
	_icon_lbl.add_theme_font_size_override("font_size", 52)

	# Title
	_title_lbl.add_theme_font_size_override("font_size", 26)

	# Sub label — muted
	_sub_lbl.add_theme_font_size_override("font_size", 15)
	_sub_lbl.add_theme_color_override("font_color", Color(0.60, 0.65, 0.75))

	# Buttons — primary CTA and ghost secondary
	_style_btn(_hub_btn,   "primary", 16)
	_style_btn(_world_btn, "ghost",   15)

func set_mode(mode: String) -> void:
	# Remove any dynamic nodes from a previous call immediately (not deferred)
	for tag in ["_stars_row", "_recap_box", "_replay_btn"]:
		var old = _vbox.get_node_or_null(tag)
		if old:
			old.free()

	if mode == "failed":
		_icon_lbl.text = "✗"
		_icon_lbl.add_theme_color_override("font_color", Color("#EF4444"))
		_title_lbl.text = "Lesson Failed"
		_title_lbl.add_theme_color_override("font_color", Color("#EF4444"))
		_sub_lbl.text = "Review the material and try again."
		_add_replay_btn()
	else:
		_icon_lbl.text = "✓"
		_icon_lbl.add_theme_color_override("font_color", Color("#4ADE80"))
		_title_lbl.text = "Lesson Complete!"
		_title_lbl.add_theme_color_override("font_color", Color.WHITE)
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
	_style_btn(replay_btn, "ghost", 15)
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
		s.add_theme_font_size_override("font_size", 32)
		if i < star_count:
			s.add_theme_color_override("font_color", Color("#F59E0B"))
		else:
			s.add_theme_color_override("font_color", Color(0.22, 0.25, 0.35))
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
		var rps := StyleBoxFlat.new()
		rps.bg_color = Color(0.07, 0.08, 0.12, 0.95)
		rps.border_color = Color(0.22, 0.27, 0.40)
		rps.set_border_width_all(1)
		rps.set_corner_radius_all(6)
		rps.content_margin_left   = 14
		rps.content_margin_right  = 14
		rps.content_margin_top    = 10
		rps.content_margin_bottom = 10
		recap_panel.add_theme_stylebox_override("panel", rps)
		recap_box.add_child(recap_panel)

		var inner := VBoxContainer.new()
		inner.add_theme_constant_override("separation", 4)
		recap_panel.add_child(inner)

		var rt := Label.new()
		rt.text = "SQL Commands in this Lesson"
		rt.add_theme_font_size_override("font_size", 11)
		rt.add_theme_color_override("font_color", Color(0.45, 0.50, 0.65))
		inner.add_child(rt)

		for cmd in recap:
			var cl := Label.new()
			cl.text = "  " + cmd
			cl.add_theme_font_size_override("font_size", 13)
			cl.add_theme_color_override("font_color", Color("#4ADE80"))
			inner.add_child(cl)

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
		"ghost":
			btn.add_theme_color_override("font_color", Color(0.52, 0.57, 0.68))
			s.bg_color     = Color(0, 0, 0, 0)
			s.border_color = Color(0.30, 0.35, 0.46)
			s.set_border_width_all(2)
			s.content_margin_left   = 24; s.content_margin_right  = 24
			s.content_margin_top    = 10; s.content_margin_bottom = 10

	var h := s.duplicate() as StyleBoxFlat
	var p := s.duplicate() as StyleBoxFlat

	match variant:
		"primary":
			h.bg_color = Color("#FBBF24")
			p.bg_color = Color("#D97706")
		"ghost":
			h.bg_color     = Color(0.13, 0.16, 0.22, 0.50)
			h.border_color = Color(0.52, 0.58, 0.70)
			p.bg_color     = Color(0.08, 0.10, 0.14, 0.50)

	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)
