extends Control
# ═══════════════════════════════════════════════════════
#  GAME SCREEN  |  scripts/GameScreen.gd
# ═══════════════════════════════════════════════════════

const GM_TO_SQL: Dictionary = {
	"select":            "SELECT",
	"select_basic":      "SELECT",
	"insert_into":       "INSERT INTO",
	"select_where":      "SELECT WHERE",
	"update_set":        "UPDATE SET",
	"delete":            "DELETE",
	"order_by":          "ORDER BY",
	"group_by":          "GROUP BY",
	"select_where_null": "IS NULL / IS NOT NULL",
	"select_distinct":   "SELECT DISTINCT",
	"where_and_or":      "AND / OR",
	"where_between":     "BETWEEN",
	"where_like":        "LIKE",
	"where_in":          "IN",
	"limit":             "LIMIT",
	"aggregate":         "COUNT / SUM / AVG",
	"having":            "HAVING",
	"select_alias":      "AS (Alias)",
}

const SQL_GLOSSARY: Array = [
	["SELECT",       "Retrieves data from one or more columns in a table.",
		"SELECT column1, column2\nFROM table_name;"],
	["INSERT INTO",  "Adds a new row of data into a table.",
		"INSERT INTO table_name (col1, col2)\nVALUES ('value1', 'value2');"],
	["SELECT WHERE", "Retrieves rows filtered by a specific condition.",
		"SELECT * FROM table_name\nWHERE column = 'value';"],
	["UPDATE SET",   "Modifies values in existing rows of a table.",
		"UPDATE table_name\nSET column = 'new_value'\nWHERE condition;"],
	["DELETE",       "Removes rows from a table based on a condition.",
		"DELETE FROM table_name\nWHERE column = 'value';"],
	["ORDER BY",     "Sorts result rows in ascending or descending order.",
		"SELECT * FROM table_name\nORDER BY column ASC;"],
	["GROUP BY",           "Groups rows that share the same column value.",
		"SELECT column, COUNT(*)\nFROM table_name\nGROUP BY column;"],
	["IS NULL / IS NOT NULL", "Checks whether a column's value is missing or present.",
		"SELECT * FROM table_name\nWHERE column IS NULL;\n\nSELECT * FROM table_name\nWHERE column IS NOT NULL;"],
	["SELECT DISTINCT", "Returns only unique (non-duplicate) values in a result column.", "SELECT DISTINCT column\nFROM table_name;"],
	["AND / OR",        "AND requires ALL conditions. OR requires AT LEAST ONE condition.", "SELECT * FROM t WHERE a=1 AND b=2;\nSELECT * FROM t WHERE a=1 OR b=2;"],
	["BETWEEN",         "Filters rows where a value falls within an inclusive range.", "SELECT * FROM t\nWHERE price BETWEEN 10 AND 50;"],
	["LIKE",            "Pattern matching. % = any characters, _ = one character.", "SELECT * FROM t\nWHERE name LIKE 'S%';"],
	["IN",              "Filters rows where a column value matches any item in a list.", "SELECT * FROM t\nWHERE city IN ('Manila','Cebu');"],
	["LIMIT",           "Restricts how many rows are returned by a query.", "SELECT * FROM t\nLIMIT 10;"],
	["COUNT / SUM / AVG","Aggregate functions: COUNT counts rows, SUM adds values, AVG averages them.", "SELECT COUNT(id) FROM t;\nSELECT SUM(price) FROM t;\nSELECT AVG(price) FROM t;"],
	["HAVING",          "Filters groups after GROUP BY like WHERE but for grouped data.", "SELECT col, COUNT(*) FROM t\nGROUP BY col\nHAVING COUNT(*) > 1;"],
	["AS (Alias)",      "Renames a column or expression in the result. Does not change the table.", "SELECT price * 1.12 AS price_with_tax\nFROM orders;"],
]

