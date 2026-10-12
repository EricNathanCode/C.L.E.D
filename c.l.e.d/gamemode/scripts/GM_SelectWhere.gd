extends VBoxContainer
const Comic = preload("res://scripts/ComicStyle.gd")

signal on_correct
signal on_wrong
signal on_quit

var _answer:    String     = ""
var _step_data: Dictionary = {}

func _ready() -> void:
	_apply_terminal_style(%SQLTerminal)
	Comic.body(%Description, 20, Comic.INK)
	Comic.body(%TableLabel, 22, Comic.INK)
	_style_input(%SQLBlock/Line2/Blank1)
	_wire_grow(%SQLBlock/Line2/Blank1)
	Comic.heading(%QueryLabel, 26, Comic.BLUE)
	for _l in %SQLBlock.find_children("*", "Label", true, false):
		if not _l.has_theme_color_override("font_color"):
			Comic.body(_l as Label, 18, Color(0.78, 0.85, 0.95))
	%ExecuteButton.pressed.connect(_on_execute)
	%HintButton.pressed.connect(_on_hint)
	%ContinueButton.pressed.connect(_on_continue)
	%SQLBlock/Line2/Blank1.text_submitted.connect(func(_t): _on_execute())
	_style_btn(%ExecuteButton, Color("#F59E0B"), Color("#1A1008"))
	_style_btn_outline(%HintButton, Color("#4fc3f7"))
	_style_btn(%ContinueButton,          Color("#16A34A"), Color.WHITE)
	Comic.body(%HintLabel, 18, Color("#1F66C4"))

func setup(data: Dictionary) -> void:
	_step_data = data;  _answer = data.get("answer", "")
	%Description.text                              = data.get("desc", "")
	%HintLabel.text                                = "Hint: " + data.get("hint", "")
	%TableLabel.text                               = "TABLE: " + data.get("table", "[table]")
	%SQLBlock/Line1.text               = "[color=#6BB0E8]SELECT[/color] * [color=#6BB0E8]FROM[/color] [color=#F5BF4D]" + data.get("table", "[table]") + "[/color]"
	%SQLBlock/Line2/WhereKeyword.text  = "[color=#6BB0E8]WHERE[/color] [color=#F5BF4D]" + data.get("column", "[column]") + "[/color] = '"
	%SQLBlock/Line2/Blank1.text        = ""
	%HintLabel.visible = false;  %ResultBox.visible = false;  %ContinueButton.visible = false
	_fill_table(%DataTable, data.get("table_headers", []), data.get("table_rows", []))
	%SQLBlock/Line2/Blank1.grab_focus()

func _on_execute() -> void:
	var inp: LineEdit = %SQLBlock/Line2/Blank1
	var val: String = inp.text.strip_edges()
	if val.is_empty(): _fill_error(%ResultBox, "Please type the search value."); return
	if val.to_lower() == _answer.to_lower():
		inp.text = _answer
		_fit_grow(inp, _answer)
		_fill_result(%ResultBox, _step_data.get("result_headers",[]),
			_step_data.get("result_rows",[]), _step_data.get("result_msg",""))
	else:
		on_wrong.emit()
		_fill_error(%ResultBox, "'" + val + "' not found. Check the dialogue and try again.")

func _on_hint() -> void:    %HintLabel.visible = true
func _on_continue() -> void: on_correct.emit()

func _fill_table(c: Node, headers: Array, rows: Array) -> void:
	for ch in c.get_children(): ch.queue_free()
	if headers.is_empty(): c.visible = false; return
	c.visible = true;  c.add_child(_build_table(headers, rows))

func _fill_result(c: Node, headers: Array, rows: Array, msg: String) -> void:
	for ch in c.get_children(): ch.queue_free()
	var ok: Label = Label.new()
	ok.text = "Query executed successfully."
	Comic.heading(ok, 24, Color("#1E8E4F"))
	c.add_child(ok)
	if not headers.is_empty(): c.add_child(_build_table(headers, rows))
	if not msg.is_empty():
		var ml: Label = Label.new(); ml.text = msg
		ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		Comic.body(ml, 17, Comic.INK_SOFT)
		c.add_child(ml)
	c.visible = true;  %ContinueButton.visible = true

