extends RefCounted
# Splits a lesson SQL-challenge scene (GM_*.tscn) into two floating windows,
# like Simulation Mode: a Data Table window and a separate SQL Terminal window.
# Every GM_* scene shares the same top-level nodes, so one helper covers them all.

const FLOATING_WINDOW: PackedScene = preload("res://scene/FloatingWindow.tscn")
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")

const TABLE_NODES: Array = ["TableLabel", "DataTable"]
const TERMINAL_NODES: Array = ["Description", "QueryLabel", "SQLTerminal", "HintLabel", "ResultBox", "ButtonRow", "ContinueButton"]

const TOP_MARGIN: float = 72.0
const WIN_Y: float = 52.0
const WIN_H: float = 570.0

# gm must already be a child of the GameScreen's SQLOverlay and set up.
static func apply(gm: Control, back_btn: Button) -> void:
	gm.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	gm.offset_top = TOP_MARGIN
	gm.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var layer := Control.new()
	layer.name = "SplitLayer"
	layer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Take the nodes out of the old single column before the layer is added.
	var table_nodes: Array = _take(gm, TABLE_NODES)
	var terminal_nodes: Array = _take(gm, TERMINAL_NODES)
	gm.add_child(layer)

	back_btn.position = Vector2(16, 0)
	layer.add_child(back_btn)

	_add_window(layer, "Data Table", Vector2(16, WIN_Y), Vector2(620, WIN_H), table_nodes)
	var term_win: FloatingWindow = _add_window(layer, "SQL Terminal", Vector2(652, WIN_Y), Vector2(612, WIN_H), terminal_nodes)
	_dress_up(gm, term_win)

static func _take(gm: Control, names: Array) -> Array:
	var found: Array = []
	for n in names:
		var node: Node = gm.get_node_or_null(n)
		if node != null:
			found.append(node)
	return found

static func _add_window(layer: Control, title: String, pos: Vector2, win_size: Vector2, nodes: Array) -> FloatingWindow:
	var win: FloatingWindow = FLOATING_WINDOW.instantiate()
	win.window_title = title
	layer.add_child(win)
	win.place_at(pos, win_size)

	# Scrolls only if the content is bigger than the window.
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	win.get_content_area().add_child(scroll)

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 12)
	scroll.add_child(box)

	for node in nodes:
		node.reparent(box, false)
	return win

# ── Comic v2 dressing (decoration only) ──────────────────
static func _dress_up(gm: Control, term_win: FloatingWindow) -> void:
	# The task text becomes a yellow "MISSION" caption box
	var desc: Label = gm.get_node_or_null("%Description")
	if desc != null:
		var box := PanelContainer.new()
		box.add_theme_stylebox_override("panel", Comic.box(Comic.YELLOW, Comic.INK, 4, 2, 5, 14, 9))
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 2)
		box.add_child(col)
		var head := Label.new()
		head.text = "MISSION"
		Comic.heading(head, 21, Comic.RED)
		col.add_child(head)
		var parent: Node = desc.get_parent()
		var at: int = desc.get_index()
		parent.add_child(box)
		parent.move_child(box, at)
		desc.reparent(col, false)
		Comic.body(desc, 19, Comic.INK)

	# The table name is a little white chip
	var tlbl: Label = gm.get_node_or_null("%TableLabel")
	if tlbl != null:
		tlbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		var chip := Comic.box(Comic.PAPER_HI, Comic.INK, 3, 18, 3, 14, 2)
		tlbl.add_theme_stylebox_override("normal", chip)
		Comic.body(tlbl, 20, Comic.INK)

	# Long hints wrap inside the window instead of pushing it sideways
	var hint_lbl: Label = gm.get_node_or_null("%HintLabel")
	if hint_lbl != null:
		hint_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint_lbl.custom_minimum_size.x = 200.0

	var exec: Button = gm.get_node_or_null("%ExecuteButton")
	if exec != null:
		exec.text = "Execute  ▶"
		Fx.tilt(exec, -1.5)
	var hint: Button = gm.get_node_or_null("%HintButton")
	if hint != null:
		hint.text = "?  Hint"
		for st in ["normal", "hover", "pressed", "hover_pressed"]:
			var sb = hint.get_theme_stylebox(st)
			if sb is StyleBoxFlat:
				var c: StyleBoxFlat = sb.duplicate()
				c.set_corner_radius_all(26)
				hint.add_theme_stylebox_override(st, c)

	# A "CORRECT!" burst pops onto the terminal window when the answer is right
	var cont: Button = gm.get_node_or_null("%ContinueButton")
	if cont != null:
		cont.text = "Continue Story  ▶"
		var stick: Array = [null]
		cont.visibility_changed.connect(func():
			if cont.visible and stick[0] == null and is_instance_valid(term_win):
				var b := Fx.sticker("CORRECT!", "", Comic.YELLOW, Comic.RED, Vector2(200, 108), 38, 16, 7.0)
				b.position = Vector2(term_win.size.x - 292.0, -62.0)
				term_win.add_child(b)
				Fx.pop(b)
				stick[0] = b
			elif not cont.visible and stick[0] != null and is_instance_valid(stick[0]):
				stick[0].queue_free()
				stick[0] = null
		)