const GM_SCENES: Dictionary = {
	"select":       "res://gamemode/scene/GM_Select.tscn",
	"select_basic": "res://gamemode/scene/GM_SelectBasic.tscn",
	"insert_into":  "res://gamemode/scene/GM_InsertInto.tscn",
	"select_where": "res://gamemode/scene/GM_SelectWhere.tscn",
	"update_set":   "res://gamemode/scene/GM_UpdateSet.tscn",
	"delete":       "res://gamemode/scene/GM_Delete.tscn",
	"order_by":          "res://gamemode/scene/GM_OrderBy.tscn",
	"group_by":          "res://gamemode/scene/GM_GroupBy.tscn",
	"select_where_null": "res://gamemode/scene/GM_SelectWhereNull.tscn",
	"select_distinct":  "res://gamemode/scene/GM_SelectDistinct.tscn",
	"where_and_or":     "res://gamemode/scene/GM_WhereAndOr.tscn",
	"where_between":    "res://gamemode/scene/GM_WhereBetween.tscn",
	"where_like":       "res://gamemode/scene/GM_WhereLike.tscn",
	"where_in":         "res://gamemode/scene/GM_WhereIn.tscn",
	"limit":            "res://gamemode/scene/GM_Limit.tscn",
	"aggregate":        "res://gamemode/scene/GM_Aggregate.tscn",
	"having":           "res://gamemode/scene/GM_Having.tscn",
	"select_alias":     "res://gamemode/scene/GM_SelectAlias.tscn",
}

const BG_HOTEL   := "res://images/backgrounds/BG_hotel.png"
const BG_CAFE    := "res://images/backgrounds/BG_cafe.png"
const BG_AIRPORT := "res://images/backgrounds/BG_airport.png"
const BG_LIBRARY := "res://images/backgrounds/BG_library.png"

const CHAR_BASE := "res://images/characters/NPC_adults/"
const CHAR_ROOT := "res://images/characters/"

# ── NPC bob ──────────────────────────────────────────
const BOB_AMP:    float = 7.0    # pixels subtle speech movement
const BOB_SPEED:  float = 10.0   # rad/s  ≈ 1.6 Hz, quick talking rhythm
const BOB_SETTLE: float = 10.0   # lerp speed back to idle (rad/s feel)

var _bob_time:   float = 0.0
var _is_bobbing: bool  = false
var _npc_base_top:    float = 40.0
var _npc_base_bottom: float = 800.0  # matches tscn offset_bottom

# ── Typewriter ────────────────────────────────────────
const TYPEWRITER_CPS: float = 38.0  # characters per second

var _full_text:  String = ""
var _type_index: int    = 0
var _type_accum: float  = 0.0
var _typing:     bool   = false

# ── General ───────────────────────────────────────────
var _tex_cache:       Dictionary = {}
var _bg_textures:     Dictionary = {}
var _story:           Array      = []
var _step:            int        = 0
var _current_gm:      Node       = null
var _dlg_line:        ColorRect  = null
var _failed_step:     Dictionary = {}
var _glossary_overlay: Control   = null

func _ready() -> void:
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons/NextButton.pressed.connect(_on_next)
	$DialogueArea/DialogueButtons/BackButton.pressed.connect(_on_back)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.pressed.connect(_on_back)

	# Top bar dark strip
	var tb_bg := ColorRect.new()
	tb_bg.color         = Color(0.04, 0.05, 0.08, 0.94)
	tb_bg.anchor_right  = 1.0
	tb_bg.offset_bottom = 42.0
	tb_bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_bg.z_index       = 2
	add_child(tb_bg)

	# Top bar amber accent line
	var tb_line := ColorRect.new()
	tb_line.color         = Color("#F59E0B")
	tb_line.anchor_right  = 1.0
	tb_line.offset_top    = 41.0
	tb_line.offset_bottom = 43.0
	tb_line.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_line.z_index       = 2
	add_child(tb_line)

	# Amber accent line at dialogue box top edge
	_dlg_line = ColorRect.new()
	_dlg_line.color         = Color("#F59E0B")
	_dlg_line.anchor_top    = 1.0
	_dlg_line.anchor_right  = 1.0
	_dlg_line.anchor_bottom = 1.0
	_dlg_line.offset_top    = -222.0
	_dlg_line.offset_bottom = -218.0
	_dlg_line.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	_dlg_line.z_index       = 3
	add_child(_dlg_line)

	$TopBar.z_index    = 3
	$ProgressBar.z_index = 3

	$TopBar/LessonLabel.add_theme_font_size_override("font_size", 14)
	$TopBar/LessonLabel.add_theme_color_override("font_color", Color(0.60, 0.65, 0.76))

	_style_btn($TopBar/BackToHubButton, "secondary", 13)
	$TopBar/BackToHubButton.text = "← Hub"

	_style_btn($DialogueArea/DialogueButtons/BackButton, "ghost", 15)
	_style_btn($DialogueArea/DialogueButtons/NextButton, "primary", 15)
	$DialogueArea/DialogueButtons/NextButton.text = "Next  →"

	_style_btn($SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton, "secondary", 14)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.text = "← Dialogue"

	# Character name | amber, readable
	$DialogueArea/CharacterName.add_theme_font_size_override("font_size", 14)
	$DialogueArea/CharacterName.add_theme_color_override("font_color", Color("#F59E0B"))
	$DialogueArea/CharacterName.add_theme_constant_override("outline_size", 1)
	$DialogueArea/CharacterName.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))

	# Dialogue text | larger for legibility
	$DialogueArea/DialogueText.add_theme_font_size_override("font_size", 18)
	$DialogueArea/DialogueText.add_theme_color_override("font_color", Color(0.93, 0.94, 0.97))

	# Let clicks pass through the overlay containers to the TopBar.
	# Only the PanelContainer (the actual panel) and its children keep STOP.
	$SQLOverlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$SQLOverlay/CenterContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Move TopBar to last child so it receives input before SQLOverlay.
	# Godot 4 processes UI input from the last tree child first.
	var tb = $TopBar
	remove_child(tb)
	add_child(tb)

	_style_sql_panel()
	_build_glossary()
	_load_all_textures()
	_style_progress_bar()

	# Read the NPC's actual base offsets so bob is always relative to them
	_npc_base_top    = $NPCSprite.offset_top
	_npc_base_bottom = $NPCSprite.offset_bottom

