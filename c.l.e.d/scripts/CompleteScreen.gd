extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")

const Dashboard = preload("res://scripts/DashboardScreen.gd")

@onready var _vbox        := $CenterContainer/CardPanel/VBoxContainer
@onready var _icon_lbl    := $CenterContainer/CardPanel/VBoxContainer/IconLabel
@onready var _title_lbl   := $CenterContainer/CardPanel/VBoxContainer/Title
@onready var _sub_lbl     := $CenterContainer/CardPanel/VBoxContainer/LessonLabel
@onready var _hub_btn     := $CenterContainer/CardPanel/VBoxContainer/BackToHubButton
@onready var _world_btn   := $CenterContainer/CardPanel/VBoxContainer/ChangeWorldButton

# Comic v2 page pieces (decoration + layout only)
const CHAR_BY_WORLD: Dictionary = {
	"hotel": "adult_1", "cafe": "adult_3", "airport": "adult_2", "library": "adult_7",
}
var _rays: ShaderMaterial = null
var _char: TextureRect = null
var _sfx = null
var _burst = null
var _logo = null
var _stars = null
var _recap_row: CenterContainer = null
var _btn_row: HBoxContainer = null

func _ready() -> void:
	_hub_btn.pressed.connect(_on_back)
	_world_btn.pressed.connect(_on_change_world)
	_build_page()

# The celebration page: sun-burst rays, the world's character cheering on the
# left, a big burst with 3D lettering, stars, a recap strip and a button row.
func _build_page() -> void:
	var bg: ColorRect = $FullBG
	var rays := Fx.rays_rect(Color("#FFD85A"), Color("#FFB21A"), Color(0.9, 0.25, 0.18, 0.45))
	bg.material = rays.material
	_rays = bg.material
	rays.free()

	$CenterContainer.visible = false

	_char = TextureRect.new()
	_char.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_char.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_char.position = Vector2(-70, 150)
	_char.size = Vector2(470, 900)
	_char.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_char)

	_sfx = Fx.sfx("WOO-HOO!", 66, Color.WHITE, Comic.BLUE, -12.0)
	_sfx.position = Vector2(24, 40)
	_sfx.size = Vector2(300, 110)
	_sfx.pivot_offset = _sfx.size / 2.0
	add_child(_sfx)

	_burst = Fx.Burst.new()
	Fx.place_centered(_burst, Rect2(280, 20, 880, 470))
	_burst.spikes = 26
	_burst.inner = 0.84
	_burst.seed_value = 17
	_burst.shadow = 12.0
	_burst.outline = 7.0
	add_child(_burst)

	_logo = Fx.Logo.new()
	Fx.place_centered(_logo, Rect2(318, 92, 804, 150))
	_logo.pivot_offset = Vector2(402, 75)
	_logo.rotation_degrees = -3.0
	_logo.font_size = 92
	_logo.depth = 10
	_logo.outline = 14
	add_child(_logo)

	# Lesson tag under the title
	var sub_wrap := CenterContainer.new()
	Fx.place_centered(sub_wrap, Rect2(280, 226, 880, 50))
	sub_wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sub_wrap)
	_sub_lbl.reparent(sub_wrap, false)
	_title_lbl.visible = false
	_icon_lbl.visible = false

	_stars = Fx.Stars.new()
	Fx.place_centered(_stars, Rect2(510, 296, 420, 170))
	_stars.big_middle = true
	_stars.pop_lines = true
	add_child(_stars)

	_recap_row = CenterContainer.new()
	Fx.place_centered(_recap_row, Rect2(300, 498, 860, 70))
	_recap_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_recap_row)

	_btn_row = HBoxContainer.new()
	Fx.place_centered(_btn_row, Rect2(300, 594, 900, 86))
	_btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_btn_row.add_theme_constant_override("separation", 22)
	add_child(_btn_row)
	_hub_btn.reparent(_btn_row, false)
	_world_btn.reparent(_btn_row, false)
	for b in [_hub_btn, _world_btn]:
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_hub_btn.text = "Hub"
	_world_btn.text = "Change World"
	_style_btn(_hub_btn, "secondary", 28)
	_style_btn(_world_btn, "secondary", 24)

