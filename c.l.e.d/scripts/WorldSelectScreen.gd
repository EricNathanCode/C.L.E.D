extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
const TermsOverlay = preload("res://scripts/TermsOverlay.gd")
const ConfirmOverlay = preload("res://scripts/ConfirmOverlay.gd")
# ═══════════════════════════════════════════════════════
#  WORLD SELECT SCREEN  |  scripts/WorldSelectScreen.gd
# ═══════════════════════════════════════════════════════

const WORLDS: Array = ["hotel", "cafe", "airport", "library"]

const WORLD_NAMES: Dictionary = {
	"hotel":   "Hotel World",
	"cafe":    "Cafe World",
	"airport": "Airport World",
	"library": "Library",
}

const WORLD_BGS: Dictionary = {
	"hotel":   "res://images/backgrounds/BG_hotel.png",
	"cafe":    "res://images/backgrounds/BG_cafe.png",
	"airport": "res://images/backgrounds/BG_airport.png",
	"library": "res://images/backgrounds/BG_library.png",
}

var _bg_cache: Dictionary = {}
var _index: int = 0

@onready var _panel         := $SettingsOverlay/SettingsPanel
@onready var _music_slider  := $SettingsOverlay/SettingsPanel/VBox/MusicRow/MusicToggle
@onready var _tts_slider    := $SettingsOverlay/SettingsPanel/VBox/TTSRow/TTSToggle
@onready var _music_label   := $SettingsOverlay/SettingsPanel/VBox/MusicRow/MusicLabel
@onready var _tts_label     := $SettingsOverlay/SettingsPanel/VBox/TTSRow/TTSLabel
@onready var _sfx_slider    := $SettingsOverlay/SettingsPanel/VBox/SFXRow/SFXToggle
@onready var _sfx_label     := $SettingsOverlay/SettingsPanel/VBox/SFXRow/SFXLabel
var _dark_btn: Button = null
var _reset_btn: Button = null
var _reset_armed: bool = false
var _logout_btn: Button = null
var _completion_lbl: Label = null

# Total lessons per world (used for completion %)
const LESSONS_PER_WORLD: int = 17

