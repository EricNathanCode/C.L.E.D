extends VBoxContainer
# ═══════════════════════════════════════════════════════
#  GM SQL BLANK  |  gamemode/scripts/GM_SqlBlank.gd
#  Generic fill-in-the-blank gamemode: unlike the other GM_*
#  scenes (which hard-code exactly one fixed blank position
#  per concept, e.g. always the column list in SELECT), this
#  one takes a full "code" query string with a literal
#  "[BLANK]" marker placed ANYWHERE in it — the keyword, the
#  table name, a value, whatever the lesson wants to test —
#  matching the same flexible format FolderQuizScreen.gd uses.
# ═══════════════════════════════════════════════════════

signal on_correct
signal on_wrong
signal on_quit

const SQL_KEYWORDS: Array = [
	"select", "from", "where", "insert", "into", "values", "update", "set", "delete",
	"and", "or", "not", "null", "is", "like", "in", "between", "order", "by", "group",
	"having", "limit", "as", "distinct", "asc", "desc", "count", "sum", "avg", "join", "on",
]

var _answer:    String     = ""
var _step_data: Dictionary = {}
var _blank:     LineEdit   = null
var _known_members: Dictionary = {}   # this round's table + column names, lowercased

func _ready() -> void:
	_apply_terminal_style($SQLTerminal)
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
	_answer    = str(data.get("answer", ""))
	$Description.text = data.get("desc", "")
	$HintLabel.text    = "Hint: " + data.get("hint", "")
	$TableLabel.text   = "TABLE: " + data.get("table", "[table]")
	$HintLabel.visible      = false
	$ResultBox.visible      = false
	$ContinueButton.visible = false
	for ch in $SQLTerminal/SQLBlock.get_children(): ch.queue_free()

	_known_members.clear()
	_known_members[str(data.get("table", "")).to_lower()] = true
	for h in data.get("table_headers", []):
		_known_members[str(h).to_lower()] = true

	# The blank stays INLINE in the query sentence, matching every other
	# GM_*.gd lesson. A multi-line "code" string (e.g. INSERT INTO's
	# "...\nVALUES (...);") is split into one row per line, each its own
	# HBoxContainer stacked in SQLBlock — same structure GM_InsertInto.tscn
	# etc. use with separate "Line1"/"Line2" rows — with the LineEdit
	# embedded inline on whichever line actually contains "[BLANK]".
	#
	# Colored text is built from plain Labels (one per token), NOT a
	# RichTextLabel — a RichTextLabel with BBCode color tags was tried
	# first, but even with identical font/font_size confirmed via live
	# inspection, it did not render visually the same size as the LineEdit
	# blank sitting next to it (a real engine quirk between RichTextLabel's
	# "normal_font_size" and Label/LineEdit's "font_size"). Multiple plain
	# Labels, each with its own font_color override, packed into a
	# zero-separation sub-row, gets per-token coloring while guaranteeing
	# identical rendering to the blank, since both are proven-consistent
	# Label/LineEdit controls.
	var code: String = data.get("code", "[BLANK]")
	var lines: PackedStringArray = code.split("\n")
	_blank = null

	for line_text in lines:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 4)
		$SQLTerminal/SQLBlock.add_child(row)

		var idx: int = line_text.find("[BLANK]") if _blank == null else -1
		if idx >= 0:
			var prefix: String = line_text.substr(0, idx)
			var suffix: String = line_text.substr(idx + 7)

			if not prefix.is_empty():
				row.add_child(_make_code_segment_row(prefix))

			_blank = LineEdit.new()
			_blank.placeholder_text = "fill in"
			_blank.max_length = 60
			_blank.text_submitted.connect(func(_t): _on_execute())
			_style_input(_blank); _wire_grow(_blank); row.add_child(_blank)

			if not suffix.is_empty():
				row.add_child(_make_code_segment_row(suffix))
		else:
			row.add_child(_make_code_segment_row(line_text))

	_fill_table($DataTable, data.get("table_headers", []), data.get("table_rows", []))
	if _blank:
		_blank.grab_focus()

func _make_code_segment_row(text: String) -> HBoxContainer:
	var seg_row := HBoxContainer.new()
	seg_row.add_theme_constant_override("separation", 0)
	for token in _tokenize_sql(text):
		var lbl := Label.new()
		lbl.text = token[0]
		lbl.add_theme_font_size_override("font_size", 14)
		lbl.add_theme_color_override("font_color", token[1])
		seg_row.add_child(lbl)
	return seg_row

