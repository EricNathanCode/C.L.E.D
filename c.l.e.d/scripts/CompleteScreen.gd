extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/BackToHubButton.pressed.connect(_on_back)
	$CenterContainer/VBoxContainer/ChangeWorldButton.pressed.connect(_on_change_world)
	_style_btn($CenterContainer/VBoxContainer/BackToHubButton)
	_style_btn($CenterContainer/VBoxContainer/ChangeWorldButton)
	$CenterContainer/VBoxContainer/Title.add_theme_font_size_override("font_size", 28)
	$CenterContainer/VBoxContainer/Title.add_theme_color_override("font_color", Color.WHITE)

func set_mode(mode: String) -> void:
	var title: Label = $CenterContainer/VBoxContainer/Title
	if mode == "failed":
		title.text = "Lesson Failed"
		title.add_theme_color_override("font_color", Color("#DC2626"))  # red
		$CenterContainer/VBoxContainer/LessonLabel.text = "Better luck next time!"
	else:
		title.text = "Lesson Complete"
		title.add_theme_color_override("font_color", Color.WHITE)
		$CenterContainer/VBoxContainer/LessonLabel.text = "Lesson: " + str(GameManager.lesson_id)

func _on_back() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

# ── Button styling — white bg, black border, yellow hover ──
func _style_btn(btn: Button) -> void:
	btn.add_theme_color_override("font_color", Color.BLACK)
	var s := StyleBoxFlat.new()
	s.bg_color     = Color.WHITE
	s.border_color = Color.BLACK
	s.set_border_width_all(2)
	s.set_corner_radius_all(6)
	s.content_margin_left   = 14;  s.content_margin_right  = 14
	s.content_margin_top    = 6;   s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color("#F59E0B")
	h.border_color = Color("#B45309")
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color     = Color("#D97706")
	p.border_color = Color("#92400E")
	btn.add_theme_stylebox_override("pressed", p)
