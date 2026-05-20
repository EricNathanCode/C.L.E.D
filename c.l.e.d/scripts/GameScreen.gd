extends Control
# ═══════════════════════════════════════════════════════
#  GAME SCREEN  —  scripts/GameScreen.gd
#
#  "npc" field format in story data:
#    "adult_1/talk"                    → NPC_adults/adult_1/talk.png
#    "NPC_occupations/police/talk"     → NPC_occupations/police/talk.png
#    "NPC_occupations/librarian/idle"  → NPC_occupations/librarian/idle.png
#
#  NPC assignments per world:
#    Hotel:   adult_1, adult_2            boss: NPC_occupations/hotel_manager
#    Cafe:    adult_3, adult_4            boss: NPC_occupations/coffee_owner
#    Police:  adult_5, adult_6            boss: NPC_occupations/police
#    Library: adult_7, adult_8            boss: NPC_occupations/librarian
# ═══════════════════════════════════════════════════════

const GM_SCENES: Dictionary = {
	"select":       "res://gamemode/scene/GM_Select.tscn",
	"insert_into":  "res://gamemode/scene/GM_InsertInto.tscn",
	"select_where": "res://gamemode/scene/GM_SelectWhere.tscn",
	"update_set":   "res://gamemode/scene/GM_UpdateSet.tscn",
	"delete":       "res://gamemode/scene/GM_Delete.tscn",
	"order_by":     "res://gamemode/scene/GM_OrderBy.tscn",
	"group_by":     "res://gamemode/scene/GM_GroupBy.tscn",
}

const BG_HOTEL   := "res://images/backgrounds/BG_hotel.png"
const BG_CAFE    := "res://images/backgrounds/BG_cafe.png"
const BG_POLICE  := "res://images/backgrounds/BG_police.png"
const BG_LIBRARY := "res://images/backgrounds/BG_library.png"

# Base paths for NPC images
const CHAR_BASE := "res://images/characters/NPC_adults/"
const CHAR_ROOT := "res://images/characters/"   # for NPC_occupations/ paths

var _tex_cache:  Dictionary = {}   # full res:// path → Texture2D
var _bg_textures: Dictionary = {}  # world key → Texture2D
var _story:      Array      = []
var _step:       int        = 0
var _current_gm:  Node       = null
var _failed_step: Dictionary = {}  # stores the SQL step to retry after fail dialogue

func _ready() -> void:
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons/NextButton.pressed.connect(_on_next)
	$DialogueArea/DialogueButtons/BackButton.pressed.connect(_on_back)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.pressed.connect(_on_back)

	_style_btn($TopBar/BackToHubButton)
	_style_btn($DialogueArea/DialogueButtons/BackButton)
	_style_btn($DialogueArea/DialogueButtons/NextButton)
	_style_btn($SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton)

	_load_all_textures()
	_style_progress_bar()


# ── Keyboard shortcuts ────────────────────────────────────
# Dialogue scene:  ← Back | → Next | Esc Back to Hub
# SQL scene:       ← Back to Dialogue | Enter Execute | H Hint | → Continue Story
func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not event is InputEventKey or not event.pressed:
		return

	var sql_open: bool = $SQLOverlay.visible

	if sql_open:
		# SQL challenge shortcuts — delegate to the active GM node
		match event.keycode:
			KEY_LEFT:
				# Back to Dialogue
				_on_back()
			KEY_ENTER, KEY_KP_ENTER:
				# Execute — call _on_execute on the GM if it exists
				if _current_gm and is_instance_valid(_current_gm) and _current_gm.has_method("_on_execute"):
					_current_gm._on_execute()
			KEY_H:
				# Hint
				if _current_gm and is_instance_valid(_current_gm) and _current_gm.has_method("_on_hint"):
					_current_gm._on_hint()
			KEY_RIGHT:
				# Continue Story — only if ContinueButton is visible
				if _current_gm and is_instance_valid(_current_gm):
					var cb: Button = _current_gm.get_node_or_null("ContinueButton")
					if cb and cb.visible:
						_current_gm._on_continue()
	else:
		# Dialogue scene shortcuts
		match event.keycode:
			KEY_RIGHT:
				# Next — only if NextButton is visible
				if $DialogueArea/DialogueButtons/NextButton.visible:
					_on_next()
			KEY_LEFT:
				# Back — only if BackButton is visible
				if $DialogueArea/DialogueButtons/BackButton.visible:
					_on_back()
			KEY_ESCAPE:
				# Back to Hub
				_on_back_to_hub()

