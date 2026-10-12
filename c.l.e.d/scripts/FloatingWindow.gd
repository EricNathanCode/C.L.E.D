extends Control
class_name FloatingWindow
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
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
	_resize_handle.add_theme_font_size_override("font_size", 18)
	_resize_handle.add_theme_color_override("font_color", Comic.INK)

func _style_panel() -> void:
	# A comic panel whose title is an ink tab sticking out of the top edge.
	# The panel body is drawn by a frame behind the content, starting a little
	# lower so the tab straddles the border.
	var body := StyleBoxEmpty.new()
	body.content_margin_left = 6
	body.content_margin_right = 6
	body.content_margin_bottom = 6
	_panel.add_theme_stylebox_override("panel", body)

	var frame := Panel.new()
	frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	frame.offset_top = 20.0
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_theme_stylebox_override("panel", Comic.box(Comic.PAPER_HI, Comic.INK, 5, 8, 8, 0, 0))
	add_child(frame)
	move_child(frame, 0)
	_panel.visibility_changed.connect(func(): frame.visible = _panel.visible)

	var bar_s := StyleBoxEmpty.new()
	bar_s.content_margin_left = 12
	bar_s.content_margin_right = 8
	_title_bar.add_theme_stylebox_override("panel", bar_s)

	_title_lbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	Fx.tag(_title_lbl, Comic.INK, Comic.YELLOW, 26, true, Comic.RED)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_title_lbl.get_parent().add_child(spacer)
	_title_lbl.get_parent().move_child(spacer, _title_lbl.get_index() + 1)
	Fx.tilt(_title_lbl, -2.0)

	# Minimise: a small red comic button sitting just inside the frame
	Comic.apply_button(_min_btn, "danger", 18, false, 10, 0)
	_min_btn.size_flags_vertical = Control.SIZE_SHRINK_END
	_min_btn.custom_minimum_size = Vector2(38, 26)

func _style_chip() -> void:
	Comic.apply_button(_chip, "dark", 20, true, 14, 6)

# For windows titled with a real table name: keep the name lowercase (the comic
# display font draws everything in capitals).
func use_plain_title_font() -> void:
	Comic.body(_title_lbl, 23, Comic.YELLOW)
	_chip.add_theme_font_override("font", Comic.body_font())
