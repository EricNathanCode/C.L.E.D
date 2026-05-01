extends VBoxContainer

signal on_correct
signal on_quit

var _answer_id: String     = ""
var _step_data: Dictionary = {}

func _ready() -> void:
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	$SQLBlock/Line2/Blank1.text_submitted.connect(func(_t): _on_execute())

func setup(data: Dictionary) -> void:
	_step_data = data;  _answer_id = str(data.get("answer_id", ""))
	$Description.text    = data.get("desc", "")
	$HintLabel.text      = "Hint: " + data.get("hint", "")
	$TableLabel.text     = "TABLE: " + data.get("table", "[table]")
	$SQLBlock/Line1.text = "DELETE FROM " + data.get("table", "[table]")
	$SQLBlock/Line2/Blank1.text = ""
	$HintLabel.visible = false;  $ResultBox.visible = false;  $ContinueButton.visible = false
	_fill_table($DataTable, data.get("table_headers", []), data.get("table_rows", []))
	$SQLBlock/Line2/Blank1.grab_focus()

func _on_execute() -> void:
	var inp: LineEdit = $SQLBlock/Line2/Blank1
	var val: String = inp.text.strip_edges()
	if val.is_empty(): _fill_error($ResultBox, "Please type the record id to delete."); return
	if val == _answer_id:
		_fill_result($ResultBox, _step_data.get("result_headers", []),
			_step_data.get("result_rows", []), _step_data.get("result_msg", ""))
	else:
		_fill_error($ResultBox, "id = " + val + " is not the correct record. Try again.")

func _on_hint() -> void:    $HintLabel.visible = true
func _on_continue() -> void: on_correct.emit()

func _fill_table(c: Node, headers: Array, rows: Array) -> void:
	for ch in c.get_children(): ch.queue_free()
	if headers.is_empty(): c.visible = false; return
	c.visible = true;  c.add_child(_build_table(headers, rows))

func _fill_result(c: Node, headers: Array, rows: Array, msg: String) -> void:
	for ch in c.get_children(): ch.queue_free()
	var ok: Label = Label.new(); ok.text = "Query executed successfully."; c.add_child(ok)
	if not headers.is_empty(): c.add_child(_build_table(headers, rows))
	if not msg.is_empty(): var ml: Label = Label.new(); ml.text = msg; c.add_child(ml)
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
	for i in range(all_rows.size()):
		wrap.add_child(_make_row(all_rows[i], i == 0, col_min))
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
