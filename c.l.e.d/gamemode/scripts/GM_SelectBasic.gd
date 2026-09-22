extends VBoxContainer

signal on_correct
signal on_wrong
signal on_quit

var _answer:    String     = ""
var _step_data: Dictionary = {}
var _blank:     LineEdit   = null

func _ready() -> void:
	_apply_terminal_style($SQLTerminal)
	$QueryLabel.add_theme_color_override("font_color", Color("#4fc3f7"))
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	_style_btn($ButtonRow/ExecuteButton, Color("#F59E0B"), Color("#1A1008"))
	_style_btn_outline($ButtonRow/HintButton, Color("#4fc3f7"))
	_style_btn($ContinueButton, Color("#16A34A"), Color.WHITE)
	$HintLabel.add_theme_color_override("font_color", Color("#4fc3f7"))

func _on_hint()     -> void: $HintLabel.visible = true
func _on_continue() -> void: on_correct.emit()

func setup(data: Dictionary) -> void:
	_step_data = data
	_answer    = data.get("answer", "*")
	$Description.text   = data.get("desc", "")
	$HintLabel.text     = "Hint: " + data.get("hint", "")
	$TableLabel.text    = "TABLE: " + data.get("table", "[table]")
	$HintLabel.visible      = false
	$ResultBox.visible      = false
	$ContinueButton.visible = false
	for ch in $SQLTerminal/SQLBlock.get_children(): ch.queue_free()
	# Line 1: SELECT [blank] FROM table;
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	$SQLTerminal/SQLBlock.add_child(row)
	var pre := Label.new(); pre.text = "SELECT  "; _style_code_label(pre); row.add_child(pre)
	_blank = LineEdit.new()
	_blank.placeholder_text = "* or columns"
	_blank.custom_minimum_size = Vector2(160, 0)
	_blank.max_length = 40
	_blank.text_submitted.connect(func(_t): _on_execute())
	_style_input(_blank); row.add_child(_blank)
	var suf := Label.new(); suf.text = "  FROM " + data.get("table","table") + ";"; _style_code_label(suf); row.add_child(suf)
	_fill_table($DataTable, data.get("table_headers", []), data.get("table_rows", []))
	_blank.grab_focus()

func _on_execute() -> void:
	if _blank == null: return
	var val: String = _blank.text.strip_edges()
	if val.is_empty(): _fill_error($ResultBox, "Type what you want to select — * for every column."); return
	if val.to_lower() == _answer.to_lower():
		_blank.text = _answer
		_fill_result($ResultBox, _step_data.get("result_headers",[]), _step_data.get("result_rows",[]), _step_data.get("result_msg",""))
	else:
		on_wrong.emit()
		_fill_error($ResultBox, "'" + val + "' is not right. Check the hint.")

func _apply_terminal_style(panel: PanelContainer) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.04, 0.07, 0.13)
	s.border_color = Color(0.22, 0.32, 0.45)
	s.set_border_width_all(1);  s.border_width_left = 4
	s.content_margin_left = 14;  s.content_margin_right  = 14
	s.content_margin_top  = 10;  s.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", s)

func _style_input(inp: LineEdit) -> void:
	var ns := StyleBoxFlat.new()
	ns.bg_color = Color(0.04, 0.07, 0.13, 1.0)
	ns.border_color = Color(1.0, 0.78, 0.0);  ns.border_width_bottom = 2
	ns.content_margin_left = 6;  ns.content_margin_right  = 6
	ns.content_margin_top  = 3;  ns.content_margin_bottom = 3
	inp.add_theme_stylebox_override("normal", ns)
	var fs := ns.duplicate() as StyleBoxFlat;  fs.border_width_bottom = 3
	inp.add_theme_stylebox_override("focus", fs)
	inp.add_theme_color_override("font_color", Color(1.0, 0.78, 0.0))
	inp.add_theme_color_override("font_placeholder_color", Color(1.0, 0.78, 0.0, 0.3))

func _style_code_label(lbl: Label) -> void:
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", Color(0.78, 0.85, 0.95))