func _style_sql_panel() -> void:
	var ps := StyleBoxFlat.new()
	ps.bg_color     = Color(0.08, 0.10, 0.15, 0.98)
	ps.border_color = Color(0.24, 0.30, 0.42)
	ps.set_border_width_all(2)
	ps.set_corner_radius_all(12)
	$SQLOverlay/CenterContainer/PanelContainer.add_theme_stylebox_override("panel", ps)

# ── Per-frame: bob + typewriter ───────────────────────
func _process(delta: float) -> void:
	# NPC bob | only while typewriter is actively revealing text
	if _is_bobbing and $NPCSprite.visible:
		if _typing:
			# Talking: fast up-down speech movement
			_bob_time += delta
			var bob: float = sin(_bob_time * BOB_SPEED) * BOB_AMP
			$NPCSprite.offset_top    = _npc_base_top    + bob
			$NPCSprite.offset_bottom = _npc_base_bottom + bob
		else:
			# Idle: smoothly settle back to base position
			var cur_top: float = $NPCSprite.offset_top
			if abs(cur_top - _npc_base_top) > 0.2:
				var t: float = BOB_SETTLE * delta
				$NPCSprite.offset_top    = lerp($NPCSprite.offset_top,    _npc_base_top,    t)
				$NPCSprite.offset_bottom = lerp($NPCSprite.offset_bottom, _npc_base_bottom, t)
			else:
				$NPCSprite.offset_top    = _npc_base_top
				$NPCSprite.offset_bottom = _npc_base_bottom
				_bob_time = 0.0   # reset so next speech always starts from centre

	# Typewriter character reveal
	if _typing:
		_type_accum += delta
		var n: int = int(_type_accum * TYPEWRITER_CPS)
		if n > 0:
			_type_index = mini(_type_index + n, _full_text.length())
			_type_accum -= float(n) / TYPEWRITER_CPS
			$DialogueArea/DialogueText.text = _full_text.substr(0, _type_index)
			if _type_index >= _full_text.length():
				_typing = false

# ── Typewriter helpers ────────────────────────────────
func _start_typewriter(text: String) -> void:
	_full_text   = text
	_type_index  = 0
	_type_accum  = 0.0
	_typing      = true
	_bob_time    = 0.0   # always start bob from neutral so no snap
	$DialogueArea/DialogueText.text = ""

func _finish_typewriter() -> void:
	_typing      = false
	_type_index  = _full_text.length()
	$DialogueArea/DialogueText.text = _full_text

# ── Bob helpers ───────────────────────────────────────
func _start_bob() -> void:
	_is_bobbing = true

func _stop_bob() -> void:
	_is_bobbing  = false
	$NPCSprite.offset_top    = _npc_base_top
	$NPCSprite.offset_bottom = _npc_base_bottom

