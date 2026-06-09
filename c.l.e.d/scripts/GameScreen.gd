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

const CHAR_BASE := "res://images/characters/NPC_adults/"
const CHAR_ROOT := "res://images/characters/"

var _tex_cache:   Dictionary = {}
var _bg_textures: Dictionary = {}
var _story:       Array      = []
var _step:        int        = 0
var _current_gm:  Node       = null
var _failed_step: Dictionary = {}

func _ready() -> void:
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons/NextButton.pressed.connect(_on_next)
	$DialogueArea/DialogueButtons/BackButton.pressed.connect(_on_back)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.pressed.connect(_on_back)

	# Top bar dark strip
	var tb_bg := ColorRect.new()
	tb_bg.color        = Color(0.04, 0.05, 0.08, 0.94)
	tb_bg.anchor_right = 1.0
	tb_bg.offset_bottom = 42.0
	tb_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tb_bg.z_index      = 2
	add_child(tb_bg)

	# Top bar bottom amber accent line
	var tb_line := ColorRect.new()
	tb_line.color        = Color("#F59E0B")
	tb_line.anchor_right = 1.0
	tb_line.offset_top   = 41.0
	tb_line.offset_bottom = 43.0
	tb_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tb_line.z_index      = 2
	add_child(tb_line)

	# Amber accent line at top edge of dialogue box
	var dlg_line := ColorRect.new()
	dlg_line.color        = Color("#F59E0B")
	dlg_line.anchor_top   = 1.0
	dlg_line.anchor_right = 1.0
	dlg_line.anchor_bottom = 1.0
	dlg_line.offset_top   = -222.0
	dlg_line.offset_bottom = -218.0
	dlg_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg_line.z_index      = 3
	add_child(dlg_line)

	# TopBar — ensure labels render above our bg strips
	$TopBar.z_index = 3
	$ProgressBar.z_index = 3

	# TopBar label
	$TopBar/LessonLabel.add_theme_font_size_override("font_size", 14)
	$TopBar/LessonLabel.add_theme_color_override("font_color", Color(0.60, 0.65, 0.76))

	# Button hierarchy
	_style_btn($TopBar/BackToHubButton, "secondary", 13)
	$TopBar/BackToHubButton.text = "← Hub"

	_style_btn($DialogueArea/DialogueButtons/BackButton, "ghost", 15)
	_style_btn($DialogueArea/DialogueButtons/NextButton, "primary", 15)
	$DialogueArea/DialogueButtons/NextButton.text = "Next  →"

	_style_btn($SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton, "secondary", 14)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.text = "← Dialogue"

	# Dialogue character name — amber accent
	$DialogueArea/CharacterName.add_theme_font_size_override("font_size", 14)
	$DialogueArea/CharacterName.add_theme_color_override("font_color", Color("#F59E0B"))
	$DialogueArea/CharacterName.add_theme_constant_override("outline_size", 1)
	$DialogueArea/CharacterName.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))

	# Dialogue text
	$DialogueArea/DialogueText.add_theme_font_size_override("font_size", 15)
	$DialogueArea/DialogueText.add_theme_color_override("font_color", Color(0.92, 0.93, 0.96))

	# SQL overlay panel
	_style_sql_panel()

	_load_all_textures()
	_style_progress_bar()

func _style_sql_panel() -> void:
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.08, 0.10, 0.15, 0.98)
	panel_style.border_color = Color(0.24, 0.30, 0.42)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(12)
	panel_style.content_margin_left   = 0
	panel_style.content_margin_right  = 0
	panel_style.content_margin_top    = 0
	panel_style.content_margin_bottom = 0
	$SQLOverlay/CenterContainer/PanelContainer.add_theme_stylebox_override("panel", panel_style)

# ── Keyboard shortcuts ────────────────────────────────────
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
			"police":  path = CHAR_BASE + "adult_5/idle.png"
			"library": path = CHAR_BASE + "adult_7/idle.png"
			_:         path = CHAR_BASE + "adult_1/idle.png"

	var tex := _load_texture(path)
	if tex:
		$NPCSprite.texture = tex
		$NPCSprite.visible = true
	else:
		$NPCSprite.visible = false

func load_lesson(id) -> void:
	_story = _get_story(id)
	_step  = 0
	$TopBar/LessonLabel.text = "  Lesson  " + str(id)
	_set_background(GameManager.world)
	_set_expression("scene")
	_close_overlay()
	_run_step()

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
			var main := get_tree().root.get_node("Main")
			if main.has_method("show_failed"):
				main.show_failed()
			else:
				main.show_screen("failed")

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

func _on_gm_wrong() -> void:
	GameManager.stop_speaking()
	if _current_gm and is_instance_valid(_current_gm):
		if _current_gm.on_wrong.is_connected(_on_gm_wrong):
			_current_gm.on_wrong.disconnect(_on_gm_wrong)

	var current_step: Dictionary = _story[_step]
	var fail_steps: Array = current_step.get("fail", [])
	if fail_steps.is_empty():
		return

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

# ── Progress bar ─────────────────────────────────────
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
