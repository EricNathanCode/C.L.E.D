extends Control

func _ready() -> void:
	$ScrollContainer/WorldList/HotelButton.pressed.connect(_on_hotel)
	$ScrollContainer/WorldList/CafeButton.pressed.connect(_on_cafe)
	$ScrollContainer/WorldList/PoliceButton.pressed.connect(_on_police)
	$ScrollContainer/WorldList/LibraryButton.pressed.connect(_on_library)
	$ExitButton.pressed.connect(_on_exit)

	# Style exit button — red so it's clearly different
	_style_btn($ScrollContainer/WorldList/HotelButton,    Color("#2563EB"), Color.WHITE)
	_style_btn($ScrollContainer/WorldList/CafeButton,    Color("#DC2626"), Color.WHITE)
	_style_btn($ScrollContainer/WorldList/PoliceButton,   Color("#1D4ED8"), Color.WHITE)
	_style_btn($ScrollContainer/WorldList/LibraryButton,  Color("#7C3AED"), Color.WHITE)
	_style_btn($ExitButton,                               Color("#374151"), Color.WHITE)

	# Style title
	$Title.add_theme_font_size_override("font_size", 24)

func _on_hotel() -> void:
	GameManager.world = "hotel"
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_cafe() -> void:
	GameManager.world = "cafe"
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_police() -> void:
	GameManager.world = "police"
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_library() -> void:
	GameManager.world = "library"
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_exit() -> void:
	get_tree().quit()

func _style_btn(btn: Button, bg: Color, fg: Color) -> void:
	btn.add_theme_font_size_override("font_size", 18)
	btn.add_theme_color_override("font_color", fg)
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = bg.darkened(0.2)
	s.set_border_width_all(2)
	s.set_corner_radius_all(8)
	s.content_margin_left   = 20
	s.content_margin_right  = 20
	s.content_margin_top    = 10
	s.content_margin_bottom = 10
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color = bg.lightened(0.12)
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = bg.darkened(0.12)
	btn.add_theme_stylebox_override("pressed", p)
