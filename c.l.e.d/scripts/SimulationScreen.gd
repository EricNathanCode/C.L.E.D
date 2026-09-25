extends Control
# ═══════════════════════════════════════════════════════
#  SIMULATION SCREEN  |  scripts/SimulationScreen.gd
#  Papers Please-style endless mode: NPCs walk in, state a
#  randomly-rolled problem, the player types the full SQL
#  query into the Terminal window, and one wrong answer
#  ends the run. Correct answers really run against a
#  persistent per-world SQLite database (SimDatabase).
# ═══════════════════════════════════════════════════════

const CHAR_BASE := "res://images/characters/NPC_adults/"
const CHAR_ROOT := "res://images/characters/"

const BOB_AMP:   float = 7.0
const BOB_SPEED: float = 10.0
const TYPEWRITER_CPS: float = 26.0

const NPC_WIDTH:  float = 420.0
const _npc_base_top:    float = 60.0
const _npc_base_bottom: float = 620.0

const OCCUPATION_BY_WORLD: Dictionary = {
	"hotel":   "hotel_manager",
	"cafe":    "coffee_owner",
	"airport": "pilot",
	"library": "librarian",
}

# Sprite numbers classified by visual gender, so an INSERT round's rolled
# name (e.g. "My name is Ana Torres") always gets a matching NPC sprite.
const ADULT_MALE:    Array = [1, 3, 5, 7, 9, 11, 13, 15, 17, 20, 22]
const ADULT_FEMALE:  Array = [2, 4, 6, 8, 10, 12, 14, 16, 18, 19, 21, 23, 24]
const KID_MALE:      Array = [3, 5, 9, 10, 11]
const KID_FEMALE:    Array = [1, 2, 4, 6, 7, 8]
const SENIOR_MALE:   Array = [1, 2, 3]
const SENIOR_FEMALE: Array = [4]
const PLUS_MALE:     Array = [2, 6, 8]
const PLUS_FEMALE:   Array = [1, 3, 4, 5, 7, 9]

const Dashboard = preload("res://scripts/DashboardScreen.gd")

const FOLDER_DISPLAY: Dictionary = {
	"all":       "Your Progress",
	"basic":     "Basic SQL",
	"filtering": "Filtering Rows",
	"sorting":   "Sorting & Aggregates",
}

const BASIC_LESSON_NAMES: Dictionary = {
	1: "SELECT", 2: "INSERT INTO", 3: "SELECT WHERE", 4: "UPDATE SET", 5: "DELETE",
}

const SQL_KEYWORDS: Array = [
	"select", "from", "where", "insert", "into", "values", "update", "set", "delete",
	"and", "or", "not", "null", "is", "like", "in", "between", "order", "by", "group",
	"having", "limit", "as", "distinct", "asc", "desc", "count", "sum", "avg", "join", "on",
]

# Same palette as the Terminal's CodeHighlighter, as BBCode hex colors.
const BBCODE_KEYWORD := "#6BB0E8"
const BBCODE_MEMBER  := "#F5BF4D"
const BBCODE_STRING  := "#CF9178"
const BBCODE_NUMBER  := "#B5CFA8"

var _world: String = ""
var _folder: String = "all"
var _lesson_index: int = 0
var _sim_db: SimDatabase = null
var _templates: Array = []
var _current_template: Dictionary = {}
var _current_rolled: Dictionary = {}
var _last_correct_query: String = ""
var _score: int = 0
var _round_locked: bool = false

var _tex_cache: Dictionary = {}
var _bob_time: float = 0.0
var _is_bobbing: bool = false
var _npc_base: String = ""
var _current_role: String = "customer"

var _full_text: String = ""
var _type_index: int = 0
var _type_accum: float = 0.0
var _typing: bool = false

var _table_windows: Dictionary = {}   # table_name -> FloatingWindow
var _terminal_win: FloatingWindow = null
var _terminal_input: CodeEdit = null
var _terminal_status: Label = null
var _sql_highlighter: CodeHighlighter = null
var _auto_caps_guard: bool = false