func _ready() -> void:
	$SceneBG.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	$UpButton.pressed.connect(_on_up)
	$DownButton.pressed.connect(_on_down)
	$EnterButton.pressed.connect(_on_enter)
	$ExitButton.pressed.connect(_on_exit)
	$SettingsButton.pressed.connect(_on_settings_open)

	$SettingsOverlay/DimBG.gui_input.connect(_on_dim_input)
	$SettingsOverlay/SettingsPanel/VBox/TitleRow/CloseButton.pressed.connect(_on_settings_close)
	_music_slider.value_changed.connect(_on_music_changed)
	_tts_slider.value_changed.connect(_on_tts_changed)
	_sfx_slider.value = GameManager.sfx_volume
	_sfx_slider.value_changed.connect(_on_sfx_changed)
	_sfx_slider.drag_ended.connect(func(_changed): GameManager.play_click_preview())

	$ExitConfirmOverlay/DimBG.gui_input.connect(_on_exit_dim_input)
	$ExitConfirmOverlay/ConfirmPanel/VBox/LogoutExitButton.pressed.connect(_on_exit_logout)
	$ExitConfirmOverlay/ConfirmPanel/VBox/StaySignedInButton.pressed.connect(_on_exit_stay)
	$ExitConfirmOverlay/ConfirmPanel/VBox/CancelButton.pressed.connect(_on_exit_cancel)
	$ExitConfirmOverlay.z_index = 20

	# Dark mode toggle | added programmatically so no tscn edit needed
	_dark_btn = Button.new()
	_dark_btn.pressed.connect(_on_dark_toggle)
	$SettingsOverlay/SettingsPanel/VBox.add_child(_dark_btn)

	# Raise the settings overlay above the dark overlay in Main (z=10)
	$SettingsOverlay.z_index = 20

	# Button hierarchy: primary CTA, secondary nav, ghost tertiary
	_style_btn($UpButton,    "info",      30)
	_style_btn($DownButton,  "info",      30)
	_style_btn($EnterButton, "primary",   40)
	_style_btn($ExitButton,  "secondary", 24)
	$EnterButton.offset_bottom = 572.0
	$ExitButton.offset_top = 600.0
	$ExitButton.offset_bottom = 656.0
	_style_btn(_dark_btn,  "secondary", 20)
	Fx.set_icon(_dark_btn, "moon", 24)
	_style_settings_btn($SettingsButton)

	# A light paper wash instead of the heavy dark veil, so the line art reads like a comic page
	$DarkOverlay.color = Color(1.0, 0.95, 0.80, 0.40)

	# Title | comic caption lettering over the art
	Comic.title($Title, 34, Comic.YELLOW, 8)

	# World name | large hero text
	Comic.title($WorldName, 66, Color.WHITE, 12)
	$UpButton.offset_left = -360.0;  $UpButton.offset_right = -300.0
	$DownButton.offset_left = 300.0; $DownButton.offset_right = 360.0
	$WorldName.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$WorldName.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER

	# Settings pop-up and exit confirmation
	_style_settings_panel()
	_style_exit_confirm_panel()

	var title_lbl := $SettingsOverlay/SettingsPanel/VBox/TitleRow/TitleLabel
	title_lbl.text = "Settings"

	# Reset Progress button | danger action, lives at the bottom of Settings
	$SettingsOverlay/SettingsPanel/VBox.add_child(HSeparator.new())
	_reset_btn = Button.new()
	_reset_btn.pressed.connect(_on_reset_pressed)
	$SettingsOverlay/SettingsPanel/VBox.add_child(_reset_btn)
	_style_btn(_reset_btn, "danger", 20)
	_reset_btn.text = "Reset Progress"

	# Log Out | switches back to the Login Screen so another
	# student can sign in on the same PC
	$SettingsOverlay/SettingsPanel/VBox.add_child(HSeparator.new())
	_logout_btn = Button.new()
	_logout_btn.pressed.connect(_on_logout_pressed)
	$SettingsOverlay/SettingsPanel/VBox.add_child(_logout_btn)
	_style_btn(_logout_btn, "secondary", 20)
	_update_logout_button()

	# Delete My Account | removes only this player's account and progress
	var delete_btn := Button.new()
	delete_btn.text = "Delete My Account"
	delete_btn.pressed.connect(_on_delete_account_pressed)
	$SettingsOverlay/SettingsPanel/VBox.add_child(delete_btn)
	_style_btn(delete_btn, "danger", 18)

	# Terms of Use & Privacy pop-up
	var terms_btn := Button.new()
	terms_btn.text = "Terms & Privacy"
	terms_btn.pressed.connect(func(): TermsOverlay.open(self))
	$SettingsOverlay/SettingsPanel/VBox.add_child(terms_btn)
	_style_btn(terms_btn, "ghost", 18)

	# Completion % label under the world name
	_completion_lbl = Label.new()
	_completion_lbl.anchor_left = 0.0
	_completion_lbl.anchor_right = 1.0
	_completion_lbl.offset_top = 440.0
	_completion_lbl.offset_bottom = 476.0
	_completion_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Comic.title(_completion_lbl, 26, Comic.YELLOW, 8)
	add_child(_completion_lbl)

	# Refresh completion % whenever this screen becomes visible again
	visibility_changed.connect(func():
		if visible:
			_update_display()
			_update_logout_button()
			_refresh_setting_sliders()
	)

	_apply_v2()
	# A browser game can't close itself (it would just freeze on the last
	# frame), so the web version has no Exit button: players close the tab.
	if OS.has_feature("web"):
		$ExitButton.visible = false
	_preload_backgrounds()
	_update_display()
	_update_tts_button()
	_update_music_button()
	_update_dark_button()

func _style_settings_panel() -> void:
	Comic.apply_dim($SettingsOverlay/DimBG)
	Comic.apply_settings_panel(
		_panel,
		$SettingsOverlay/SettingsPanel/VBox/TitleRow/TitleLabel,
		$SettingsOverlay/SettingsPanel/VBox/TitleRow/CloseButton,
		[_music_label, _tts_label, _sfx_label])
	var gear := Fx.icon_rect("gear", 32)
	var title_row: Node = $SettingsOverlay/SettingsPanel/VBox/TitleRow
	title_row.add_child(gear)
	title_row.move_child(gear, 0)