func set_mode(mode: String) -> void:
	# Remove any dynamic nodes from a previous call immediately (not deferred)
	for tag in ["_recap_box", "_next_btn", "_replay_btn"]:
		for holder in [_recap_row, _btn_row]:
			var old = holder.get_node_or_null(tag)
			if old:
				old.free()

	var world: String = GameManager.world
	if mode == "failed":
		_icon_lbl.text = "✗"
		_title_lbl.text = "Lesson Failed"
		_sub_lbl.text = "Review the material and try again."
		_dress("failed", world)
		_add_replay_btn()
	else:
		_icon_lbl.text = "✓"
		_title_lbl.text = "Lesson Complete!"
		_sub_lbl.text = "Lesson  " + str(GameManager.lesson_id)
		_dress("complete", world)
		_add_complete_extras()

# Colours, pose and lettering for the two moods of the page
func _dress(mode: String, world: String) -> void:
	var failed: bool = mode == "failed"
	_logo.text = _title_lbl.text.to_upper()
	_logo.fill = Comic.RED_HI if failed else Comic.YELLOW
	_logo.extrude = Comic.INK_SOFT if failed else Comic.RED
	_logo.queue_redraw()
	_sfx.text = "OOPS!" if failed else "WOO-HOO!"
	_sfx.fill = Comic.RED_HI if failed else Color.WHITE
	_sfx.queue_redraw()
	if failed:
		_rays.set_shader_parameter("color_a", Color("#D7EBFC"))
		_rays.set_shader_parameter("color_b", Color("#B4D8F8"))
		_rays.set_shader_parameter("dot_color", Color(0.18, 0.55, 0.92, 0.40))
	else:
		_rays.set_shader_parameter("color_a", Color("#FFD85A"))
		_rays.set_shader_parameter("color_b", Color("#FFB21A"))
		_rays.set_shader_parameter("dot_color", Color(0.9, 0.25, 0.18, 0.45))
	Fx.tag(_sub_lbl, Comic.INK, Comic.PAPER, 26, true, Comic.RED if not failed else Comic.BLUE)
	_stars.filled = 0 if failed else GameManager.last_stars
	var path: String = "res://images/characters/NPC_adults/%s/%s.png" % [
		CHAR_BY_WORLD.get(world, "adult_1"), "confuse" if failed else "talk"]
	_char.texture = load(path) if ResourceLoader.exists(path) else null

func _on_back() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func _add_replay_btn() -> void:
	var replay_btn := Button.new()
	replay_btn.name = "_replay_btn"
	replay_btn.text = "↺  Replay Lesson"
	replay_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("game")
	)
	_btn_row.add_child(replay_btn)
	_btn_row.move_child(replay_btn, 0)
	Fx.hero_button(replay_btn, "primary", 40, 26, 6)
	Fx.tilt(replay_btn, -1.5)

