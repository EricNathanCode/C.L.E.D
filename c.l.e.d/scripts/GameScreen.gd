extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
# ═══════════════════════════════════════════════════════
#  GAME SCREEN  |  scripts/GameScreen.gd
# ═══════════════════════════════════════════════════════

const GM_TO_SQL: Dictionary = {
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

const GM_SCENES: Dictionary = {
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
	"sql_blank":        "res://gamemode/scene/GM_SqlBlank.tscn",
}

const ChallengeSplit = preload("res://scripts/ChallengeSplit.gd")

const BG_HOTEL   :="res://images/backgrounds/BG_hotel.png"
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
var _saved_story:     Array      = []   # story to resume once the "fail" dialogue's retry step fires
var _saved_step:      int        = 0

func _ready() -> void:
	$SceneBG.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons/NextButton.pressed.connect(_on_next)
	$DialogueArea/DialogueButtons/BackButton.pressed.connect(_on_back)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.pressed.connect(_on_back)

	# Shown only at the "did you want to retry?" choice after a wrong answer.
	var retry_btn := Button.new()
	retry_btn.name = "RetryChallengeButton"
	retry_btn.text = "↺  Retry Challenge"
	retry_btn.visible = false
	retry_btn.pressed.connect(_on_retry_challenge)
	$DialogueArea/DialogueButtons.add_child(retry_btn)

	var retry_dash_btn := Button.new()
	retry_dash_btn.name = "RetryDashboardButton"
	retry_dash_btn.text = "← Back to Dashboard"
	retry_dash_btn.visible = false
	retry_dash_btn.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons.add_child(retry_dash_btn)

	# Top bar: solid ink strip
	var tb_bg := ColorRect.new()
	tb_bg.color         = Comic.INK
	tb_bg.anchor_right  = 1.0
	tb_bg.offset_bottom = 60.0
	tb_bg.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_bg.z_index       = 2
	add_child(tb_bg)

	# Top bar yellow edge
	var tb_line := ColorRect.new()
	tb_line.color         = Comic.YELLOW
	tb_line.anchor_right  = 1.0
	tb_line.offset_top    = 60.0
	tb_line.offset_bottom = 65.0
	tb_line.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	tb_line.z_index       = 2
	add_child(tb_line)

	# Ink rule along the top edge of the dialogue area
	_dlg_line = ColorRect.new()
	_dlg_line.color         = Comic.INK
	_dlg_line.anchor_top    = 1.0
	_dlg_line.anchor_right  = 1.0
	_dlg_line.anchor_bottom = 1.0
	_dlg_line.offset_top    = -224.0
	_dlg_line.offset_bottom = -218.0
	_dlg_line.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	_dlg_line.z_index       = 3
	add_child(_dlg_line)

	$TopBar.z_index    = 3
	$ProgressBar.z_index = 3

	# Room in the bar for the buttons' hard shadows
	$TopBar.offset_top    = 7.0
	$TopBar.offset_bottom = 55.0
	$TopBar.offset_right  = -14.0
	$TopBar.offset_left   = 14.0
	Comic.heading($TopBar/LessonLabel, 28, Comic.YELLOW)

	_style_btn($TopBar/BackToHubButton, "secondary", 20)
	$TopBar/BackToHubButton.text = "← Hub"

	# A paper-wash instead of a dark tint, so the ink line art stays crisp
	$BGTint.color = Color(1.0, 0.96, 0.84, 0.22)

	# Comic speech box: halftone gutter with a cream, ink-outlined panel on top
	Comic.apply_halftone($DialogueBG)
	var speech := Panel.new()
	speech.set_anchors_preset(Control.PRESET_FULL_RECT)
	speech.offset_left   = 12.0
	speech.offset_right  = -12.0
	speech.offset_top    = 16.0
	speech.offset_bottom = -12.0
	speech.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	speech.add_theme_stylebox_override("panel", Comic.box(Comic.PAPER_HI, Comic.INK, 5, 18, 7, 0, 0))
	$DialogueBG.add_child(speech)
	$DialogueArea.offset_left   = 44.0
	$DialogueArea.offset_right  = -44.0
	$DialogueArea.offset_top    = -184.0
	$DialogueArea.offset_bottom = -26.0

	_style_btn($DialogueArea/DialogueButtons/BackButton, "secondary", 22)
	_style_btn($DialogueArea/DialogueButtons/NextButton, "primary", 30)
	$DialogueArea/DialogueButtons/NextButton.text = "Next  →"

	_style_btn($DialogueArea/DialogueButtons/RetryChallengeButton, "primary", 26)
	_style_btn($DialogueArea/DialogueButtons/RetryDashboardButton, "secondary", 22)

	_style_btn($SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton, "secondary", 18)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.text = "← Dialogue"

	# Character name | bold comic lettering in red
	Comic.heading($DialogueArea/CharacterName, 30, Comic.RED)

	# Dialogue text | big and readable
	Comic.body($DialogueArea/DialogueText, 23, Comic.INK)

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
	_load_all_textures()
	_style_progress_bar()

	_apply_v2()

	# Read the NPC's actual base offsets so bob is always relative to them
	_npc_base_top    = $NPCSprite.offset_top
	_npc_base_bottom = $NPCSprite.offset_bottom

func _style_sql_panel() -> void:
	# The challenge windows float over a halftone comic page
	Comic.apply_halftone($SQLOverlay/SQLBackground)
	Comic.apply_panel($SQLOverlay/CenterContainer/PanelContainer, Comic.PAPER, 12, 6, 14, 12, 4)

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

	# Each shortcut plays the same click as the button it stands in for.
	if sql_open:
		match event.keycode:
			KEY_LEFT:
				GameManager.play_click()
				_on_back()
			KEY_ENTER, KEY_KP_ENTER:
				if _current_gm and is_instance_valid(_current_gm) and _current_gm.has_method("_on_execute"):
					GameManager.play_click()
					_current_gm._on_execute()
			KEY_H:
				if _current_gm and is_instance_valid(_current_gm) and _current_gm.has_method("_on_hint"):
					GameManager.play_click()
					_current_gm._on_hint()
			KEY_RIGHT:
				if _current_gm and is_instance_valid(_current_gm):
					var cb: Button = _current_gm.get_node_or_null("%ContinueButton")
					if cb and cb.visible:
						GameManager.play_click()
						_current_gm._on_continue()
	else:
		match event.keycode:
			KEY_RIGHT:
				if $DialogueArea/DialogueButtons/NextButton.visible:
					GameManager.play_click()
					_on_next()
			KEY_LEFT:
				if $DialogueArea/DialogueButtons/BackButton.visible:
					GameManager.play_click()
					_on_back()
			KEY_ESCAPE:
				GameManager.play_click()
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
	$DialogueArea/DialogueButtons/RetryChallengeButton.visible = false
	$DialogueArea/DialogueButtons/RetryDashboardButton.visible = false

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

		"sql_fill":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, s.get("gamemode", ""))

		"end":
			_go_complete()

		"retry":
			# Let the player choose instead of silently dropping them back
			# into the challenge or forcing them out of the lesson.
			GameManager.stop_speaking()
			_finish_typewriter()
			$DialogueArea/CharacterName.text = ""
			$DialogueArea/DialogueText.text  = "Ready to try that one again?"
			$DialogueArea/DialogueButtons/NextButton.visible          = false
			$DialogueArea/DialogueButtons/BackButton.visible          = false
			$DialogueArea/DialogueButtons/RetryChallengeButton.visible = true
			$DialogueArea/DialogueButtons/RetryDashboardButton.visible = true
	_apply_speech_style()

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

	# The table and the terminal show as two separate windows, like Simulation Mode
	$SQLOverlay/CenterContainer.visible = false
	$SQLOverlay.add_child(_current_gm)
	_current_gm.on_correct.connect(_on_gm_correct)
	if _current_gm.has_signal("on_wrong"):
		_current_gm.on_wrong.connect(_on_gm_wrong)
	_current_gm.setup(step)
	var back_btn := Button.new()
	back_btn.text = "← Dialogue"
	back_btn.pressed.connect(_on_back)
	_style_btn(back_btn, "secondary", 14)
	ChallengeSplit.apply(_current_gm, back_btn)

	# Chime once when the answer is right: the Continue button only appears then
	var cont: Button = _current_gm.get_node_or_null("%ContinueButton")
	if cont != null:
		var chimed: Array = [false]
		cont.visibility_changed.connect(func():
			if cont.visible and cont.is_visible_in_tree() and not chimed[0]:
				chimed[0] = true
				GameManager.play_correct()
		)

	$SceneBG.visible      = false
	$NPCSprite.visible    = false
	$DialogueBG.visible   = false
	$DialogueArea.visible = false
	_dlg_line.visible     = false
	$SQLOverlay.visible   = true