func _style_exit_confirm_panel() -> void:
	Comic.apply_dim($ExitConfirmOverlay/DimBG)
	Comic.apply_panel($ExitConfirmOverlay/ConfirmPanel, Comic.PAPER, 16, 8, 26, 22, 4)
	Comic.heading($ExitConfirmOverlay/ConfirmPanel/VBox/TitleLabel, 30)
	Comic.body($ExitConfirmOverlay/ConfirmPanel/VBox/MessageLabel, 17)

	_style_btn($ExitConfirmOverlay/ConfirmPanel/VBox/LogoutExitButton,    "secondary", 20)
	_style_btn($ExitConfirmOverlay/ConfirmPanel/VBox/StaySignedInButton, "primary",   20)
	_style_btn($ExitConfirmOverlay/ConfirmPanel/VBox/CancelButton,       "ghost",     18)

func _preload_backgrounds() -> void:
	for world in WORLDS:
		var tex := _load_texture(WORLD_BGS[world])
		if tex:
			_bg_cache[world] = tex

func _on_up() -> void:
	_index = (_index - 1 + WORLDS.size()) % WORLDS.size()
	_update_display()

func _on_down() -> void:
	_index = (_index + 1) % WORLDS.size()
	_update_display()

func _on_enter() -> void:
	GameManager.world = WORLDS[_index]
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_exit() -> void:
	if OS.has_feature("web"):
		return
	$ExitConfirmOverlay.visible = true

# ── Exit confirmation (log out or stay signed in) ─────
func _on_exit_logout() -> void:
	GameManager.logout()
	get_tree().quit()

func _on_exit_stay() -> void:
	# Session was already remembered on login — just quit, no
	# need to log in again next launch.
	get_tree().quit()

func _on_exit_cancel() -> void:
	$ExitConfirmOverlay.visible = false

func _on_exit_dim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_exit_cancel()

# ── Settings panel ────────────────────────────────────
func _on_settings_open() -> void:
	$SettingsOverlay.visible = true
	_disarm_reset()

func _on_settings_close() -> void:
	$SettingsOverlay.visible = false
	_disarm_reset()

# ── Reset Progress (two-tap confirm) ──────────────────
func _on_reset_pressed() -> void:
	if not _reset_armed:
		_reset_armed = true
		_reset_btn.text = "Tap again to confirm"
		return
	GameManager.reset_progress()
	_reset_armed = false
	_reset_btn.text = "Progress reset"
	_update_display()

func _disarm_reset() -> void:
	_reset_armed = false
	if _reset_btn:
		_reset_btn.text = "Reset Progress"

# ── Log Out ────────────────────────────────────────────
func _update_logout_button() -> void:
	if _logout_btn:
		_logout_btn.text = "Log Out (" + GameManager.current_user + ")"

# Settings can be wiped from the Login screen (Delete All Data), so show the
# current values whenever this screen opens, without re-saving them.
func _refresh_setting_sliders() -> void:
	_music_slider.set_value_no_signal(GameManager.music_volume)
	_tts_slider.set_value_no_signal(GameManager.tts_volume)
	_sfx_slider.set_value_no_signal(GameManager.sfx_volume)
	_update_dark_button()

func _on_delete_account_pressed() -> void:
	var who: String = GameManager.current_user
	ConfirmOverlay.open(self, "Delete Account?",
		"This permanently deletes the account \"%s\" and all of its progress, stars and Simulation scores from this device.\n\nOther accounts on this device are not affected. This can't be undone." % who,
		"Delete", func():
			GameManager.delete_account(who)
			_on_settings_close()
			get_tree().root.get_node("Main").show_screen("login")
	)

func _on_logout_pressed() -> void:
	GameManager.logout()
	_on_settings_close()
	get_tree().root.get_node("Main").show_screen("login")

func _on_dim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_settings_close()

