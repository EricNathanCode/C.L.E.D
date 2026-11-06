extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
# ═══════════════════════════════════════════════════════
#  RANK OVERLAY  |  scripts/RankOverlay.gd
#  The Class Ranking pop-up (RANK button on the Dashboard). One world at a
#  time: total lesson stars, then the best score in each Simulation folder,
#  for this player and every classmate on the same Wi-Fi (see LanRank.gd).
#  Opened with:  RankOverlay.open(self)
# ═══════════════════════════════════════════════════════

const WORLD_TABS: Array = [
	["hotel",   "Hotel"],
	["cafe",    "Cafe"],
	["airport", "Airport"],
	["library", "Library"],
]

# [board key, title, small caption]. The Simulation keys follow LanRank.SIM_FOLDERS.
const BOARDS: Array = [
	["stars",     "Lesson Stars",         "Stars earned, out of 51"],
	["basic",     "Basic SQL",            "Simulation best score"],
	["filtering", "Filtering Rows",       "Simulation best score"],
	["sorting",   "Sorting & Aggregates", "Simulation best score"],
]

const MEDAL: Array = [Color("#FFC21A"), Color("#D3CDBF"), Color("#E0995A")]   # 1st, 2nd, 3rd
const YOU_BG := Color("#FFE58A")

var _world: String = "hotel"
var _tab_btns: Dictionary = {}    # world → Button
var _lists: Dictionary = {}       # board key → VBoxContainer
var _status_lbl: Label = null
var _panel: PanelContainer = null
var _dirty: bool = false
var _refresh_wait: float = 0.0
var _status_wait: float = 0.0

static func open(host: Control) -> Control:
	var o := preload("res://scripts/RankOverlay.gd").new()
	host.add_child(o)
	return o

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = 100
	mouse_filter = Control.MOUSE_FILTER_STOP
	for t in WORLD_TABS:
		if t[0] == GameManager.world:
			_world = GameManager.world

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Comic.apply_dim(dim, 0.72)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			_close()
	)
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	_panel = PanelContainer.new()
	Comic.apply_panel(_panel, Comic.PAPER, 16, 8, 26, 20, 5)
	center.add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

	# Header: trophy, title, close
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	vbox.add_child(head)
	head.add_child(Fx.icon_rect("trophy", 44))
	var title := Label.new()
	title.text = "Class Ranking"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.title(title, 38, Comic.YELLOW, 8)
	head.add_child(title)
	var x_btn := Button.new()
	x_btn.text = "✕"
	x_btn.pressed.connect(_close)
	Comic.apply_icon_button(x_btn, "danger", 22)
	head.add_child(x_btn)

	var rule := ColorRect.new()
	rule.custom_minimum_size = Vector2(0, 4)
	rule.color = Comic.INK
	vbox.add_child(rule)

	# World tabs, and how many classmates were found
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 10)
	vbox.add_child(tabs)
	for t in WORLD_TABS:
		var b := Button.new()
		b.text = t[1]
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(_pick_world.bind(t[0]))
		tabs.add_child(b)
		_tab_btns[t[0]] = b
	_status_lbl = Label.new()
	_status_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_status_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	Comic.body(_status_lbl, 17, Comic.INK_SOFT)
	tabs.add_child(_status_lbl)

	# The four boards side by side, each with its own scroll
	var boards := HBoxContainer.new()
	boards.add_theme_constant_override("separation", 14)
	boards.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(boards)
	for bd in BOARDS:
		boards.add_child(_make_board(bd[0], bd[1], bd[2]))

	# Footer: share switch and a hint (desktop only)
	if LanRank.supported:
		var foot := HBoxContainer.new()
		foot.add_theme_constant_override("separation", 16)
		vbox.add_child(foot)
		var share := CheckBox.new()
		share.text = "Share my name and scores with classmates on this Wi-Fi"
		share.button_pressed = GameManager.lan_share_enabled
		share.focus_mode = Control.FOCUS_NONE
		share.add_theme_icon_override("unchecked", Fx.icon("checkbox_off", 26))
		share.add_theme_icon_override("checked", Fx.icon("checkbox_on", 26))
		share.add_theme_constant_override("h_separation", 8)
		share.add_theme_font_override("font", Comic.body_font())
		share.add_theme_font_size_override("font_size", 16)
		for c in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color", "font_focus_color"]:
			share.add_theme_color_override(c, Comic.INK)
		var plain := StyleBoxEmpty.new()
		for st in ["normal", "hover", "pressed", "hover_pressed", "focus", "disabled"]:
			share.add_theme_stylebox_override(st, plain)
		share.toggled.connect(func(on: bool):
			GameManager.lan_share_enabled = on
			GameManager.save_settings()
		)
		foot.add_child(share)
		var hint := Label.new()
		hint.text = "Everyone needs CLID open on the same Wi-Fi. If Windows asks, allow CLID on the network."
		hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		Comic.body(hint, 14, Comic.GREY_TEXT)
		foot.add_child(hint)

	# Size: as big as the screen allows, within reason
	var fit := func():
		_panel.custom_minimum_size = Vector2(
			clampf(size.x - 60.0, 860.0, 1240.0),
			clampf(size.y - 50.0, 420.0, 700.0))
	resized.connect(fit)
	fit.call.call_deferred()

	LanRank.changed.connect(_on_lan_changed)
	LanRank.start_listening()
	_pick_world(_world)