func _ready() -> void:
	_terminal_win = $WindowLayer/TerminalWindow
	_build_terminal_ui()

	$TopBar/RunLabel.add_theme_color_override("font_color", Color(0.70, 0.75, 0.85))

	$TopBar/EndButton.pressed.connect(_on_end_button)
	$GameOverOverlay/CenterContainer/ResultPanel/ResultVBox/RetryButton.pressed.connect(_on_retry_pressed)
	$GameOverOverlay/CenterContainer/ResultPanel/ResultVBox/BackButton.pressed.connect(_on_back_pressed)

	$NPCSprite.offset_left  = -500.0
	$NPCSprite.offset_right = -80.0

func _process(delta: float) -> void:
	if _is_bobbing and $NPCSprite.visible:
		_bob_time += delta
		var bob: float = sin(_bob_time * BOB_SPEED) * BOB_AMP
		$NPCSprite.offset_top    = _npc_base_top    + bob
		$NPCSprite.offset_bottom = _npc_base_bottom + bob

	if _typing:
		_type_accum += delta * TYPEWRITER_CPS
		var n: int = int(_type_accum)
		if n > 0:
			_type_index = min(_type_index + n, _full_text.length())
			_type_accum -= float(n)
			$DialogueBox/DialogueVBox/ProblemLabel.text = _full_text.substr(0, _type_index)
			if _type_index >= _full_text.length():
				_finish_talking()

# ── Run lifecycle ──────────────────────────────────────
func start_run(world: String, folder: String = "all", lesson_index: int = 0) -> void:
	_world = world
	_folder = folder
	_lesson_index = lesson_index
	_score = 0
	_round_locked = false
	_current_template = {}
	_current_rolled = {}

	for w in _table_windows.values():
		w.queue_free()
	_table_windows.clear()

	if _sim_db:
		_sim_db.close()
	_sim_db = SimDatabase.new()
	_sim_db.open()

	_templates = _load_templates(world)
	$SceneBG.texture = _load_texture(_bg_path_for(world))
	$GameOverOverlay.visible = false
	$NPCSprite.visible = false
	_stop_bob()

	_terminal_win.visible = true
	_terminal_win.set_minimized(false)
	_terminal_win.place_at(Vector2(60, 360), Vector2(420, 260))
	_terminal_status.text = ""
	_terminal_input.text = ""

	_update_score_label()

	if _folder == "filtering" or _folder == "sorting":
		_show_coming_soon_message()
		return

	if _get_available_templates().is_empty():
		_show_locked_message()
		return

	_start_next_round()

func _score_key() -> String:
	if _folder == "all":
		return _world
	var key: String = _world + "_" + _folder
	if _lesson_index > 0:
		key += "_" + str(_lesson_index)
	return key

func _show_locked_message() -> void:
	$DialogueBox/DialogueVBox/NPCNameLabel.text = "LOCKED"
	var need: int = _lesson_index if _lesson_index > 0 else 1
	$DialogueBox/DialogueVBox/ProblemLabel.text = "Complete Lesson %d in this world before running this Simulation." % need

func _show_drained_message() -> void:
	$DialogueBox/DialogueVBox/NPCNameLabel.text = "ALL CLEAR"
	$DialogueBox/DialogueVBox/ProblemLabel.text = "You've cleared out every record available in this mode. Nice work — hit End Run to bank your score."

func _show_coming_soon_message() -> void:
	$DialogueBox/DialogueVBox/NPCNameLabel.text = "COMING SOON"
	$DialogueBox/DialogueVBox/ProblemLabel.text = "%s Simulation problems aren't ready yet — check back after a future update." % FOLDER_DISPLAY.get(_folder, _folder)

func _end_run() -> void:
	_typing = false
	_stop_bob()
	$NPCSprite.visible = false
	var is_new_best: bool = GameManager.report_sim_score(_score_key(), _score)
	$GameOverOverlay/CenterContainer/ResultPanel/ResultVBox/ScoreLabel.text = "You served %d correctly." % _score
	var best_text: String = "Best: %d" % GameManager.get_sim_best(_score_key())
	if is_new_best:
		best_text += "  —  New Best!"
	$GameOverOverlay/CenterContainer/ResultPanel/ResultVBox/BestLabel.text = best_text
	var table: String = _current_template.get("table", "")
	var headers: Array = _current_template.get("table_headers", [])
	var colored_query: String = _colorize_sql(_last_correct_query, table, headers)
	$GameOverOverlay/CenterContainer/ResultPanel/ResultVBox/CorrectQueryLabel.text = "[center]Correct query:\n%s[/center]" % colored_query
	$GameOverOverlay.visible = true