func _add_complete_extras() -> void:
	# ── SQL Recap strip ───────────────────────────────
	var recap: Array = GameManager.get_sql_recap()
	if recap.size() > 0:
		var recap_box := PanelContainer.new()
		recap_box.name = "_recap_box"
		recap_box.add_theme_stylebox_override("panel", Comic.box(Comic.PAPER_HI, Comic.INK, 4, 2, 6, 16, 10))
		recap_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_recap_row.add_child(recap_box)

		var inner := HBoxContainer.new()
		inner.add_theme_constant_override("separation", 10)
		recap_box.add_child(inner)

		var rt := Label.new()
		rt.text = "SQL you used:"
		Comic.heading(rt, 24, Comic.RED)
		inner.add_child(rt)

		for cmd in recap:
			var cl := Label.new()
			cl.text = cmd
			Comic.body(cl, 19, Color("#7EE0A2"))
			cl.add_theme_stylebox_override("normal", Comic.box(Comic.INK, Comic.INK, 0, 8, 0, 12, 3))
			inner.add_child(cl)
		Fx.tilt(recap_box, -0.8)

	# ── Next step button (Next Lesson / Folder Challenge) ──
	var next_data: Dictionary = _next_step_data()
	var next_btn: Button = null
	if not next_data.is_empty():
		next_btn = Button.new()
		next_btn.name = "_next_btn"
		next_btn.text = next_data["label"]
		if next_data["action"] == "quiz":
			var cap_fi: int = next_data["folder_idx"]
			next_btn.pressed.connect(func():
				GameManager.current_quiz_folder_idx = cap_fi
				get_tree().root.get_node("Main").show_screen("folder_quiz")
			)
		else:
			var cap_lid = next_data["lesson_id"]
			next_btn.pressed.connect(func():
				GameManager.lesson_id = cap_lid
				get_tree().root.get_node("Main").show_screen("game")
			)

	# ── Replay button ─────────────────────────────────
	var replay_btn := Button.new()
	replay_btn.name = "_replay_btn"
	replay_btn.text = "↺  Replay"
	replay_btn.pressed.connect(func():
		get_tree().root.get_node("Main").show_screen("game")
	)
	_btn_row.add_child(replay_btn)
	_btn_row.move_child(replay_btn, 0)
	_style_btn(replay_btn, "secondary", 28)

	if next_btn != null:
		_btn_row.add_child(next_btn)
		_btn_row.move_child(next_btn, 0)
		Fx.hero_button(next_btn, "primary", 40, 26, 6)
		Fx.tilt(next_btn, -1.5)

# ── Determine what comes after the just-completed lesson ──
# Mirrors DashboardScreen's own unlock rules so this button
# never offers something the Dashboard would still show as locked.
func _next_step_data() -> Dictionary:
	var world: String = GameManager.world
	var lid = GameManager.lesson_id
	var ids: Array
	var folders: Array
	match world:
		"hotel":   ids = Dashboard.HOTEL_LESSONS;   folders = Dashboard.HOTEL_FOLDERS
		"cafe":    ids = Dashboard.CAFE_LESSONS;    folders = Dashboard.CAFE_FOLDERS
		"airport": ids = Dashboard.AIRPORT_LESSONS; folders = Dashboard.AIRPORT_FOLDERS
		"library": ids = Dashboard.LIBRARY_LESSONS; folders = Dashboard.LIBRARY_FOLDERS
		_: return {}

	var folder_idx: int = -1
	var is_last_in_folder: bool = false
	for fi in range(folders.size()):
		var fids: Array = folders[fi]["ids"]
		if fids.has(lid):
			folder_idx = fi
			is_last_in_folder = fids[fids.size() - 1] == lid
			break

	if folder_idx == -1:
		return {}

	# Just finished the last lesson in this folder and haven't passed its
	# challenge yet — that's the next thing to do, not the next folder.
	if is_last_in_folder and not GameManager.is_folder_quiz_done(world, folder_idx):
		var is_final: bool = folder_idx == folders.size() - 1
		return {
			"label":  "⚡  Final Test  →" if is_final else "⚡  Folder Challenge  →",
			"action": "quiz",
			"folder_idx": folder_idx,
		}

	var idx: int = ids.find(lid)
	if idx >= 0 and idx < ids.size() - 1:
		return {
			"label":  "Next Lesson  →",
			"action": "lesson",
			"lesson_id": ids[idx + 1],
		}

	return {}

# ── Button styles (comic look, from ComicStyle) ──────
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 16) -> void:
	var pad_h: int = 26 if variant == "primary" else 22
	Comic.apply_button(btn, variant, font_size, true, pad_h, 10)
	if variant == "secondary":
		for st in ["normal", "hover", "pressed", "hover_pressed"]:
			var sb = btn.get_theme_stylebox(st)
			if sb is StyleBoxFlat:
				var c: StyleBoxFlat = sb.duplicate()
				c.set_border_width_all(4)
				c.shadow_offset = Vector2(6, 6) if not st.contains("pressed") else Vector2(2, 2)
				btn.add_theme_stylebox_override(st, c)
