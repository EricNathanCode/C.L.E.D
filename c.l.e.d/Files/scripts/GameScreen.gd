extends Control
# ═══════════════════════════════════════════════════════
#  GAME SCREEN  —  scripts/GameScreen.gd
#
#  NPCSprite sits CENTER of screen, ALWAYS visible
#  during dialogue — including when YOU speak.
#  Only hides when the SQL terminal opens.
#
#  MC expressions used as placeholder NPC images:
#    "scene"  / "you"      → IDLE  (default standing)
#    "guest"  / "guest2"   → TALK  (talking expression)
#    "guest3"               → SHOCK (angry/surprised)
#    "mgr"                  → THINKING
#    "cafe_customer"        → TALK
#    "cafe_supervisor"      → THINKING
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

const BG_HOTEL  := "res://images/backgrounds/BG_hotel.png"
const CHAR_BASE := "res://images/characters/NPC_adults/"

# MC expression paths (used as NPC placeholder)
const MC_EXPR: Dictionary = {
	"idle":     "res://images/characters/NPC_adults/adult_1/idle.png",
	"talk":     "res://images/characters/NPC_adults/adult_1/talk.png",
	"thinking": "res://images/characters/NPC_adults/adult_1/think.png",
	"confuse":  "res://images/characters/NPC_adults/adult_1/confuse.png",
	"shock":    "res://images/characters/NPC_adults/adult_1/shock.png",
}

# Which MC expression to show per story char key
# NPC ALWAYS stays visible — this just swaps the expression
const CHAR_TO_EXPR: Dictionary = {
	"you":           "idle",
	"scene":         "idle",
	"guest":         "talk",
	"guest2":        "talk",
	"guest3":        "shock",
	"mgr":           "thinking",
	"cafe_customer":   "talk",
	"cafe_supervisor": "thinking",
}

var _mc_textures: Dictionary = {}
var _bg_textures: Dictionary = {}
var _story:       Array      = []
var _step:        int        = 0
var _current_gm:  Node       = null

func _ready() -> void:
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons/NextButton.pressed.connect(_on_next)
	$DialogueArea/DialogueButtons/BackButton.pressed.connect(_on_back)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.pressed.connect(_on_back)

	# Button colours
	_style_btn($TopBar/BackToHubButton, Color("#DC2626"), Color.WHITE)
	_style_btn($DialogueArea/DialogueButtons/BackButton, Color("#374151"), Color.WHITE)
	_style_btn($DialogueArea/DialogueButtons/NextButton, Color("#F59E0B"), Color("#1A1008"))
	_style_btn($SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton,
		Color("#2563EB"), Color.WHITE)

	_load_all_textures()

# ── Texture loading ───────────────────────────────────────
func _load_all_textures() -> void:
	for key in MC_EXPR:
		var tex := _load_texture(MC_EXPR[key])
		if tex:
			_mc_textures[key] = tex

	var bg := _load_texture(BG_HOTEL)
	if bg:
		_bg_textures["hotel"] = bg

func _load_texture(res_path: String) -> Texture2D:
	# Method 1 — Godot resource system (works when file is imported)
	if ResourceLoader.exists(res_path):
		var tex := ResourceLoader.load(res_path) as Texture2D
		if tex:
			return tex

	# Method 2 — FileAccess buffer (works without .import files)
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
			return ImageTexture.create_from_image(img)

	# Method 3 — Image.load() direct fallback
	var img2 := Image.new()
	if img2.load(abs_path) == OK:
		if img2.get_format() != Image.FORMAT_RGBA8:
			img2.convert(Image.FORMAT_RGBA8)
		return ImageTexture.create_from_image(img2)

	return null

# ── Apply background ──────────────────────────────────────
func _set_background(world: String) -> void:
	if _bg_textures.has(world):
		$SceneBG.texture = _bg_textures[world]
	else:
		$SceneBG.texture = null