func _on_gm_wrong() -> void:
	GameManager.play_wrong()
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

	var fail_story: Array = fail_steps.duplicate(true)
	fail_story.append({ "type": "retry" })

	_saved_story = _story
	_saved_step  = _step
	_story = fail_story
	_step  = 0
	_close_overlay()
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

# Resume the real lesson at the exact challenge that was missed, so the
# player retries it fresh instead of the lesson silently restarting or ending.
func _on_retry_challenge() -> void:
	GameManager.stop_speaking()
	_story = _saved_story
	_step  = _saved_step
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
	pb.offset_top = 15.0
	pb.offset_bottom = 43.0
	pb.add_theme_stylebox_override("background", Comic.box(Comic.PAPER_HI, Comic.PAPER_HI, 3, 12, 0, 0, 0))
	pb.add_theme_stylebox_override("fill", Comic.box(Comic.YELLOW, Comic.PAPER_HI, 3, 12, 0, 0, 0))
	pb.value = 0.0

# ── Button styles (comic look, from ComicStyle) ──────
# primary | yellow   secondary | cream   ghost | text only
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 16) -> void:
	var pad_h: int = 26 if variant == "primary" else 18
	Comic.apply_button(btn, variant, font_size, true, pad_h, 8)

# ═══════════════════════════════════════════════════════
#  COMIC V2 LOOK (decoration only)
#  The scene sits in one big comic panel; the NPC stands on the right and
#  talks in a speech bubble whose tail points at their mouth. Narration uses
#  a yellow caption box, the player's own lines get a bubble pointing off-panel.
#  Everything is laid out from the screen size, so wider windows still fit.
# ═══════════════════════════════════════════════════════
const V2_NPC_W: float   = 560.0
const V2_NPC_TOP: float = 104.0
const V2_NPC_H: float   = 1100.0
const V2_BUBBLE_X: float = 60.0
const V2_BUBBLE_W: float = 720.0