func _fill_table(c: Node, headers: Array, rows: Array) -> void:
	for ch in c.get_children(): ch.queue_free()
	if headers.is_empty(): c.visible = false; return
	c.visible = true;  c.add_child(_build_table(headers, rows))

func _fill_result(c: Node, headers: Array, rows: Array, msg: String) -> void:
	for ch in c.get_children(): ch.queue_free()
	var ok: Label = Label.new()
	ok.text = "Query executed successfully."
	ok.add_theme_color_override("font_color", Color("#4ADE80"))
	c.add_child(ok)
	if not headers.is_empty(): c.add_child(_build_table(headers, rows))
	if not msg.is_empty():
		var ml: Label = Label.new(); ml.text = msg
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ml.add_theme_color_override("font_color", Color(0.80, 0.85, 0.95))
		c.add_child(ml)
	c.visible = true;  $ContinueButton.visible = true

func _fill_error(c: Node, msg: String) -> void:
	for ch in c.get_children(): ch.queue_free()
	var lbl: Label = Label.new()
	lbl.text = "ERROR: " + msg;  lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	c.add_child(lbl);  c.visible = true

func _build_table(headers: Array, rows: Array) -> VBoxContainer:
	var all_rows: Array = [headers] + rows
	var font: Font = ThemeDB.fallback_font;  var fsize: int = ThemeDB.fallback_font_size
	var col_min: Array = []
	for c in range(headers.size()):
		var max_w: float = 0.0
		for r in all_rows:
			if c < r.size():
				var w: float = font.get_string_size(str(r[c]), HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x
				if w > max_w: max_w = w
		col_min.append(max_w + 24.0)
	var wrap: VBoxContainer = VBoxContainer.new()
	wrap.add_theme_constant_override("separation", 0)
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for i in range(all_rows.size()): wrap.add_child(_make_row(all_rows[i], i == 0, col_min))
	return wrap

func _make_row(cells: Array, is_header: bool, col_min: Array) -> HBoxContainer:
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for i in range(cells.size()):
		row.add_child(_cell(str(cells[i]), is_header, col_min[i] if i < col_min.size() else 60.0))
	return row

func _cell(txt: String, is_header: bool, min_w: float) -> PanelContainer:
	var pc: PanelContainer = PanelContainer.new()
	pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pc.custom_minimum_size   = Vector2(min_w, 0)
	var s: StyleBoxFlat = StyleBoxFlat.new()
	s.bg_color = Color(0.05, 0.09, 0.16) if is_header else Color(0.08, 0.13, 0.2)
	s.border_color = Color(0.22, 0.32, 0.45);  s.set_border_width_all(1)
	s.content_margin_left = 10;  s.content_margin_right  = 10
	s.content_margin_top  = 5;   s.content_margin_bottom = 5
	pc.add_theme_stylebox_override("panel", s)
	var lbl: Label = Label.new();  lbl.text = txt
	if is_header: lbl.modulate = Color(1.0, 0.78, 0.0)
	pc.add_child(lbl);  return pc

func _style_btn(btn: Button, bg: Color, fg: Color) -> void:
	btn.add_theme_color_override("font_color", fg)
	var s := StyleBoxFlat.new()
	s.bg_color = bg; s.border_color = Color(0, 0, 0, 0.5)
	s.set_border_width_all(2); s.set_corner_radius_all(6)
	s.content_margin_left = 14; s.content_margin_right  = 14
	s.content_margin_top  = 6;  s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat; h.bg_color = bg.lightened(0.15)
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat; p.bg_color = bg.darkened(0.15)
	btn.add_theme_stylebox_override("pressed", p)

func _style_btn_outline(btn: Button, col: Color) -> void:
	btn.add_theme_color_override("font_color", col)
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0, 0, 0, 0); s.border_color = col
	s.set_border_width_all(2); s.set_corner_radius_all(6)
	s.content_margin_left = 14; s.content_margin_right  = 14
	s.content_margin_top  = 6;  s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat; h.bg_color = Color(col.r, col.g, col.b, 0.1)
	btn.add_theme_stylebox_override("hover", h); btn.add_theme_stylebox_override("pressed", h)