# ── Set NPC expression (sprite always stays visible) ──────
# npc_override: "adult_2/shock" → loads adult_2/shock.png directly
# Leave empty  → falls back to CHAR_TO_EXPR default for char_key
func _set_expression(char_key: String, npc_override: String = "") -> void:
	var path: String
	if npc_override != "":
		var parts := npc_override.split("/")
		path = CHAR_BASE + parts[0] + "/" + parts[1] + ".png" if parts.size() == 2 else CHAR_BASE + "adult_1/idle.png"
	else:
		var expr: String = CHAR_TO_EXPR.get(char_key, "idle")
		var key:  String = expr if _mc_textures.has(expr) else "idle"
		path = MC_EXPR.get(key, CHAR_BASE + "adult_1/idle.png")
	# Load on demand if not cached (handles npc overrides pointing to adult_2, adult_3, etc.)
	if not _mc_textures.has(path):
		var tex := _load_texture(path)
		if tex:
			_mc_textures[path] = tex
	if _mc_textures.has(path):
		$NPCSprite.texture = _mc_textures[path]
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

	var s: Dictionary = _story[_step]
	$DialogueArea/DialogueButtons/BackButton.visible = _step > 0

	match s["type"]:
		"dialogue":
			var char_key: String = s.get("char", "scene")
			var npc_key:  String = s.get("npc", "")          # e.g. "adult_2/shock"
			_set_expression(char_key, npc_key)               # override if "npc" present
			$DialogueArea/CharacterName.text                  = s.get("name", "")
			$DialogueArea/DialogueText.text                   = s.get("text", "")
			$DialogueArea/DialogueButtons/NextButton.visible  = true

		"sql_choice":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, "select")

		"sql_fill":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, s.get("gamemode", ""))

		"end":
			get_tree().root.get_node("Main").show_screen("complete")

# ── SQL Terminal (hide everything except terminal panel) ───
func _show_challenge(step: Dictionary, gm_key: String) -> void:
	var path: String = GM_SCENES.get(gm_key, "")
	if path.is_empty():
		push_error("GameScreen: unknown gamemode key: " + gm_key)
		return
	_clear_gm()
	var packed: PackedScene = load(path)
	_current_gm = packed.instantiate()
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/ScrollContainer/GMContainer.add_child(_current_gm)
	_current_gm.on_correct.connect(_on_gm_correct)
	_current_gm.setup(step)

	# Terminal mode — hide scene, show only SQL panel
	$SceneBG.visible      = false
	$NPCSprite.visible    = false
	$DialogueBG.visible   = false
	$DialogueArea.visible = false
	$SQLOverlay.visible   = true

func _on_gm_correct() -> void:
	_close_overlay()
	_step += 1
	_run_step()

# ── Navigation ────────────────────────────────────────────
func _on_next() -> void:
	_step += 1
	_run_step()

func _on_back() -> void:
	_close_overlay()
	_step = max(0, _step - 1)
	_run_step()

func _on_back_to_hub() -> void:
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
	if GameManager.world == "hotel":
		script = preload("res://scripts/data/HotelData.gd").new()
	else:
		script = preload("res://scripts/data/CafeData.gd").new()
	var result: Array = []
	if script.LESSONS.has(id):
		result = script.LESSONS[id].duplicate(true)
	else:
		push_error("GameScreen: lesson id not found: " + str(id))
	script.free()
	return result

func _style_btn(btn: Button, bg: Color, fg: Color) -> void:
	btn.add_theme_color_override("font_color", fg)
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = Color(0, 0, 0, 0.5)
	s.set_border_width_all(2)
	s.set_corner_radius_all(6)
	s.content_margin_left   = 14;  s.content_margin_right  = 14
	s.content_margin_top    = 6;   s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat; h.bg_color = bg.lightened(0.15)
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat; p.bg_color = bg.darkened(0.15)
	btn.add_theme_stylebox_override("pressed", p)