# ── Texture loading ───────────────────────────────────────
func _load_all_textures() -> void:
	for pair in [["hotel", BG_HOTEL], ["cafe", BG_CAFE],
				 ["police", BG_POLICE], ["library", BG_LIBRARY]]:
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

# ── Apply background ──────────────────────────────────────
func _set_background(world: String) -> void:
	if _bg_textures.has(world):
		$SceneBG.texture = _bg_textures[world]
	else:
		$SceneBG.texture = null

# ── Set NPC expression ────────────────────────────────────
# npc_override format:
#   "adult_3/talk"                  → NPC_adults/adult_3/talk.png
#   "NPC_occupations/police/shock"  → NPC_occupations/police/shock.png
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
		# Fallback if no "npc" field — default idle for each world
		match GameManager.world:
			"hotel":   path = CHAR_BASE + "adult_1/idle.png"
			"cafe":    path = CHAR_BASE + "adult_3/idle.png"
			"police":  path = CHAR_BASE + "adult_5/idle.png"
			"library": path = CHAR_BASE + "adult_7/idle.png"
			_:         path = CHAR_BASE + "adult_1/idle.png"

	var tex := _load_texture(path)
	if tex:
		$NPCSprite.texture = tex
		$NPCSprite.visible = true
	else:
		$NPCSprite.visible = false

# ── Load lesson ───────────────────────────────────────────
func load_lesson(id) -> void:
	_story = _get_story(id)
	_step  = 0
	$TopBar/LessonLabel.text = "Lesson: " + str(id)
	_set_background(GameManager.world)
	_set_expression("scene")
	_close_overlay()
	_run_step()

# ── Story engine ──────────────────────────────────────────
func _run_step() -> void:
	if _step >= _story.size():
		get_tree().root.get_node("Main").show_screen("complete")
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
			$DialogueArea/DialogueText.text                   = s.get("text", "")
			$DialogueArea/DialogueButtons/NextButton.visible  = true
			GameManager.speak(s.get("text", ""), char_key)

		"sql_choice":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, "select")

		"sql_fill":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, s.get("gamemode", ""))

		"end":
			get_tree().root.get_node("Main").show_screen("complete")

		"retry":
			# Fail dialogue finished — show Lesson Failed screen
			var main := get_tree().root.get_node("Main")
			if main.has_method("show_failed"):
				main.show_failed()
			else:
				main.show_screen("failed")



# ── SQL Terminal ──────────────────────────────────────────
func _show_challenge(step: Dictionary, gm_key: String) -> void:
	GameManager.stop_speaking()
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
	$SQLOverlay.visible   = true


# ── Wrong answer — play fail dialogue then retry ──────────
func _on_gm_wrong() -> void:
	GameManager.stop_speaking()
	# Disconnect to prevent multiple triggers
	if _current_gm and is_instance_valid(_current_gm):
		if _current_gm.on_wrong.is_connected(_on_gm_wrong):
			_current_gm.on_wrong.disconnect(_on_gm_wrong)

	# Check if this step has a fail dialogue
	var current_step: Dictionary = _story[_step]
	var fail_steps: Array = current_step.get("fail", [])
	if fail_steps.is_empty():
		return  # No fail path — just show the error in terminal as before

	# Store the step so we can retry it
	_failed_step = current_step

	# Build a temporary fail story and play it
	var fail_story: Array = fail_steps.duplicate(true)
	# Add failed sentinel at the end
	fail_story.append({ "type": "retry" })

	# Override _story temporarily with fail steps
	var saved_story: Array = _story
	var saved_step:  int   = _step
	_story = fail_story
	_step  = 0
	_step  = 0
	_close_overlay()

	# Store originals so retry can restore them
	set_meta("_saved_story", saved_story)
	set_meta("_saved_step",  saved_step)
	_run_step()