func _on_tts_changed(value: float) -> void:
	GameManager.tts_volume = value
	if not GameManager.tts_enabled:
		GameManager.stop_speaking()
	GameManager.save_settings()

func _on_sfx_changed(value: float) -> void:
	GameManager.sfx_volume = value
	GameManager.save_settings()

func _on_music_changed(value: float) -> void:
	get_tree().root.get_node("Main").set_music_volume(value)

func _on_dark_toggle() -> void:
	GameManager.dark_overlay_enabled = not GameManager.dark_overlay_enabled
	get_tree().root.get_node("Main").apply_dark_overlay()
	_update_dark_button()
	GameManager.save_settings()

func _update_display() -> void:
	$UpButton.visible   = true
	$DownButton.visible = true
	var world: String = WORLDS[_index]
	$WorldName.text = WORLD_NAMES[world]
	$WorldName.add_theme_color_override("font_color", Color.WHITE)
	$SceneBG.texture = _bg_cache.get(world, null)
	if _completion_lbl:
		_completion_lbl.text = _completion_text(world)
	_refresh_v2()

# ── Completion % ──────────────────────────────────────
func _count_done(world: String) -> int:
	var done: int = 0
	for key in GameManager.completed_lessons.keys():
		if str(key).begins_with(world + "_"):
			done += 1
	return done

func _completion_text(world: String) -> String:
	var done: int = _count_done(world)
	var pct: int = int(round(float(done) / float(LESSONS_PER_WORLD) * 100.0))
	return "★  %d / %d lessons  ·  %d%% complete" % [done, LESSONS_PER_WORLD, pct]

func _update_tts_button() -> void:
	_tts_slider.value = GameManager.tts_volume

func _update_music_button() -> void:
	_music_slider.value = GameManager.music_volume

func _update_dark_button() -> void:
	if _dark_btn:
		_dark_btn.text = "Dark Mode: ON" if GameManager.dark_overlay_enabled else "Dark Mode: OFF"

func _load_texture(res_path: String) -> Texture2D:
	if ResourceLoader.exists(res_path):
		var tex := ResourceLoader.load(res_path) as Texture2D
		if tex:
			return tex
	var abs_path: String = ProjectSettings.globalize_path(res_path)
	var fa := FileAccess.open(abs_path, FileAccess.READ)
	if fa:
		var data: PackedByteArray = fa.get_buffer(fa.get_length())
		fa.close()
		var img := Image.new()
		if img.load_png_from_buffer(data) == OK:
			if img.get_format() != Image.FORMAT_RGBA8:
				img.convert(Image.FORMAT_RGBA8)
			return ImageTexture.create_from_image(img)
	var img2 := Image.new()
	if img2.load(abs_path) == OK:
		if img2.get_format() != Image.FORMAT_RGBA8:
			img2.convert(Image.FORMAT_RGBA8)
		return ImageTexture.create_from_image(img2)
	return null

# ── Buttons (comic look, from ComicStyle) ─────────────
# primary   | yellow, inked outline  (main CTAs)
# secondary | cream paper            (nav / toggles)
# info      | blue                   (world arrows)
# danger    | red                    (destructive)
# ghost     | text only              (cancel / close)
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 18) -> void:
	var pad_h: int = 28 if variant == "primary" else 20
	var pad_v: int = 12 if variant == "primary" else 8
	Comic.apply_button(btn, variant, font_size, variant != "ghost", pad_h, pad_v)

func _style_settings_btn(btn: Button) -> void:
	btn.text = "SETTINGS"
	btn.offset_left = -170.0
	btn.offset_right = -14.0
	btn.offset_top = 14.0
	btn.offset_bottom = 62.0
	Comic.apply_button(btn, "dark", 26, true, 16, 6)

# ═══════════════════════════════════════════════════════
#  COMIC V2 LOOK (decoration only)
# ═══════════════════════════════════════════════════════
var _v2_logo: Control = null
var _v2_world_tag: Label = null
var _v2_count_tag: Label = null
var _v2_bar: ProgressBar = null
var _v2_bar_lbl: Label = null

