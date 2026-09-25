extends Control
class_name FloatingWindow
# ═══════════════════════════════════════════════════════
#  FLOATING WINDOW  |  scripts/FloatingWindow.gd
#  Reusable draggable / minimizable panel used by the
#  Simulation screen for its Terminal and Table windows.
# ═══════════════════════════════════════════════════════

signal minimized_changed(is_minimized: bool)

@export var window_title: String = "Window":
	set(value):
		window_title = value
		if is_inside_tree():
			_title_lbl.text = value
			_chip.text = "▸  " + value

const MIN_WINDOW_SIZE: Vector2 = Vector2(220, 140)

var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _minimized: bool = false

var _resizing: bool = false
var _resize_start_mouse: Vector2 = Vector2.ZERO
var _resize_start_size: Vector2 = Vector2.ZERO

@onready var _panel:         PanelContainer = $Panel
@onready var _title_bar:     PanelContainer = $Panel/VBox/TitleBar
@onready var _title_lbl:     Label          = $Panel/VBox/TitleBar/TitleBarRow/TitleLabel
@onready var _min_btn:       Button         = $Panel/VBox/TitleBar/TitleBarRow/MinimizeButton
@onready var _content_area:  MarginContainer = $Panel/VBox/ContentArea
@onready var _chip:          Button         = $Chip
@onready var _resize_handle: Label          = $ResizeHandle

func _ready() -> void:
	_style_panel()
	_style_chip()
	_style_resize_handle()
	_title_lbl.text = window_title
	_chip.text = "▸  " + window_title

	_min_btn.pressed.connect(func(): set_minimized(true))
	_chip.pressed.connect(func(): set_minimized(false))
	_title_bar.gui_input.connect(_on_titlebar_input)
	_resize_handle.gui_input.connect(_on_resize_input)

func get_content_area() -> MarginContainer:
	return _content_area

func set_minimized(value: bool) -> void:
	_minimized = value
	_panel.visible = not value
	_chip.visible = value
	_resize_handle.visible = not value
	minimized_changed.emit(value)

func is_minimized() -> bool:
	return _minimized

func place_at(pos: Vector2, win_size: Vector2) -> void:
	position = pos
	size = win_size
	custom_minimum_size = win_size

func _on_titlebar_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_drag_offset = get_global_mouse_position() - global_position
			get_viewport().set_input_as_handled()
		else:
			_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset
		# Keep the title bar reachable even if dragged mostly off-screen
		var parent_size: Vector2 = get_parent_area_size()
		global_position.x = clamp(global_position.x, -size.x + 60, parent_size.x - 60)
		global_position.y = clamp(global_position.y, 0, parent_size.y - 32)

func _on_resize_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_resizing = true
			_resize_start_mouse = get_global_mouse_position()
			_resize_start_size = size
			get_viewport().set_input_as_handled()
		else:
			_resizing = false
	elif event is InputEventMouseMotion and _resizing:
		var delta: Vector2 = get_global_mouse_position() - _resize_start_mouse
		var new_size: Vector2 = _resize_start_size + delta
		new_size.x = max(new_size.x, MIN_WINDOW_SIZE.x)
		new_size.y = max(new_size.y, MIN_WINDOW_SIZE.y)
		size = new_size
		custom_minimum_size = new_size

func _style_resize_handle() -> void:
	_resize_handle.add_theme_font_size_override("font_size", 14)
	_resize_handle.add_theme_color_override("font_color", Color(0.45, 0.52, 0.65))

func _style_panel() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.07, 0.09, 0.13, 0.98)
	s.border_color = Color(0.30, 0.36, 0.48)
	s.set_border_width_all(2)
	s.set_corner_radius_all(10)
	_panel.add_theme_stylebox_override("panel", s)

	var bar_s := StyleBoxFlat.new()
	bar_s.bg_color = Color(0.11, 0.13, 0.19, 1.0)
	bar_s.border_color = Color(0.30, 0.36, 0.48)
	bar_s.border_width_bottom = 1
	bar_s.corner_radius_top_left  = 8
	bar_s.corner_radius_top_right = 8
	bar_s.content_margin_left   = 12
	bar_s.content_margin_right  = 8
	bar_s.content_margin_top    = 6
	bar_s.content_margin_bottom = 6
	_title_bar.add_theme_stylebox_override("panel", bar_s)

	_title_lbl.add_theme_font_size_override("font_size", 13)
	_title_lbl.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))

	_min_btn.add_theme_font_size_override("font_size", 14)
	_min_btn.add_theme_color_override("font_color", Color(0.70, 0.75, 0.85))
	var mb := StyleBoxFlat.new()
	mb.bg_color = Color(0, 0, 0, 0)
	mb.set_corner_radius_all(4)
	mb.content_margin_left = 8; mb.content_margin_right  = 8
	mb.content_margin_top  = 2; mb.content_margin_bottom = 2
	_min_btn.add_theme_stylebox_override("normal", mb)
	var mbh := mb.duplicate() as StyleBoxFlat
	mbh.bg_color = Color(1, 1, 1, 0.12)
	_min_btn.add_theme_stylebox_override("hover", mbh)
	_min_btn.add_theme_stylebox_override("pressed", mbh)

func _style_chip() -> void:
	_chip.add_theme_font_size_override("font_size", 13)
	_chip.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.11, 0.13, 0.19, 0.98)
	s.border_color = Color(0.30, 0.36, 0.48)
	s.set_border_width_all(2)
	s.set_corner_radius_all(8)
	s.content_margin_left = 12; s.content_margin_right  = 12
	s.content_margin_top  = 8;  s.content_margin_bottom = 8
	_chip.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color = Color(0.16, 0.19, 0.27, 0.98)
	_chip.add_theme_stylebox_override("hover", h)
	_chip.add_theme_stylebox_override("pressed", h)