func _on_gm_correct() -> void:
	GameManager.stop_speaking()
	_close_overlay()
	_step += 1
	_run_step()

# ── Navigation ────────────────────────────────────────────
func _on_next() -> void:
	GameManager.stop_speaking()
	_step += 1
	_run_step()

func _on_back() -> void:
	GameManager.stop_speaking()
	_close_overlay()
	_step = max(0, _step - 1)
	_run_step()

func _on_back_to_hub() -> void:
	GameManager.stop_speaking()
	_close_overlay()
	get_tree().root.get_node("Main").show_screen("dashboard")

# ── Helpers ───────────────────────────────────────────────
func _close_overlay() -> void:
	$SceneBG.visible      = true
	$NPCSprite.visible    = true
	$DialogueBG.visible   = true
	$DialogueArea.visible = true
	$SQLOverlay.visible   = false
	_clear_gm()

func _clear_gm() -> void:
	if _current_gm != null and is_instance_valid(_current_gm):
		_current_gm.queue_free()
		_current_gm = null

func _get_story(id) -> Array:
	var script: Node
	match GameManager.world:
		"hotel":   script = preload("res://scripts/data/HotelData.gd").new()
		"cafe":    script = preload("res://scripts/data/CafeData.gd").new()
		"police":  script = preload("res://scripts/data/PoliceData.gd").new()
		"library": script = preload("res://scripts/data/LibraryData.gd").new()
		_:         script = preload("res://scripts/data/HotelData.gd").new()
	var result: Array = []
	if script.LESSONS.has(id):
		result = script.LESSONS[id].duplicate(true)
	else:
		push_error("GameScreen: lesson id not found: " + str(id))
	script.free()
	return result

# ── Progress bar ─────────────────────────────────────────
func _update_progress() -> void:
	var total: int = 0
	for s in _story:
		if s.get("type", "") != "end":
			total += 1
	if total == 0:
		return
	var done: int = 0
	for i in range(min(_step + 1, _story.size())):
		if _story[i].get("type", "") != "end":
			done += 1
	$ProgressBar.value = float(done) / float(total)

func _style_progress_bar() -> void:
	var pb: ProgressBar = $ProgressBar
	var bg := StyleBoxFlat.new()
	bg.bg_color     = Color(0.15, 0.15, 0.15, 0.85)
	bg.border_color = Color(0, 0, 0, 0.6)
	bg.set_border_width_all(1)
	bg.set_corner_radius_all(10)
	pb.add_theme_stylebox_override("background", bg)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("#F59E0B")
	fill.set_corner_radius_all(10)
	pb.add_theme_stylebox_override("fill", fill)
	pb.value = 0.0

func _style_btn(btn: Button) -> void:
	btn.add_theme_color_override("font_color", Color.BLACK)
	var s := StyleBoxFlat.new()
	s.bg_color     = Color.WHITE
	s.border_color = Color.BLACK
	s.set_border_width_all(2)
	s.set_corner_radius_all(6)
	s.content_margin_left   = 14;  s.content_margin_right  = 14
	s.content_margin_top    = 6;   s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color("#F59E0B")  # yellow hover
	h.border_color = Color("#B45309")
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color     = Color("#D97706")  # darker yellow press
	p.border_color = Color("#92400E")
	btn.add_theme_stylebox_override("pressed", p)