func _on_retry_pressed() -> void:
	start_run(_world, _folder, _lesson_index)

func _on_back_pressed() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_end_button() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _update_score_label() -> void:
	var mode_name: String = FOLDER_DISPLAY.get(_folder, _folder)
	if _lesson_index > 0:
		mode_name += " · " + BASIC_LESSON_NAMES.get(_lesson_index, str(_lesson_index))
	$TopBar/RunLabel.text = "  SIMULATION: %s   Score: %d   |   Best: %d" % [mode_name, _score, GameManager.get_sim_best(_score_key())]

# ── Round flow ─────────────────────────────────────────
func _start_next_round() -> void:
	var pool: Array = _get_available_templates()
	if pool.is_empty():
		if _score > 0:
			_show_drained_message()
		else:
			_show_locked_message()
		return

	var tmpl: Dictionary = pool[randi() % pool.size()]
	_current_template = tmpl
	_sim_db.seed_table(tmpl["table"], tmpl["table_headers"], tmpl.get("table_types", []), tmpl["seed_rows"])
	_current_rolled = _roll_variables(tmpl)
	_last_correct_query = _build_example_query(tmpl, _current_rolled)

	var text: String = tmpl.get("problem_template", tmpl.get("problem", ""))
	text = _fill_template(text, _current_rolled)

	_current_role = tmpl.get("role", "customer")
	var gender: String = _current_rolled.get("_gender", "")
	_refresh_table_window(tmpl["table"])
	_update_sql_members(tmpl["table"], tmpl["table_headers"])
	_walk_in_and_show(text, _random_npc_base(_world, _current_role, gender))

func _get_available_templates() -> Array:
	var furthest: int = _furthest_completed_index(_world)
	if furthest <= 0:
		return []
	var pool: Array = []
	for t in _templates:
		if _folder != "all" and t.get("folder", "basic") != _folder:
			continue
		var req: int = int(t["requires_lesson_index"])
		if req > furthest:
			continue
		if _lesson_index > 0 and req != _lesson_index:
			continue
		if _needs_existing_rows(t["kind"]) and _sim_db.has_table(t["table"]) and _sim_db.fetch_rows(t["table"]).is_empty():
			continue
		pool.append(t)
	return pool

func _needs_existing_rows(kind: String) -> bool:
	return kind == "select_where" or kind == "update_set" or kind == "delete"

func _roll_variables(tmpl: Dictionary) -> Dictionary:
	var rolled: Dictionary = {}
	match tmpl["kind"]:
		"select_column":
			var pool: Array = tmpl["pick_from_columns"]
			rolled["column"] = pool[randi() % pool.size()]
		"insert_into":
			var gender: String = "male" if randi() % 2 == 0 else "female"
			var gender_field: String = tmpl.get("gender_field", "")
			for key in tmpl["variables"].keys():
				if key == gender_field + "_male" or key == gender_field + "_female":
					if key == gender_field + "_" + gender:
						var gpool: Array = tmpl["variables"][key]
						rolled[gender_field] = gpool[randi() % gpool.size()]
					continue
				var pool: Array = tmpl["variables"][key]
				rolled[key] = pool[randi() % pool.size()]
			if gender_field != "":
				rolled["_gender"] = gender
		"select_where":
			var headers: Array = _sim_db.headers_for(tmpl["table"])
			var rows: Array = _sim_db.fetch_rows(tmpl["table"])
			var idx: int = headers.find(tmpl["pick_from_column"])
			var row: Array = rows[randi() % rows.size()]
			rolled["value"] = row[idx]
		"update_set":
			var headers: Array = _sim_db.headers_for(tmpl["table"])
			var rows: Array = _sim_db.fetch_rows(tmpl["table"])
			var idx: int = headers.find(tmpl["pick_id_from"])
			var row: Array = rows[randi() % rows.size()]
			rolled["target_id"] = row[idx]
			var pool: Array = tmpl["new_value_pool"]
			rolled["new_value"] = pool[randi() % pool.size()]
		"delete":
			var headers: Array = _sim_db.headers_for(tmpl["table"])
			var rows: Array = _sim_db.fetch_rows(tmpl["table"])
			var idx: int = headers.find(tmpl["pick_id_from"])
			var row: Array = rows[randi() % rows.size()]
			rolled["target_id"] = row[idx]
	return rolled