func _fill_error(c: Node, msg: String) -> void:
	for ch in c.get_children(): ch.queue_free()
	var lbl: Label = Label.new()
	lbl.text = "ERROR: " + msg;  lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	Comic.body(lbl, 18, Comic.RED)
	c.add_child(lbl);  c.visible = true

func _apply_terminal_style(panel: PanelContainer) -> void:
	var s: StyleBoxFlat = Comic.box(Color("#211B16"), Comic.INK, 4, 8, 0, 18, 12)
	s.border_width_left = 10
	panel.add_theme_stylebox_override("panel", s)

func _fit_grow(le: LineEdit, text: String) -> void:
	var font: Font = le.get_theme_font("font")
	if font == null: font = ThemeDB.fallback_font
	var fsize: int = le.get_theme_font_size("font_size")
	if fsize <= 0: fsize = ThemeDB.fallback_font_size
	var base_w: float = max(font.get_string_size(le.placeholder_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x + 36.0, 50.0)
	var text_w: float = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x
	le.custom_minimum_size.x = clamp(text_w + 36.0, base_w, base_w + 320.0)

func _wire_grow(le: LineEdit) -> void:
	_fit_grow(le, le.text)
	le.text_changed.connect(func(new_text: String): _fit_grow(le, new_text))

func _style_input(inp: LineEdit) -> void:
	var ns: StyleBoxFlat = Comic.box(Color("#3A2F26"), Comic.YELLOW, 3, 6, 0, 10, 4)
	inp.add_theme_stylebox_override("normal", ns)
	var fs: StyleBoxFlat = Comic.box(Color("#4A3C30"), Comic.YELLOW_HI, 4, 6, 0, 10, 3)
	inp.add_theme_stylebox_override("focus", fs)
	inp.add_theme_color_override("font_color", Comic.YELLOW_HI)
	inp.add_theme_color_override("font_placeholder_color", Color(Comic.YELLOW, 0.45))
	inp.add_theme_color_override("caret_color", Color.WHITE)
	inp.add_theme_color_override("selection_color", Color(Comic.YELLOW, 0.35))
	inp.add_theme_font_override("font", Comic.body_font())
	inp.add_theme_font_size_override("font_size", 18)

func _build_table(headers: Array, rows: Array) -> VBoxContainer:
	var all_rows: Array = [headers] + rows
	var font: Font = Comic.body_font();  var fsize: int = 17
	var hfont: Font = Comic.body_font();  var hsize: int = 17
	var col_min: Array = []
	for c in range(headers.size()):
		var max_w: float = 0.0
		for ri in range(all_rows.size()):
			var r: Array = all_rows[ri]
			if c < r.size():
				var w: float = (hfont if ri == 0 else font).get_string_size(str(r[c]), HORIZONTAL_ALIGNMENT_LEFT, -1, hsize if ri == 0 else fsize).x
				if w > max_w: max_w = w
		col_min.append(max_w + 28.0)
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
	var is_null: bool = txt == "NULL" and not is_header
	var s: StyleBoxFlat = StyleBoxFlat.new()
	s.bg_color = Comic.YELLOW if is_header else (Color("#FFD9D3") if is_null else Comic.PAPER_HI)
	s.border_color = Comic.INK;  s.set_border_width_all(2)
	s.content_margin_left = 10;  s.content_margin_right  = 10
	s.content_margin_top  = 4;   s.content_margin_bottom = 4
	pc.add_theme_stylebox_override("panel", s)
	var lbl: Label = Label.new();  lbl.text = txt
	if is_header:
		lbl.add_theme_font_override("font", Comic.body_font());  lbl.add_theme_font_size_override("font_size", 17)
	else:
		lbl.add_theme_font_override("font", Comic.body_font());  lbl.add_theme_font_size_override("font_size", 17)
	lbl.add_theme_color_override("font_color", Comic.RED if is_null else Comic.INK)
	pc.add_child(lbl);  return pc

# ── Shared button stylers ─────────────────────────────────
func _style_btn(btn: Button, bg: Color, fg: Color) -> void:
	# Amber Execute -> yellow, green Continue -> green (comic look)
	Comic.apply_button(btn, "success" if bg.g > bg.r else "primary", 22, true, 20, 7)

func _style_btn_outline(btn: Button, col: Color) -> void:
	Comic.apply_button(btn, "info", 22, true, 20, 7)