func _make_board(key: String, title: String, caption: String) -> Control:
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_stretch_ratio = 1.0
	col.add_theme_constant_override("separation", 8)

	var head := PanelContainer.new()
	head.add_theme_stylebox_override("panel", Comic.box(Comic.INK, Comic.INK, 3, 8, 0, 12, 6))
	col.add_child(head)
	var head_col := VBoxContainer.new()
	head_col.add_theme_constant_override("separation", 0)
	head.add_child(head_col)
	var head_row := HBoxContainer.new()
	head_row.add_theme_constant_override("separation", 6)
	head_col.add_child(head_row)
	if key == "stars":
		head_row.add_child(Fx.icon_rect("star", 24))
	var t := Label.new()
	t.text = title
	t.clip_text = true
	t.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.heading(t, 22, Comic.YELLOW)
	head_row.add_child(t)
	var cap := Label.new()
	cap.text = caption
	Comic.body(cap, 13, Comic.PAPER)
	head_col.add_child(cap)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)
	var pad := MarginContainer.new()
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_right", 12)
	pad.add_theme_constant_override("margin_bottom", 6)
	scroll.add_child(pad)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 6)
	pad.add_child(list)
	_lists[key] = list
	return col

func _pick_world(world: String) -> void:
	_world = world
	for w in _tab_btns:
		Comic.apply_button(_tab_btns[w], "primary" if w == world else "secondary", 20, true, 18, 6)
	_refresh()

func _on_lan_changed() -> void:
	if not _dirty:
		_dirty = true
		_refresh_wait = 0.4   # gather a burst of updates into one redraw

func _process(delta: float) -> void:
	if _dirty:
		_refresh_wait -= delta
		if _refresh_wait <= 0.0:
			_dirty = false
			_refresh()
	_status_wait -= delta
	if _status_wait <= 0.0:
		_status_wait = 1.0
		_update_status()

func _refresh() -> void:
	var people: Array = LanRank.board()
	for i in BOARDS.size():
		var key: String = BOARDS[i][0]
		var rows: Array = []
		for p in people:
			var value: int = p.stars[_world] if key == "stars" else p.sim[_world][i - 1]
			rows.append({"name": p.name, "value": value, "you": p.you})
		_fill_board(_lists[key], rows, key == "stars")
	_update_status()

# Highest first; ties share a rank (1, 1, 3), with this player first among
# them (so their row is easy to find) and the rest by name.
# Nobody is ranked with 0: they're listed last, faded, with "-" for the rank.
func _fill_board(list: VBoxContainer, rows: Array, is_stars: bool) -> void:
	for c in list.get_children():
		c.queue_free()
	rows.sort_custom(func(a, b):
		if a.value != b.value:
			return a.value > b.value
		if a.you != b.you:
			return a.you
		return a.name.to_lower() < b.name.to_lower()
	)
	var rank: int = 0
	for i in rows.size():
		if i == 0 or rows[i].value != rows[i - 1].value:
			rank = i + 1
		var r: Dictionary = rows[i]
		list.add_child(_make_row(rank if r.value > 0 else 0, r.name, r.value, r.you, is_stars))

func _make_row(rank: int, player: String, value: int, is_you: bool, is_stars: bool) -> Control:
	var row := PanelContainer.new()
	row.tooltip_text = player
	row.add_theme_stylebox_override("panel",
		Comic.box(YOU_BG if is_you else Comic.PAPER_HI, Comic.INK, 4 if is_you else 2, 8, 3 if is_you else 0, 8, 4))
	if value == 0 and not is_you:
		row.modulate.a = 0.55
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	row.add_child(h)

	var badge := Label.new()
	badge.text = str(rank) if rank > 0 else "-"
	badge.custom_minimum_size = Vector2(36, 30)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var badge_bg: Color = MEDAL[rank - 1] if rank >= 1 and rank <= 3 else Comic.PAPER_DARK
	badge.add_theme_stylebox_override("normal", Comic.box(badge_bg, Comic.INK, 3, 15, 0, 4, 0))
	Comic.heading(badge, 20, Comic.INK)
	h.add_child(badge)

	var name_lbl := Label.new()
	name_lbl.text = player
	name_lbl.clip_text = true
	name_lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.custom_minimum_size.x = 40
	Comic.body(name_lbl, 17, Comic.INK)
	h.add_child(name_lbl)

	if is_you:
		var you := Label.new()
		you.text = "YOU"
		you.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		you.add_theme_stylebox_override("normal", Comic.box(Comic.RED, Comic.INK, 2, 5, 0, 4, 0))
		Comic.heading(you, 14, Color.WHITE)
		h.add_child(you)

	if is_stars:
		h.add_child(Fx.icon_rect("star", 20))
	var val := Label.new()
	val.text = str(value)
	val.custom_minimum_size.x = 30 if is_stars else 40
	val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	Comic.heading(val, 22, Comic.INK)
	h.add_child(val)
	return row

func _update_status() -> void:
	if _status_lbl == null:
		return
	var n: int = LanRank.classmate_count()
	if not LanRank.supported:
		_status_lbl.text = "The class ranking works in the downloaded app (Windows or Linux), on the same Wi-Fi as your classmates."
	elif LanRank.listen_failed:
		_status_lbl.text = "Can't join the class network. Close any other CLID window, then open Rank again."
	elif n == 0:
		_status_lbl.text = "Looking for classmates on this Wi-Fi..."
	elif n == 1:
		_status_lbl.text = "1 classmate on this Wi-Fi"
	else:
		_status_lbl.text = "%d classmates on this Wi-Fi" % n

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_close()

func _close() -> void:
	queue_free()