# ── Keyboard shortcuts ────────────────────────────────
func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not event is InputEventKey or not event.pressed:
		return

	var sql_open: bool = $SQLOverlay.visible

	if sql_open:
		match event.keycode:
			KEY_LEFT:
				_on_back()
			KEY_ENTER, KEY_KP_ENTER:
				if _current_gm and is_instance_valid(_current_gm) and _current_gm.has_method("_on_execute"):
					_current_gm._on_execute()
			KEY_H:
				if _current_gm and is_instance_valid(_current_gm) and _current_gm.has_method("_on_hint"):
					_current_gm._on_hint()
			KEY_RIGHT:
				if _current_gm and is_instance_valid(_current_gm):
					var cb: Button = _current_gm.get_node_or_null("ContinueButton")
					if cb and cb.visible:
						_current_gm._on_continue()
	else:
		match event.keycode:
			KEY_RIGHT:
				if $DialogueArea/DialogueButtons/NextButton.visible:
					_on_next()
			KEY_LEFT:
				if $DialogueArea/DialogueButtons/BackButton.visible:
					_on_back()
			KEY_ESCAPE:
				_on_back_to_hub()

# ── Texture loading ───────────────────────────────────
func _load_all_textures() -> void:
	for pair in [["hotel", BG_HOTEL], ["cafe", BG_CAFE],
				 ["airport", BG_AIRPORT], ["library", BG_LIBRARY]]:
		var tex := _load_texture(pair[1])
		if tex:
			_bg_textures[pair[0]] = tex

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

func _set_background(world: String) -> void:
	if _bg_textures.has(world):
		$SceneBG.texture = _bg_textures[world]
	else:
		$SceneBG.texture = null

func _set_expression(char_key: String, npc_override: String = "") -> void:
	var path: String
	if npc_override != "":
		var parts := npc_override.split("/")
		if parts.size() == 3:
			path = CHAR_ROOT + parts[0] + "/" + parts[1] + "/" + parts[2] + ".png"
		elif parts.size() == 2:
			path = CHAR_BASE + parts[0] + "/" + parts[1] + ".png"
		else:
			path = CHAR_BASE + "adult_1/idle.png"
	else:
		match GameManager.world:
			"hotel":   path = CHAR_BASE + "adult_1/idle.png"
			"cafe":    path = CHAR_BASE + "adult_3/idle.png"
			"airport": path = CHAR_BASE + "adult_2/idle.png"
			"library": path = CHAR_BASE + "adult_7/idle.png"
			_:         path = CHAR_BASE + "adult_1/idle.png"

	var tex := _load_texture(path)
	if tex:
		$NPCSprite.texture = tex
		$NPCSprite.visible = true
	else:
		$NPCSprite.visible = false

func load_lesson(id) -> void:
	GameManager.start_lesson()
	_story = _get_story(id)
	_step  = 0
	$TopBar/LessonLabel.text = "  Lesson  " + str(id)
	_set_background(GameManager.world)
	_set_expression("scene")
	_close_overlay()
	_run_step()

# ── Story engine ──────────────────────────────────────
func _run_step() -> void:
	if _step >= _story.size():
		_go_complete()
		return

	_update_progress()
	var s: Dictionary = _story[_step]
	$DialogueArea/DialogueButtons/BackButton.visible = _step > 0

	match s["type"]:
		"dialogue":
			var char_key: String = s.get("char", "scene")
			var npc_key:  String = s.get("npc", "")
			_set_expression(char_key, npc_key)
			$DialogueArea/CharacterName.text                  = s.get("name", "")
			$DialogueArea/DialogueButtons/NextButton.visible  = true
			_start_typewriter(s.get("text", ""))
			# Bob only when a real NPC character is speaking.
			# char "scene" = narration, char "you" = player | keep sprite still.
			if char_key != "scene" and char_key != "you":
				_start_bob()
			else:
				_stop_bob()
			GameManager.speak(s.get("text", ""), char_key)

		"sql_choice":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, "select")

		"sql_fill":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, s.get("gamemode", ""))

		"end":
			_go_complete()

		"retry":
			var main := get_tree().root.get_node("Main")
			if main.has_method("show_failed"):
				main.show_failed()
			else:
				main.show_screen("failed")

