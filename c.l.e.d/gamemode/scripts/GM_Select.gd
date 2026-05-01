extends VBoxContainer

signal on_correct
signal on_quit

var _correct_id: int = -1

func _ready() -> void:
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	$QueryLine/IdInput.text_submitted.connect(func(_t): _on_execute())

func setup(data: Dictionary) -> void:
	_correct_id = data.get("correct_id", -1)
	$Description.text       = data.get("desc", "")
	$HintLabel.text         = "Hint: " + data.get("hint", "")
	$QueryLine/IdInput.text = ""
	$HintLabel.visible      = false
	$ContinueButton.visible = false
	_remove_node("_data_table")
	_remove_node("_result_container")

	var options: Array = data.get("options", [])
	var rows: Array = []
	for opt in options:
		rows.append([str(opt[0]), str(opt[1])])

	var tbl: VBoxContainer = _build_table(["id", "option"], rows)
	tbl.name = "_data_table"
	add_child(tbl)
	move_child(tbl, $TableLabel.get_index() + 1)
	$QueryLine/IdInput.grab_focus()

func _on_execute() -> void:
	var inp: LineEdit = $QueryLine/IdInput
	var val: String = inp.text.strip_edges()
	if val.is_empty():
		_show_error("Please type an id number from the table."); return
	if not val.is_valid_int():
		_show_error("id must be a number. Try again."); return
	if int(val) == _correct_id:
		_show_result(
			["id", "selected option"],
			[[str(_correct_id), "Correct response selected."]],
			"Response id = " + val + " chosen.")
		$ContinueButton.visible = true
	else:
		_show_error("id = " + val + " is not the correct response. Try again.")

func _on_hint() -> void:    $HintLabel.visible = true
func _on_continue() -> void: on_correct.emit()

func _show_result(headers: Array, rows: Array, msg: String) -> void:
	_remove_node("_result_container")
	var c: VBoxContainer = VBoxContainer.new()
	c.name = "_result_container"
	c.add_theme_constant_override("separation", 6)
	var ok: Label = Label.new(); ok.text = "Query executed successfully."; c.add_child(ok)
	if not headers.is_empty(): c.add_child(_build_table(headers, rows))
	if not msg.is_empty():
		var ml: Label = Label.new(); ml.text = msg; c.add_child(ml)
	add_child(c)
	move_child(c, $ButtonRow.get_index())

func _show_error(msg: String) -> void:
	_remove_node("_result_container")
	var c: VBoxContainer = VBoxContainer.new()
	c.name = "_result_container"
	var lbl: Label = Label.new()
	lbl.text = "ERROR: " + msg; lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	c.add_child(lbl); add_child(c)
	move_child(c, $ButtonRow.get_index())

func _remove_node(n: String) -> void:
	if has_node(n): get_node(n).queue_free()

# ── Auto-sizing table (like CSS table-layout:auto) ────────

func _build_table(headers: Array, rows: Array) -> VBoxContainer:
	var all_rows: Array = [headers] + rows
	# Measure max text width per column using the fallback font
	var font: Font  = ThemeDB.fallback_font
	var fsize: int  = ThemeDB.fallback_font_size
	var col_min: Array = []
	for c in range(headers.size()):
		var max_w: float = 0.0
		for r in all_rows:
			if c < r.size():
				var w: float = font.get_string_size(
					str(r[c]), HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x
				if w > max_w: max_w = w
		col_min.append(max_w + 24.0)   # 24 = left+right padding (10+10+border)

	var wrap: VBoxContainer = VBoxContainer.new()
	wrap.add_theme_constant_override("separation", 0)
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for i in range(all_rows.size()):
		wrap.add_child(_make_row(all_rows[i], i == 0, col_min))
	return wrap

func _make_row(cells: Array, is_header: bool, col_min: Array) -> HBoxContainer:
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for i in range(cells.size()):
		row.add_child(_cell(str(cells[i]), is_header,
			col_min[i] if i < col_min.size() else 60.0))
	return row

func _cell(txt: String, is_header: bool, min_w: float) -> PanelContainer:
	var pc: PanelContainer = PanelContainer.new()
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pc.custom_minimum_size   = Vector2(min_w, 0)
	var s: StyleBoxFlat = StyleBoxFlat.new()
	s.bg_color     = Color(0.05, 0.09, 0.16) if is_header else Color(0.08, 0.13, 0.2)
	s.border_color = Color(0.22, 0.32, 0.45)
	s.set_border_width_all(1)
	s.content_margin_left = 10; s.content_margin_right  = 10
	s.content_margin_top  = 5;  s.content_margin_bottom = 5
	pc.add_theme_stylebox_override("panel", s)
	var lbl: Label = Label.new()
	lbl.text = txt
	if is_header: lbl.modulate = Color(1.0, 0.78, 0.0)
	pc.add_child(lbl)
	return pc