func _fill_template(text: String, rolled: Dictionary) -> String:
	var result: String = text
	for key in rolled.keys():
		result = result.replace("{" + key + "}", str(rolled[key]))
	return result

func _build_expected(tmpl: Dictionary, rolled: Dictionary) -> Dictionary:
	var table: String = tmpl["table"]
	match tmpl["kind"]:
		"select_basic":
			return {"starts_with": "SELECT", "table": table, "must_contain": []}
		"select_column":
			return {"starts_with": "SELECT", "table": table, "must_contain": [str(rolled["column"])]}
		"select_where":
			return {"starts_with": "SELECT", "table": table, "must_contain": [str(rolled["value"])]}
		"insert_into":
			var vals: Array = []
			for key in rolled.keys():
				if key != "_gender":
					vals.append(rolled[key])
			return {"starts_with": "INSERT INTO", "table": table, "must_contain": vals}
		"update_set":
			return {"starts_with": "UPDATE", "table": table, "must_contain": [str(rolled["new_value"]), str(rolled["target_id"])]}
		"delete":
			return {"starts_with": "DELETE", "table": table, "must_contain": [str(rolled["target_id"])]}
	return {"starts_with": "", "table": table, "must_contain": []}

# Builds one valid example answer for this round, shown on the game-over
# screen so a wrong answer still teaches the player the right shape.
func _build_example_query(tmpl: Dictionary, rolled: Dictionary) -> String:
	var table: String = tmpl["table"]
	match tmpl["kind"]:
		"select_basic":
			return "SELECT * FROM %s;" % table
		"select_column":
			return "SELECT %s FROM %s;" % [rolled["column"], table]
		"select_where":
			return "SELECT * FROM %s WHERE %s = '%s';" % [table, tmpl["pick_from_column"], rolled["value"]]
		"insert_into":
			var cols: Array = []
			var vals: Array = []
			for key in rolled.keys():
				if key == "_gender":
					continue
				cols.append(key)
				vals.append("'%s'" % rolled[key])
			return "INSERT INTO %s (%s) VALUES (%s);" % [table, ", ".join(cols), ", ".join(vals)]
		"update_set":
			return "UPDATE %s SET %s = '%s' WHERE %s = %s;" % [table, tmpl["set_column"], rolled["new_value"], tmpl["pick_id_from"], rolled["target_id"]]
		"delete":
			return "DELETE FROM %s WHERE %s = %s;" % [table, tmpl["pick_id_from"], rolled["target_id"]]
	return ""

func _check_and_run(query: String, expected: Dictionary) -> bool:
	var q: String = query.strip_edges()
	if q.is_empty():
		return false
	var q_upper: String = q.to_upper()
	if not q_upper.begins_with(expected["starts_with"]):
		return false
	if not q_upper.contains(str(expected["table"]).to_upper()):
		return false
	for frag in expected["must_contain"]:
		if not q_upper.contains(str(frag).to_upper()):
			return false
	return _sim_db.run(q)

func _on_execute() -> void:
	if _current_template.is_empty() or _round_locked:
		return
	if _terminal_input.text.strip_edges().is_empty():
		return

	_round_locked = true
	var expected: Dictionary = _build_expected(_current_template, _current_rolled)
	var correct: bool = _check_and_run(_terminal_input.text, expected)
	_terminal_input.text = ""

	if correct:
		_score += 1
		_update_score_label()
		_terminal_status.modulate = Color(0.55, 0.9, 0.55)
		_terminal_status.text = "Correct."
		_refresh_table_window(_current_template["table"])
		await get_tree().create_timer(0.5).timeout
		_walk_out_then_advance()
	else:
		_terminal_status.modulate = Color(0.95, 0.5, 0.5)
		_terminal_status.text = "That's not right — the run ends here."
		await get_tree().create_timer(0.9).timeout
		_end_run()

