extends RefCounted
# Splits a lesson SQL-challenge scene (GM_*.tscn) into two floating windows,
# like Simulation Mode: a Data Table window and a separate SQL Terminal window.
# Every GM_* scene shares the same top-level nodes, so one helper covers them all.

const FLOATING_WINDOW: PackedScene = preload("res://scene/FloatingWindow.tscn")

const TABLE_NODES: Array = ["TableLabel", "DataTable"]
const TERMINAL_NODES: Array = ["Description", "QueryLabel", "SQLTerminal", "HintLabel", "ResultBox", "ButtonRow", "ContinueButton"]

const TOP_MARGIN: float = 56.0
const WIN_Y: float = 44.0
const WIN_H: float = 590.0

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
	_add_window(layer, "SQL Terminal", Vector2(652, WIN_Y), Vector2(612, WIN_H), terminal_nodes)

static func _take(gm: Control, names: Array) -> Array:
	var found: Array = []
	for n in names:
		var node: Node = gm.get_node_or_null(n)
		if node != null:
			found.append(node)
	return found

static func _add_window(layer: Control, title: String, pos: Vector2, win_size: Vector2, nodes: Array) -> void:
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