var _v2_bubble = null
var _v2_frame = null
var _v2_dots: ColorRect = null
var _v2_mode: String = "scene"
var _v2_h: float = 150.0

func _apply_v2() -> void:
	# NPC stands on the right side of the panel (x is set in _v2_layout)
	var npc: TextureRect = $NPCSprite
	npc.anchor_left = 0.0
	npc.anchor_right = 0.0
	npc.anchor_top = 0.0
	npc.anchor_bottom = 0.0
	npc.offset_top = V2_NPC_TOP
	npc.offset_bottom = V2_NPC_TOP + V2_NPC_H

	# DialogueBG becomes a transparent full-screen layer holding the frame + bubble
	var dbg: ColorRect = $DialogueBG
	for c in dbg.get_children():
		c.queue_free()
	dbg.material = null
	dbg.color = Color(0, 0, 0, 0)
	dbg.anchor_top = 0.0
	dbg.offset_top = 0.0
	dbg.offset_bottom = 0.0
	_dlg_line.color = Color(0, 0, 0, 0)

	_v2_dots = Fx.dots_rect(Color(1.0, 0.76, 0.10, 0.35), Vector2(0.0, 0.5), 0.35, 12.0)
	_v2_dots.set_anchors_preset(Control.PRESET_TOP_LEFT)
	dbg.add_child(_v2_dots)

	_v2_frame = Fx.Frame.new()
	_v2_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	dbg.add_child(_v2_frame)

	_v2_bubble = Fx.Bubble.new()
	_v2_bubble.radius = 44
	_v2_bubble.tail_width = 56.0
	dbg.add_child(_v2_bubble)

	# Dialogue text sits inside the bubble; the name tag pokes out of its top edge
	var area: VBoxContainer = $DialogueArea
	area.anchor_top = 0.0
	area.anchor_bottom = 0.0
	area.anchor_right = 0.0
	area.offset_left = V2_BUBBLE_X + 34.0
	area.offset_right = V2_BUBBLE_X + V2_BUBBLE_W - 34.0
	area.add_theme_constant_override("separation", 10)

	var name_lbl: Label = $DialogueArea/CharacterName
	name_lbl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	Fx.tag(name_lbl, Comic.RED, Color.WHITE, 26)
	Fx.tilt(name_lbl, -3.0)

	var text_lbl: Label = $DialogueArea/DialogueText
	Comic.body(text_lbl, 25, Comic.INK)
	text_lbl.add_theme_constant_override("line_spacing", 4)

	var row: HBoxContainer = $DialogueArea/DialogueButtons
	row.add_theme_constant_override("separation", 18)
	var next_btn: Button = $DialogueArea/DialogueButtons/NextButton
	next_btn.text = "Next  ▶"
	Fx.hero_button(next_btn, "primary", 34, 24, 2)
	Fx.tilt(next_btn, -2.0)
	_style_btn($DialogueArea/DialogueButtons/BackButton, "secondary", 24)
	$DialogueArea/DialogueButtons/BackButton.text = "◀  Back"
	Fx.hero_button($DialogueArea/DialogueButtons/RetryChallengeButton, "primary", 28, 20, 2)

	# Top strip: bigger lesson lettering, film-strip progress, red-shadow Hub
	Comic.heading($TopBar/LessonLabel, 34, Comic.YELLOW)
	Fx.red_shadow($TopBar/BackToHubButton)
	var pb: ProgressBar = $ProgressBar
	pb.anchor_left = 0.33
	pb.anchor_right = 0.67
	pb.offset_top = 16.0
	pb.offset_bottom = 44.0
	pb.add_theme_stylebox_override("background", StyleBoxEmpty.new())
	pb.add_theme_stylebox_override("fill", StyleBoxEmpty.new())
	var film := Fx.Film.new()
	film.set_anchors_preset(Control.PRESET_FULL_RECT)
	pb.add_child(film)
	film.watch(pb)

	resized.connect(_v2_layout)
	_v2_layout()