# ── NPC walk / bob / talk ──────────────────────────────
func _start_talking(text: String) -> void:
	$DialogueBox/DialogueVBox/NPCNameLabel.text = "COWORKER" if _current_role == "staff" else "CUSTOMER"
	$DialogueBox/DialogueVBox/ProblemLabel.text = ""
	_terminal_status.text = ""
	_round_locked = false

	_full_text  = text
	_type_index = 0
	_type_accum = 0.0
	_typing     = true

	_bob_time = 0.0
	_start_bob()
	var talk_tex: Texture2D = _load_texture(_resolve_npc_path(_npc_base, "talk"))
	if talk_tex:
		$NPCSprite.texture = talk_tex

func _finish_talking() -> void:
	_typing = false
	_stop_bob()
	var idle_tex: Texture2D = _load_texture(_resolve_npc_path(_npc_base, "idle"))
	if idle_tex:
		$NPCSprite.texture = idle_tex

func _start_bob() -> void:
	_is_bobbing = true

func _stop_bob() -> void:
	_is_bobbing = false
	$NPCSprite.offset_top    = _npc_base_top
	$NPCSprite.offset_bottom = _npc_base_bottom

func _walk_in_and_show(problem_text: String, npc_base: String) -> void:
	_npc_base = npc_base
	var npc: TextureRect = $NPCSprite
	npc.texture = _load_texture(_resolve_npc_path(npc_base, "idle"))
	npc.visible = true
	npc.offset_top    = _npc_base_top
	npc.offset_bottom = _npc_base_bottom

	var vp_w: float = size.x if size.x > 0 else get_viewport_rect().size.x
	npc.offset_left  = -NPC_WIDTH - 40.0
	npc.offset_right = -40.0
	var center_x: float = vp_w * 0.5 - NPC_WIDTH * 0.5

	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(npc, "offset_left",  center_x,               0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(npc, "offset_right", center_x + NPC_WIDTH,    0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.chain().tween_callback(func():
		_start_talking(problem_text)
	)

func _walk_out_then_advance() -> void:
	_typing = false
	_stop_bob()
	var npc: TextureRect = $NPCSprite
	var vp_w: float = size.x if size.x > 0 else get_viewport_rect().size.x

	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(npc, "offset_left",  vp_w + 40.0,            0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(npc, "offset_right", vp_w + 40.0 + NPC_WIDTH, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tw.chain().tween_callback(func():
		npc.visible = false
		_start_next_round()
	)

# "staff" lines (coworkers relaying an internal request) always use the
# world's one occupation sprite, matching the lessons' own convention of a
# single recurring boss/manager character. "customer" lines get a random
# regular person, since any kind of guest/customer/passenger/patron could
# plausibly walk up and ask for themselves. When the line has the NPC state
# their own rolled name (INSERT rounds), gender is passed in so the sprite
# actually matches who's supposedly speaking.
func _random_npc_base(world: String, role: String = "customer", gender: String = "") -> String:
	if role == "staff":
		var occ: String = OCCUPATION_BY_WORLD.get(world, "hotel_manager")
		return "NPC_occupations/%s" % occ

	if gender == "male" or gender == "female":
		return _random_gendered_customer_base(gender)

	var roll: int = randi() % 100
	if roll < 55:
		return "adult_%d" % (randi() % 24 + 1)
	elif roll < 75:
		return "NPC_kids/kid_%d" % (randi() % 11 + 1)
	elif roll < 88:
		return "NPC_seniors/Senior_%d" % (randi() % 4 + 1)
	else:
		return "NPC_plus_size/plus_size_%d" % (randi() % 9 + 1)

func _random_gendered_customer_base(gender: String) -> String:
	var adult_pool:  Array = ADULT_MALE  if gender == "male" else ADULT_FEMALE
	var kid_pool:    Array = KID_MALE    if gender == "male" else KID_FEMALE
	var senior_pool: Array = SENIOR_MALE if gender == "male" else SENIOR_FEMALE
	var plus_pool:   Array = PLUS_MALE   if gender == "male" else PLUS_FEMALE

	var roll: int = randi() % 100
	if roll < 55:
		return "adult_%d" % adult_pool[randi() % adult_pool.size()]
	elif roll < 75:
		return "NPC_kids/kid_%d" % kid_pool[randi() % kid_pool.size()]
	elif roll < 88:
		return "NPC_seniors/Senior_%d" % senior_pool[randi() % senior_pool.size()]
	else:
		return "NPC_plus_size/plus_size_%d" % plus_pool[randi() % plus_pool.size()]

# expr is "idle" or "talk". Folders without a dedicated talk.png simply
# have no file at that path — _load_texture returns null and the caller
# keeps whatever texture is already showing instead of blanking it out.
func _resolve_npc_path(npc_base: String, expr: String) -> String:
	var parts := (npc_base + "/" + expr).split("/")
	if parts.size() == 3:
		return CHAR_ROOT + parts[0] + "/" + parts[1] + "/" + parts[2] + ".png"
	elif parts.size() == 2:
		return CHAR_BASE + parts[0] + "/" + parts[1] + ".png"
	return CHAR_BASE + "adult_1/idle.png"

# ── Table windows ──────────────────────────────────────
func _spawn_table_window(table_name: String) -> void:
	var win: FloatingWindow = preload("res://scene/FloatingWindow.tscn").instantiate()
	$WindowLayer.add_child(win)
	win.window_title = table_name.capitalize()

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(320, 150)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var grid := GridContainer.new()
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 0)
	grid.add_theme_constant_override("v_separation", 0)
	scroll.add_child(grid)
	win.get_content_area().add_child(scroll)
	win.set_meta("grid", grid)

	var idx: int = _table_windows.size()
	var pos := Vector2(520.0 + float(idx % 3) * 36.0, 70.0 + float(idx % 3) * 36.0)
	win.place_at(pos, Vector2(360, 220))
	_table_windows[table_name] = win

func _refresh_table_window(table_name: String) -> void:
	if not _table_windows.has(table_name):
		_spawn_table_window(table_name)
	var win: FloatingWindow = _table_windows[table_name]
	var grid: GridContainer = win.get_meta("grid")
	for child in grid.get_children():
		child.queue_free()

	var headers: Array = _sim_db.headers_for(table_name)
	grid.columns = max(headers.size(), 1)
	for h in headers:
		grid.add_child(_make_cell(str(h), true))
	for row in _sim_db.fetch_rows(table_name):
		for v in row:
			grid.add_child(_make_cell(str(v), false))

func _make_cell(text: String, is_header: bool) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.14, 0.17, 0.24, 1.0) if is_header else Color(0.09, 0.11, 0.16, 1.0)
	style.border_color = Color(0.30, 0.36, 0.48)
	style.set_border_width_all(1)
	style.content_margin_left   = 8
	style.content_margin_right  = 8
	style.content_margin_top    = 4
	style.content_margin_bottom = 4
	panel.add_theme_stylebox_override("panel", style)

	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color(0.55, 0.82, 1.0) if is_header else Color(0.85, 0.88, 0.94))
	panel.add_child(lbl)
	return panel

# ── Terminal window ────────────────────────────────────
func _build_terminal_ui() -> void:
	_terminal_win.window_title = "Terminal"

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	_terminal_win.get_content_area().add_child(vbox)

	var hint := Label.new()
	hint.text = "Type the full SQL query and press Execute."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.add_theme_font_size_override("font_size", 12)
	hint.add_theme_color_override("font_color", Color(0.70, 0.75, 0.85))
	vbox.add_child(hint)

	_terminal_input = CodeEdit.new()
	_terminal_input.placeholder_text = "SELECT * FROM ..."
	_terminal_input.custom_minimum_size = Vector2(360, 90)
	_terminal_input.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_terminal_input.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	_terminal_input.scroll_fit_content_height = false
	var tes := StyleBoxFlat.new()
	tes.bg_color = Color(0.04, 0.05, 0.08, 1.0)
	tes.border_color = Color(0.30, 0.36, 0.48)
	tes.set_border_width_all(1)
	tes.content_margin_left   = 8; tes.content_margin_right  = 8
	tes.content_margin_top    = 6; tes.content_margin_bottom = 6
	_terminal_input.add_theme_stylebox_override("normal", tes)
	var tesf := tes.duplicate() as StyleBoxFlat
	tesf.border_color = Color("#F59E0B")
	_terminal_input.add_theme_stylebox_override("focus", tesf)
	_terminal_input.add_theme_color_override("font_color", Color(0.85, 0.90, 0.95))
	_terminal_input.gui_input.connect(func(event: InputEvent):
		if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER and event.ctrl_pressed:
			_on_execute()
			_terminal_input.accept_event()
	)
	_terminal_input.text_changed.connect(_on_terminal_text_changed)
	_sql_highlighter = _build_sql_highlighter()
	_terminal_input.syntax_highlighter = _sql_highlighter
	vbox.add_child(_terminal_input)

	var run_hint := Label.new()
	run_hint.text = "Ctrl+Enter to run, or press Execute below."
	run_hint.add_theme_font_size_override("font_size", 10)
	run_hint.add_theme_color_override("font_color", Color(0.45, 0.50, 0.60))
	vbox.add_child(run_hint)

	var execute_btn := Button.new()
	execute_btn.text = "Execute"
	execute_btn.pressed.connect(_on_execute)
	vbox.add_child(execute_btn)

	_terminal_status = Label.new()
	_terminal_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_terminal_status.custom_minimum_size = Vector2(360, 0)
	_terminal_status.add_theme_font_size_override("font_size", 13)
	vbox.add_child(_terminal_status)

func _build_sql_highlighter() -> CodeHighlighter:
	var hl := CodeHighlighter.new()
	hl.number_color          = Color(0.71, 0.81, 0.66)
	hl.symbol_color          = Color(0.75, 0.75, 0.78)
	hl.function_color        = Color(0.86, 0.86, 0.67)
	hl.member_variable_color = Color(0.96, 0.75, 0.30)
	var keyword_color := Color(0.42, 0.69, 0.91)
	for kw in SQL_KEYWORDS:
		hl.add_keyword_color(kw.to_upper(), keyword_color)
		hl.add_keyword_color(kw, keyword_color)
	var string_color := Color(0.81, 0.57, 0.47)
	hl.add_color_region("'", "'", string_color, false)
	hl.add_color_region("\"", "\"", string_color, false)
	return hl

# Colors the current round's table + column names distinctly, so the
# player can visually tell "these words are this table's real fields."
func _update_sql_members(table: String, headers: Array) -> void:
	_sql_highlighter.clear_member_keyword_colors()
	var member_color := Color(0.96, 0.75, 0.30)
	_sql_highlighter.add_member_keyword_color(table, member_color)
	for h in headers:
		_sql_highlighter.add_member_keyword_color(str(h), member_color)

func _is_sql_word_char(c: String) -> bool:
	return (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or (c >= "0" and c <= "9") or c == "_"

# Wraps a plain SQL string in BBCode color tags — keywords, string literals,
# numbers, and this round's real table/column names each get their own
# color, matching the Terminal's live syntax highlighting.
func _colorize_sql(query: String, table: String, headers: Array) -> String:
	var known_members: Dictionary = {}
	known_members[table] = true
	for h in headers:
		known_members[str(h)] = true

	var result: String = ""
	var i: int = 0
	var n: int = query.length()
	while i < n:
		var c: String = query[i]
		if c == "'":
			var j: int = i + 1
			while j < n and query[j] != "'":
				j += 1
			j = min(j + 1, n)
			var lit: String = query.substr(i, j - i)
			result += "[color=%s]%s[/color]" % [BBCODE_STRING, lit]
			i = j
		elif _is_sql_word_char(c):
			var j: int = i
			while j < n and _is_sql_word_char(query[j]):
				j += 1
			var word: String = query.substr(i, j - i)
			if SQL_KEYWORDS.has(word.to_lower()):
				result += "[color=%s]%s[/color]" % [BBCODE_KEYWORD, word]
			elif known_members.has(word):
				result += "[color=%s]%s[/color]" % [BBCODE_MEMBER, word]
			elif word.is_valid_int() or word.is_valid_float():
				result += "[color=%s]%s[/color]" % [BBCODE_NUMBER, word]
			else:
				result += word
			i = j
		else:
			result += c
			i += 1
	return result

# Live auto-uppercase: whenever a word boundary (space, newline, comma,
# parenthesis, semicolon...) is typed right after a recognized SQL keyword,
# that keyword gets capitalized in place, cursor position preserved.
func _on_terminal_text_changed() -> void:
	if _auto_caps_guard:
		return

	var caret_line: int = _terminal_input.get_caret_line()
	var caret_col: int = _terminal_input.get_caret_column()

	var check_line: int = caret_line
	var check_col: int = caret_col
	if caret_col == 0:
		if caret_line == 0:
			return
		check_line = caret_line - 1
		check_col = _terminal_input.get_line(check_line).length()
	else:
		var cur_line: String = _terminal_input.get_line(caret_line)
		if _is_sql_word_char(cur_line[caret_col - 1]):
			return
		check_col = caret_col - 1

	var line: String = _terminal_input.get_line(check_line)
	var word_end: int = check_col
	var word_start: int = word_end
	while word_start > 0 and _is_sql_word_char(line[word_start - 1]):
		word_start -= 1
	if word_start >= word_end:
		return

	var word: String = line.substr(word_start, word_end - word_start)
	if SQL_KEYWORDS.has(word.to_lower()) and word != word.to_upper():
		_auto_caps_guard = true
		var new_line: String = line.substr(0, word_start) + word.to_upper() + line.substr(word_end)
		_terminal_input.set_line(check_line, new_line)
		_terminal_input.set_caret_line(caret_line)
		_terminal_input.set_caret_column(caret_col)
		_auto_caps_guard = false

# ── Lesson-gating helpers ──────────────────────────────
func _lessons_for(world: String) -> Array:
	match world:
		"hotel":   return Dashboard.HOTEL_LESSONS
		"cafe":    return Dashboard.CAFE_LESSONS
		"airport": return Dashboard.AIRPORT_LESSONS
		"library": return Dashboard.LIBRARY_LESSONS
	return []

func _furthest_completed_index(world: String) -> int:
	var lessons: Array = _lessons_for(world)
	var count: int = 0
	for lid in lessons:
		if GameManager.get_stars(world, lid) > 0:
			count += 1
		else:
			break
	return count

func _load_templates(world: String) -> Array:
	match world:
		"hotel":   return preload("res://scripts/data/HotelSimData.gd").new().TEMPLATES
		"cafe":    return preload("res://scripts/data/CafeSimData.gd").new().TEMPLATES
		"airport": return preload("res://scripts/data/AirportSimData.gd").new().TEMPLATES
		"library": return preload("res://scripts/data/LibrarySimData.gd").new().TEMPLATES
	return []

func _bg_path_for(world: String) -> String:
	match world:
		"hotel":   return "res://images/backgrounds/BG_hotel.png"
		"cafe":    return "res://images/backgrounds/BG_cafe.png"
		"airport": return "res://images/backgrounds/BG_airport.png"
		"library": return "res://images/backgrounds/BG_library.png"
	return ""

# ── Texture loading (mirrors GameScreen.gd's raw-bytes fallback) ──
func _load_texture(res_path: String) -> Texture2D:
	if _tex_cache.has(res_path):
		return _tex_cache[res_path]

	var tex: Texture2D = null
	if ResourceLoader.exists(res_path):
		tex = ResourceLoader.load(res_path) as Texture2D

	if tex == null:
		var abs_path: String = ProjectSettings.globalize_path(res_path)
		var fa := FileAccess.open(abs_path, FileAccess.READ)
		if fa:
			var data: PackedByteArray = fa.get_buffer(fa.get_length())
			fa.close()
			var img := Image.new()
			var loaded := false
			if res_path.ends_with(".jpg") or res_path.ends_with(".jpeg"):
				loaded = img.load_jpg_from_buffer(data) == OK
			else:
				loaded = img.load_png_from_buffer(data) == OK
			if loaded:
				if img.get_format() != Image.FORMAT_RGBA8:
					img.convert(Image.FORMAT_RGBA8)
				tex = ImageTexture.create_from_image(img)

	if tex == null:
		var img2 := Image.new()
		var abs_path2: String = ProjectSettings.globalize_path(res_path)
		if img2.load(abs_path2) == OK:
			if img2.get_format() != Image.FORMAT_RGBA8:
				img2.convert(Image.FORMAT_RGBA8)
			tex = ImageTexture.create_from_image(img2)

	if tex != null:
		_tex_cache[res_path] = tex
	return tex