func _apply_v2() -> void:
	var at: int = $Title.get_index()
	var decor: Array = []

	$DarkOverlay.color = Color(1.0, 0.96, 0.84, 0.32)

	var lines := Fx.SpeedLines.new()
	lines.set_anchors_preset(Control.PRESET_FULL_RECT)
	lines.center = Vector2(0.5, 0.46)
	decor.append(lines)
	decor.append(Fx.dots_rect(Color(0.18, 0.55, 0.92, 0.45), Vector2(0.0, 1.0), 0.38))
	decor.append(Fx.dots_rect(Color(0.90, 0.25, 0.18, 0.40), Vector2(1.0, 0.0), 0.32))

	# "Chapter select" caption box, top-left
	var cap := PanelContainer.new()
	var cap_s := Comic.box(Comic.YELLOW, Comic.INK, 4, 2, 6, 16, 10)
	cap.add_theme_stylebox_override("panel", cap_s)
	cap.position = Vector2(28, 24)
	cap.custom_minimum_size = Vector2(350, 0)
	cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var cap_box := VBoxContainer.new()
	cap_box.add_theme_constant_override("separation", 2)
	cap.add_child(cap_box)
	var cap_head := Label.new()
	cap_head.text = $Title.text
	Comic.heading(cap_head, 22, Comic.RED)
	cap_box.add_child(cap_head)
	var cap_text := Label.new()
	cap_text.text = "Pick a world, rookie: every world is a new SQL case to crack!"
	cap_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cap_text.custom_minimum_size = Vector2(318, 0)
	Comic.body(cap_text, 18, Comic.INK)
	cap_box.add_child(cap_text)
	decor.append(cap)
	$Title.visible = false

	# Burst + 3D world name in the middle
	var burst := Fx.Burst.new()
	Fx.place_centered(burst, Rect2(250, 186, 780, 290))
	burst.spikes = 24
	burst.inner = 0.84
	burst.seed_value = 4
	burst.shadow = 10.0
	decor.append(burst)

	var logo := Fx.Logo.new()
	Fx.place_centered(logo, Rect2(270, 236, 740, 180))
	logo.pivot_offset = Vector2(370, 90)
	logo.rotation_degrees = -3.0
	logo.font_size = 104
	logo.depth = 10
	logo.outline = 14
	decor.append(logo)
	_v2_logo = logo
	$WorldName.self_modulate = Color(1, 1, 1, 0)

	_v2_world_tag = Label.new()
	_v2_world_tag.anchor_left = 0.5
	_v2_world_tag.anchor_right = 0.5
	_v2_world_tag.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_v2_world_tag.anchor_top = 0.5
	_v2_world_tag.anchor_bottom = 0.5
	_v2_world_tag.offset_top = 164.0 - 360.0
	_v2_world_tag.offset_bottom = 164.0 - 360.0
	Fx.tag(_v2_world_tag, Comic.INK, Color.WHITE, 22)
	decor.append(_v2_world_tag)

	# Progress: lessons tag + chunky meter
	_v2_count_tag = Label.new()
	Fx.place_centered(_v2_count_tag, Rect2(372, 484, 0, 0))
	Fx.tag(_v2_count_tag, Comic.PAPER_HI, Comic.INK, 24)
	decor.append(_v2_count_tag)

	_v2_bar = ProgressBar.new()
	_v2_bar.show_percentage = false
	Fx.place_centered(_v2_bar, Rect2(592, 488, 310, 38))
	_v2_bar.max_value = 1.0
	var bar_bg := Comic.box(Comic.PAPER_HI, Comic.INK, 4, 18, 4, 0, 0)
	var bar_fill := Comic.box(Comic.YELLOW, Comic.INK, 4, 18, 0, 0, 0)
	_v2_bar.add_theme_stylebox_override("background", bar_bg)
	_v2_bar.add_theme_stylebox_override("fill", bar_fill)
	_v2_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_v2_bar_lbl = Label.new()
	_v2_bar_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	_v2_bar_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_v2_bar_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	Comic.heading(_v2_bar_lbl, 23, Comic.INK)
	_v2_bar.add_child(_v2_bar_lbl)
	decor.append(_v2_bar)
	if _completion_lbl:
		_completion_lbl.visible = false

	for i in decor.size():
		add_child(decor[i])
		move_child(decor[i], at + i)
	Fx.tilt(cap, -2.0)
	Fx.tilt(_v2_world_tag, -3.0)
	Fx.tilt(_v2_count_tag, -2.0)

	# Round blue arrow buttons
	for pair in [[$UpButton, -508.0, "◀", -6.0], [$DownButton, 418.0, "▶", 6.0]]:
		var b: Button = pair[0]
		b.offset_left = pair[1]
		b.offset_right = pair[1] + 90.0
		b.anchor_top = 0.5
		b.anchor_bottom = 0.5
		b.offset_top = 284.0 - 360.0
		b.offset_bottom = 374.0 - 360.0
		b.text = pair[2]
		Comic.apply_button(b, "info", 36, false, 0, 0)
		for st in ["normal", "hover", "pressed", "hover_pressed", "focus"]:
			var sb = b.get_theme_stylebox(st)
			if sb is StyleBoxFlat:
				var c: StyleBoxFlat = sb.duplicate()
				c.set_corner_radius_all(45)
				if st != "focus":
					c.set_border_width_all(5)
					c.shadow_offset = Vector2(6, 6) if not st.contains("pressed") else Vector2(2, 2)
				b.add_theme_stylebox_override(st, c)
		Fx.tilt(b, pair[3])

	# Enter World: the hero button, with a GO! sticker
	var enter: Button = $EnterButton
	Fx.place_centered(enter, Rect2(410, 548, 460, 86))
	enter.text = "Enter World!  →"
	Fx.hero_button(enter, "primary", 50, 30, 6)
	Fx.tilt(enter, -1.5)
	var go := Fx.sticker("GO!", "", Comic.RED, Color.WHITE, Vector2(110, 100), 34, 12, 12.0)
	Fx.place_centered(go, Rect2(820, 512, 110, 100))
	add_child(go)
	move_child(go, enter.get_index() + 1)

	var exit_btn: Button = $ExitButton
	Fx.place_centered(exit_btn, Rect2(540, 652, 200, 50))
	Comic.apply_button(exit_btn, "secondary", 26, true, 16, 4)

	# Settings: ink pill with a red print shadow
	var sbtn: Button = $SettingsButton
	sbtn.offset_left = -196.0
	sbtn.offset_right = -24.0
	sbtn.offset_top = 22.0
	sbtn.offset_bottom = 70.0
	Comic.apply_button(sbtn, "dark", 26, true, 18, 4)
	for st in ["normal", "hover", "pressed", "hover_pressed"]:
		var sb2 = sbtn.get_theme_stylebox(st)
		if sb2 is StyleBoxFlat:
			var c2: StyleBoxFlat = sb2.duplicate()
			c2.set_corner_radius_all(24)
			c2.shadow_color = Comic.RED
			c2.shadow_offset = Vector2(5, 5) if not st.contains("pressed") else Vector2(2, 2)
			sbtn.add_theme_stylebox_override(st, c2)
	Fx.tilt(sbtn, 2.0)

func _refresh_v2() -> void:
	if _v2_logo == null:
		return
	var world: String = WORLDS[_index]
	_v2_logo.text = WORLD_NAMES[world].to_upper()
	_v2_world_tag.text = "WORLD %d OF %d" % [_index + 1, WORLDS.size()]
	var done: int = _count_done(world)
	var ratio: float = float(done) / float(LESSONS_PER_WORLD)
	_v2_count_tag.text = "★ %d / %d LESSONS" % [done, LESSONS_PER_WORLD]
	_v2_bar.value = ratio
	_v2_bar_lbl.text = "%d%% COMPLETE" % int(round(ratio * 100.0))
	# A 0% fill would still draw its rounded ink ends, so hide it until there is progress
	_v2_bar.get_theme_stylebox("fill").draw_center = ratio > 0.0
	_v2_bar.get_theme_stylebox("fill").border_color = Comic.INK if ratio > 0.0 else Color(0, 0, 0, 0)