func _v2_npc_rect() -> Rect2:
	return Rect2($NPCSprite.offset_left, V2_NPC_TOP, V2_NPC_W, V2_NPC_H)

# Positions that depend on the screen size and the current bubble height
func _v2_layout() -> void:
	if _v2_bubble == null:
		return
	var w: float = size.x if size.x > 0.0 else 1280.0
	var h: float = size.y if size.y > 0.0 else 720.0
	var panel := Rect2(16, 84, w - 32.0, h - 100.0)
	_v2_frame.panel_rect = panel
	_v2_frame.queue_redraw()
	_v2_dots.position = panel.position + Vector2(6, 6)
	_v2_dots.size = panel.size - Vector2(12, 12)

	var npc: TextureRect = $NPCSprite
	npc.offset_left = w - 550.0
	npc.offset_right = w - 550.0 + V2_NPC_W

	var bottom: float = h - 196.0
	var top: float = bottom - _v2_h
	_v2_bubble.position = Vector2(V2_BUBBLE_X, top)
	_v2_bubble.size = Vector2(V2_BUBBLE_W, _v2_h)
	$DialogueArea.offset_top = top - 24.0
	$DialogueArea.offset_bottom = bottom + 74.0
	if _v2_mode == "you":
		_v2_bubble.tail_tip = Vector2(70, _v2_h + 62)
	elif _v2_mode == "npc":
		var mouth: Vector2 = Fx.mouth_point(npc, _v2_npc_rect())
		_v2_bubble.tail_tip = mouth - Vector2(16, 0) - _v2_bubble.position
	_v2_bubble.queue_redraw()

func _apply_speech_style() -> void:
	if _v2_bubble == null:
		return
	var mode: String = "npc"
	if _step >= 0 and _step < _story.size():
		var s: Dictionary = _story[_step]
		var t: String = s.get("type", "")
		if t == "retry":
			mode = "retry"
		elif t == "dialogue":
			var ck: String = s.get("char", "scene")
			if ck == "scene":
				mode = "scene"
			elif ck == "you":
				mode = "you"
	_v2_mode = mode
	var name_lbl: Label = $DialogueArea/CharacterName
	match mode:
		"scene":
			_v2_bubble.fill = Comic.YELLOW
			_v2_bubble.square = true
			_v2_bubble.tail_side = "none"
			Fx.tag(name_lbl, Comic.INK, Comic.YELLOW, 24, true, Comic.RED)
		"you":
			_v2_bubble.fill = Color.WHITE
			_v2_bubble.square = false
			_v2_bubble.tail_at = 0.08
			_v2_bubble.tail_side = "bottom"
			Fx.tag(name_lbl, Comic.BLUE, Color.WHITE, 26)
		"retry":
			_v2_bubble.fill = Color.WHITE
			_v2_bubble.square = false
			_v2_bubble.tail_side = "none"
		_:
			_v2_bubble.fill = Color.WHITE
			_v2_bubble.square = false
			_v2_bubble.tail_at = 0.0
			_v2_bubble.tail_side = "right"
			Fx.tag(name_lbl, Comic.RED, Color.WHITE, 26)
	name_lbl.self_modulate.a = 0.0 if name_lbl.text.strip_edges().is_empty() else 1.0

	# Size the bubble to its text; its bottom (and the buttons) never move
	var text: String = $DialogueArea/DialogueText.text if mode == "retry" else _full_text
	var f: Font = Comic.body_font()
	var inner_w: float = V2_BUBBLE_W - 68.0
	var text_h: float = f.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, inner_w, 25).y
	var lines: int = maxi(1, int(round(text_h / f.get_height(25))))
	text_h += lines * 4.0
	_v2_h = clampf(text_h + 70.0, 150.0, 430.0)
	_v2_layout()