# ── SQL Terminal ──────────────────────────────────────
func _show_challenge(step: Dictionary, gm_key: String) -> void:
	# Generic gamemodes (e.g. sql_blank) carry their own recap label per step
	if step.has("recap"):
		GameManager.record_sql(step["recap"])
	elif GM_TO_SQL.has(gm_key):
		GameManager.record_sql(GM_TO_SQL[gm_key])
	GameManager.stop_speaking()
	_stop_bob()
	_finish_typewriter()

	var path: String = GM_SCENES.get(gm_key, "")
	if path.is_empty():
		push_error("GameScreen: unknown gamemode key: " + gm_key)
		return
	_clear_gm()
	var packed: PackedScene = load(path)
	_current_gm = packed.instantiate()
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/ScrollContainer/GMContainer.add_child(_current_gm)
	_current_gm.on_correct.connect(_on_gm_correct)
	if _current_gm.has_signal("on_wrong"):
		_current_gm.on_wrong.connect(_on_gm_wrong)
	_current_gm.setup(step)

	$SceneBG.visible      = false
	$NPCSprite.visible    = false
	$DialogueBG.visible   = false
	$DialogueArea.visible = false
	_dlg_line.visible     = false
	$SQLOverlay.visible   = true

func _on_gm_wrong() -> void:
	GameManager.stop_speaking()
	if _current_gm and is_instance_valid(_current_gm):
		if _current_gm.on_wrong.is_connected(_on_gm_wrong):
			_current_gm.on_wrong.disconnect(_on_gm_wrong)

	var current_step: Dictionary = _story[_step]
	var fail_steps: Array = current_step.get("fail", [])
	if fail_steps.is_empty():
		return

	# Only count as a wrong attempt when a fail path actually branches
	GameManager.record_wrong()

	_failed_step = current_step

	var fail_story: Array = fail_steps.duplicate(true)
	fail_story.append({ "type": "retry" })

	var saved_story: Array = _story
	var saved_step:  int   = _step
	_story = fail_story
	_step  = 0
	_close_overlay()

	set_meta("_saved_story", saved_story)
	set_meta("_saved_step",  saved_step)
	_run_step()

func _on_gm_correct() -> void:
	GameManager.stop_speaking()
	_close_overlay()
	_step += 1
	_run_step()

# ── Navigation ────────────────────────────────────────
func _on_next() -> void:
	GameManager.stop_speaking()
	# First press while typing → complete text; second press → advance
	if _typing:
		_finish_typewriter()
		return
	_step += 1
	_run_step()

func _on_back() -> void:
	GameManager.stop_speaking()
	_finish_typewriter()
	_close_overlay()
	_step = max(0, _step - 1)
	_run_step()

func _on_back_to_hub() -> void:
	GameManager.stop_speaking()
	_finish_typewriter()
	_stop_bob()
	_close_overlay()
	get_tree().root.get_node("Main").show_screen("dashboard")

func _close_overlay() -> void:
	$SceneBG.visible      = true
	$NPCSprite.visible    = true
	$DialogueBG.visible   = true
	$DialogueArea.visible = true
	_dlg_line.visible     = true
	$SQLOverlay.visible   = false
	_clear_gm()

func _clear_gm() -> void:
	if _current_gm != null and is_instance_valid(_current_gm):
		_current_gm.queue_free()
		_current_gm = null

func _go_complete() -> void:
	GameManager.finish_lesson()
	get_tree().root.get_node("Main").show_screen("complete")

