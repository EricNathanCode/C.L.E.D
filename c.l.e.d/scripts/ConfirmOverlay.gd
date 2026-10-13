extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
# ═══════════════════════════════════════════════════════
#  CONFIRM OVERLAY  |  scripts/ConfirmOverlay.gd
#  "Are you sure?" pop-up for actions that can't be undone.
#    ConfirmOverlay.open(host, "Title", "Message", "Delete", on_confirm)
#  Cancel, the ✕ button, Esc and clicking outside all cancel.
# ═══════════════════════════════════════════════════════

var _title: String = ""
var _message: String = ""
var _confirm_text: String = "Confirm"
var _on_confirm: Callable = Callable()

static func open(host: Control, title: String, message: String, confirm_text: String, on_confirm: Callable) -> Control:
	var o := preload("res://scripts/ConfirmOverlay.gd").new()
	o._title = title
	o._message = message
	o._confirm_text = confirm_text
	o._on_confirm = on_confirm
	host.add_child(o)
	return o

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = 130
	mouse_filter = Control.MOUSE_FILTER_STOP

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Comic.apply_dim(dim, 0.75)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			_cancel()
	)
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(460, 0)
	Comic.apply_panel(panel, Comic.PAPER, 16, 8, 28, 22, 5)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var head := HBoxContainer.new()
	vbox.add_child(head)
	var title := Label.new()
	title.text = _title
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.heading(title, 32, Comic.RED)
	head.add_child(title)
	var x_btn := Button.new()
	x_btn.text = "✕"
	x_btn.pressed.connect(_cancel)
	Comic.apply_icon_button(x_btn, "danger", 22)
	head.add_child(x_btn)

	var msg := Label.new()
	msg.text = _message
	msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	msg.custom_minimum_size = Vector2(404, 0)
	Comic.body(msg, 18, Comic.INK)
	vbox.add_child(msg)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 16)
	vbox.add_child(row)
	var cancel := Button.new()
	cancel.text = "Cancel"
	cancel.pressed.connect(_cancel)
	Comic.apply_button(cancel, "secondary", 22, true, 22, 8)
	row.add_child(cancel)
	var ok := Button.new()
	ok.text = _confirm_text
	ok.pressed.connect(_confirm)
	Comic.apply_button(ok, "danger", 22, true, 22, 8)
	row.add_child(ok)

	# Safe default: the keyboard starts on Cancel, not on the destructive button
	cancel.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_cancel()

func _cancel() -> void:
	queue_free()

func _confirm() -> void:
	var cb: Callable = _on_confirm
	queue_free()
	if cb.is_valid():
		cb.call()