func _is_letter_or_underscore(c: String) -> bool:
	return (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or c == "_"

func _is_ident_char(c: String) -> bool:
	return _is_letter_or_underscore(c) or (c >= "0" and c <= "9")

# Returns an Array of [substring, Color] pairs covering the whole string,
# in order — keywords blue, this round's table/column names amber, string
# literals orange, numbers green, everything else (spaces, punctuation,
# other identifiers) in the same neutral color the other GM_*.gd lessons
# use for their static query text.
func _tokenize_sql(text: String) -> Array:
	var default_color: Color = Color(0.78, 0.85, 0.95)
	var keyword_color: Color = Color(0.42, 0.69, 0.91)
	var member_color:  Color = Color(0.96, 0.75, 0.30)
	var string_color:  Color = Color(0.81, 0.57, 0.47)
	var number_color:  Color = Color(0.71, 0.81, 0.66)

	var tokens: Array = []
	var i: int = 0
	var n: int = text.length()
	while i < n:
		var c: String = text[i]
		if c == "'":
			var j: int = i + 1
			while j < n and text[j] != "'":
				j += 1
			j = min(j, n - 1)
			tokens.append([text.substr(i, j - i + 1), string_color])
			i = j + 1
		elif c >= "0" and c <= "9":
			var j: int = i
			while j < n and (text[j] >= "0" and text[j] <= "9"):
				j += 1
			tokens.append([text.substr(i, j - i), number_color])
			i = j
		elif _is_letter_or_underscore(c):
			var j: int = i
			while j < n and _is_ident_char(text[j]):
				j += 1
			var word: String = text.substr(i, j - i)
			if SQL_KEYWORDS.has(word.to_lower()):
				tokens.append([word, keyword_color])
			elif _known_members.has(word.to_lower()):
				tokens.append([word, member_color])
			else:
				tokens.append([word, default_color])
			i = j
		else:
			var j: int = i
			while j < n and not (_is_letter_or_underscore(text[j]) or (text[j] >= "0" and text[j] <= "9") or text[j] == "'"):
				j += 1
			tokens.append([text.substr(i, j - i), default_color])
			i = j
	return tokens

# Once the blank is correctly filled, its text should carry the same
# semantic color the word would have if it were static query text — a
# keyword like INSERT/INTO turns blue, this round's table/column name
# turns amber, a bare number turns green — instead of staying whatever
# fixed color the empty input box used while the player was still typing.
func _color_for_word(word: String) -> Color:
	if SQL_KEYWORDS.has(word.to_lower()):
		return Color(0.42, 0.69, 0.91)
	if _known_members.has(word.to_lower()):
		return Color(0.96, 0.75, 0.30)
	if word.is_valid_int() or word.is_valid_float():
		return Color(0.71, 0.81, 0.66)
	return Color(0.78, 0.85, 0.95)

func _on_execute() -> void:
	if _blank == null: return
	var val: String = _blank.text.strip_edges()
	if val.is_empty(): _fill_error($ResultBox, "Type your answer for the blank."); return
	if val.to_lower() == _answer.to_lower():
		_blank.text = _answer
		_blank.add_theme_color_override("font_color", _color_for_word(_answer))
		_fit_grow(_blank, _answer)
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
	# Font + font_size were both verified identical to the surrounding
	# RichTextLabel via live inspection, so the earlier "looks bigger"
	# complaint wasn't a font mismatch — it was this box's own visual
	# weight: a filled background, a thick bright underline, and padding
	# the plain colored text next to it doesn't have. Toning all of that
	# down (no fill, thin single-color underline, tight margins, explicit
	# small height) so the blank sits visually level with the rest of the line.
	var ns := StyleBoxFlat.new()
	ns.bg_color = Color(0, 0, 0, 0)
	ns.border_color = Color(0.96, 0.75, 0.30);  ns.border_width_bottom = 1
	ns.content_margin_left = 2;  ns.content_margin_right  = 2
	ns.content_margin_top  = 0;  ns.content_margin_bottom = 0
	inp.add_theme_stylebox_override("normal", ns)
	var fs := ns.duplicate() as StyleBoxFlat;  fs.border_width_bottom = 2
	inp.add_theme_stylebox_override("focus", fs)
	inp.add_theme_color_override("font_color", Color(0.96, 0.75, 0.30))
	inp.add_theme_color_override("font_placeholder_color", Color(0.96, 0.75, 0.30, 0.3))
	inp.add_theme_font_override("font", ThemeDB.fallback_font)
	inp.add_theme_font_size_override("font_size", 14)
	inp.custom_minimum_size.y = 0

func _fit_grow(le: LineEdit, text: String) -> void:
	var font: Font = le.get_theme_font("font")
	if font == null: font = ThemeDB.fallback_font
	var fsize: int = le.get_theme_font_size("font_size")
	if fsize <= 0: fsize = ThemeDB.fallback_font_size
	var base_w: float = max(font.get_string_size(le.placeholder_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x + 14.0, 30.0)
	var text_w: float = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x
	le.custom_minimum_size.x = clamp(text_w + 14.0, base_w, base_w + 320.0)

func _wire_grow(le: LineEdit) -> void:
	_fit_grow(le, le.text)
	le.text_changed.connect(func(new_text: String): _fit_grow(le, new_text))

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
	if txt == "NULL" and not is_header: s.bg_color = Color(0.18, 0.07, 0.07)
	s.border_color = Color(0.22, 0.32, 0.45);  s.set_border_width_all(1)
	s.content_margin_left = 10;  s.content_margin_right  = 10
	s.content_margin_top  = 5;   s.content_margin_bottom = 5
	pc.add_theme_stylebox_override("panel", s)
	var lbl: Label = Label.new();  lbl.text = txt
	if is_header: lbl.modulate = Color(0.96, 0.75, 0.30)
	elif txt == "NULL": lbl.modulate = Color(0.80, 0.35, 0.35)
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