# ── SQL Glossary overlay ──────────────────────────────
func _build_glossary() -> void:
	# Glossary toggle button in TopBar
	var gloss_btn := Button.new()
	gloss_btn.text = "📖  Glossary"
	gloss_btn.pressed.connect(_toggle_glossary)
	_style_btn(gloss_btn, "secondary", 13)
	$TopBar.add_child(gloss_btn)

	# Full-screen overlay | added last so it's on top of all scene children
	_glossary_overlay = Control.new()
	_glossary_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glossary_overlay.visible = false
	_glossary_overlay.z_index = 100
	_glossary_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_glossary_overlay)

	# Dark backdrop
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.80)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_glossary_overlay.add_child(backdrop)

	# Centered panel
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_glossary_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 560)
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.09, 0.11, 0.16, 0.98)
	ps.border_color = Color("#F59E0B")
	ps.set_border_width_all(2)
	ps.set_corner_radius_all(12)
	ps.content_margin_left   = 24
	ps.content_margin_right  = 24
	ps.content_margin_top    = 20
	ps.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", ps)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(vbox)

	# Header row
	var header_row := HBoxContainer.new()
	vbox.add_child(header_row)
	var header_lbl := Label.new()
	header_lbl.text = "SQL Glossary"
	header_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_lbl.add_theme_font_size_override("font_size", 18)
	header_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
	header_row.add_child(header_lbl)
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.pressed.connect(_toggle_glossary)
	_style_btn(close_btn, "ghost", 16)
	header_row.add_child(close_btn)

	# Divider
	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(0.25, 0.30, 0.42)
	vbox.add_child(sep)

	# Filter search bar
	var filter_box := LineEdit.new()
	filter_box.placeholder_text = "🔍  Filter terms..."
	filter_box.clear_button_enabled = true
	filter_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var fns := StyleBoxFlat.new()
	fns.bg_color = Color(0.04, 0.07, 0.13, 1.0)
	fns.border_color = Color(1.0, 0.78, 0.0)
	fns.border_width_bottom = 2
	fns.content_margin_left = 8; fns.content_margin_right  = 8
	fns.content_margin_top  = 5; fns.content_margin_bottom = 5
	filter_box.add_theme_stylebox_override("normal", fns)
	var ffs := fns.duplicate() as StyleBoxFlat; ffs.border_width_bottom = 3
	filter_box.add_theme_stylebox_override("focus", ffs)
	filter_box.add_theme_color_override("font_color", Color(1.0, 0.78, 0.0))
	filter_box.add_theme_color_override("font_placeholder_color", Color(1.0, 0.78, 0.0, 0.3))
	filter_box.add_theme_font_size_override("font_size", 13)
	vbox.add_child(filter_box)

	var sep2 := ColorRect.new()
	sep2.custom_minimum_size = Vector2(0, 1)
	sep2.color = Color(0.25, 0.30, 0.42)
	vbox.add_child(sep2)

	# Scrollable entries area
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	var entry_list := VBoxContainer.new()
	entry_list.add_theme_constant_override("separation", 6)
	entry_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(entry_list)

	# entries_meta filled below | lambda captures array reference so filtering works
	var entries_meta: Array = []
	filter_box.text_changed.connect(func(query: String):
		var q := query.strip_edges().to_lower()
		for pair in entries_meta:
			pair[0].visible = q.is_empty() or pair[1].contains(q)
	)

	# Entries
	for entry in SQL_GLOSSARY:
		# Wrapper column so example panel sits below the row
		var entry_col := VBoxContainer.new()
		entry_col.add_theme_constant_override("separation", 4)
		entry_list.add_child(entry_col)
		entries_meta.append([entry_col, (entry[0] + " " + entry[1]).to_lower()])

		# Main info row
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		entry_col.add_child(row)

		var cmd_lbl := Label.new()
		cmd_lbl.text = entry[0]
		cmd_lbl.custom_minimum_size = Vector2(120, 0)
		cmd_lbl.add_theme_font_size_override("font_size", 14)
		cmd_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
		row.add_child(cmd_lbl)

		var def_lbl := Label.new()
		def_lbl.text = entry[1]
		def_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		def_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		def_lbl.add_theme_font_size_override("font_size", 13)
		def_lbl.add_theme_color_override("font_color", Color(0.80, 0.83, 0.90))
		row.add_child(def_lbl)

		# Example toggle button
		var ex_btn := Button.new()
		ex_btn.text = "{ }"
		ex_btn.tooltip_text = "Show example"
		_style_btn(ex_btn, "ghost", 12)
		row.add_child(ex_btn)

		# Collapsible syntax panel (hidden by default)
		var snippet_panel := PanelContainer.new()
		snippet_panel.visible = false
		var sp := StyleBoxFlat.new()
		sp.bg_color = Color(0.04, 0.05, 0.08, 1.0)
		sp.border_color = Color("#F59E0B")
		sp.border_width_left = 3
		sp.content_margin_left  = 12
		sp.content_margin_right = 12
		sp.content_margin_top   = 8
		sp.content_margin_bottom = 8
		snippet_panel.add_theme_stylebox_override("panel", sp)
		entry_col.add_child(snippet_panel)

		var snippet_lbl := Label.new()
		snippet_lbl.text = entry[2]
		snippet_lbl.add_theme_font_size_override("font_size", 13)
		snippet_lbl.add_theme_color_override("font_color", Color("#4ADE80"))
		snippet_panel.add_child(snippet_lbl)

		# Toggle visibility on button press
		ex_btn.pressed.connect(func():
			snippet_panel.visible = not snippet_panel.visible
			ex_btn.text = "▲" if snippet_panel.visible else "{ }"
		)

