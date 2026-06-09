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
	if mode == "failed":
		_icon_lbl.text = "✗"
		_icon_lbl.add_theme_color_override("font_color", Color("#EF4444"))
		_title_lbl.text = "Lesson Failed"
		_title_lbl.add_theme_color_override("font_color", Color("#EF4444"))
		_sub_lbl.text = "Review the material and try again."
	else:
		_icon_lbl.text = "✓"
		_icon_lbl.add_theme_color_override("font_color", Color("#4ADE80"))
		_title_lbl.text = "Lesson Complete!"
		_title_lbl.add_theme_color_override("font_color", Color.WHITE)
		_sub_lbl.text = "Lesson  " + str(GameManager.lesson_id)

func _on_back() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

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