func _toggle_glossary() -> void:
	if _glossary_overlay:
		_glossary_overlay.visible = not _glossary_overlay.visible

func _get_story(id) -> Array:
	var script: Node
	match GameManager.world:
		"hotel":   script = preload("res://scripts/data/HotelData.gd").new()
		"cafe":    script = preload("res://scripts/data/CafeData.gd").new()
		"airport": script = preload("res://scripts/data/AirportData.gd").new()
		"library": script = preload("res://scripts/data/LibraryData.gd").new()
		_:         script = preload("res://scripts/data/HotelData.gd").new()
	var result: Array = []
	if script.LESSONS.has(id):
		result = script.LESSONS[id].duplicate(true)
	else:
		push_error("GameScreen: lesson id not found: " + str(id))
	script.free()
	return result

# ── Progress bar ──────────────────────────────────────
func _update_progress() -> void:
	var total: int = 0
	for s in _story:
		if s.get("type", "") != "end":
			total += 1
	if total == 0:
		return
	var done: int = 0
	for i in range(mini(_step + 1, _story.size())):
		if _story[i].get("type", "") != "end":
			done += 1
	$ProgressBar.value = float(done) / float(total)

func _style_progress_bar() -> void:
	var pb: ProgressBar = $ProgressBar
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.10, 0.11, 0.16, 0.90)
	bg.border_color = Color(0.22, 0.27, 0.38)
	bg.set_border_width_all(1)
	bg.set_corner_radius_all(10)
	pb.add_theme_stylebox_override("background", bg)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("#F59E0B")
	fill.set_corner_radius_all(10)
	pb.add_theme_stylebox_override("fill", fill)
	pb.value = 0.0

# ── 3-variant button style ────────────────────────────
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 16) -> void:
	btn.add_theme_font_size_override("font_size", font_size)
	var s := StyleBoxFlat.new()
	s.set_corner_radius_all(7)

	match variant:
		"primary":
			btn.add_theme_color_override("font_color", Color(0.10, 0.06, 0.00))
			s.bg_color     = Color("#F59E0B")
			s.border_color = Color("#D97706")
			s.set_border_width_all(0)
			s.content_margin_left   = 22; s.content_margin_right  = 22
			s.content_margin_top    = 8;  s.content_margin_bottom = 8
		"secondary":
			btn.add_theme_color_override("font_color", Color(0.85, 0.88, 0.94))
			s.bg_color     = Color(0.13, 0.15, 0.21, 0.95)
			s.border_color = Color(0.28, 0.33, 0.44)
			s.set_border_width_all(2)
			s.content_margin_left   = 16; s.content_margin_right  = 16
			s.content_margin_top    = 6;  s.content_margin_bottom = 6
		"ghost":
			btn.add_theme_color_override("font_color", Color(0.55, 0.60, 0.70))
			s.bg_color     = Color(0, 0, 0, 0)
			s.border_color = Color(0.30, 0.35, 0.46)
			s.set_border_width_all(2)
			s.content_margin_left   = 16; s.content_margin_right  = 16
			s.content_margin_top    = 6;  s.content_margin_bottom = 6

	var h := s.duplicate() as StyleBoxFlat
	var p := s.duplicate() as StyleBoxFlat

	match variant:
		"primary":
			h.bg_color = Color("#FBBF24")
			p.bg_color = Color("#D97706")
		"secondary":
			h.bg_color     = Color(0.19, 0.22, 0.30, 0.95)
			h.border_color = Color("#F59E0B")
			p.bg_color     = Color(0.09, 0.11, 0.16, 0.95)
		"ghost":
			h.bg_color     = Color(0.12, 0.15, 0.21, 0.50)
			h.border_color = Color(0.50, 0.56, 0.68)
			p.bg_color     = Color(0.08, 0.10, 0.14, 0.50)

	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)
