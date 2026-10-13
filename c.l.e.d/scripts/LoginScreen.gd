extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
# ═══════════════════════════════════════════════════════
#  LOGIN SCREEN  |  scripts/LoginScreen.gd
#
#  Per-user local profiles. Each username gets its own save
#  file under user://saves/<username>.cfg. Credentials are
#  stored in plain text in user://accounts.cfg — this is an
#  offline single-PC game with no server, so there is no real
#  authentication security here, just per-user save separation.
# ═══════════════════════════════════════════════════════

const USERNAME_REGEX_PATTERN := "^[A-Za-z0-9_]{3,20}$"

@onready var _username_input:  LineEdit = $CenterContainer/CardPanel/VBox/UsernameInput
@onready var _password_input:  LineEdit = $CenterContainer/CardPanel/VBox/PasswordRow/PasswordInput
@onready var _password_toggle: Button   = $CenterContainer/CardPanel/VBox/PasswordRow/PasswordToggleBtn
@onready var _confirm_row:     HBoxContainer = $CenterContainer/CardPanel/VBox/ConfirmPasswordRow
@onready var _confirm_input:   LineEdit = $CenterContainer/CardPanel/VBox/ConfirmPasswordRow/ConfirmPasswordInput
@onready var _confirm_toggle:  Button   = $CenterContainer/CardPanel/VBox/ConfirmPasswordRow/ConfirmPasswordToggleBtn
@onready var _error_label:     Label    = $CenterContainer/CardPanel/VBox/ErrorLabel
@onready var _subtitle_label:  Label    = $CenterContainer/CardPanel/VBox/SubtitleLabel
@onready var _submit_button:   Button   = $CenterContainer/CardPanel/VBox/SubmitButton
@onready var _toggle_button:   Button   = $CenterContainer/CardPanel/VBox/ToggleModeButton
@onready var _exit_button:     Button   = $CenterContainer/CardPanel/VBox/ExitButton

@onready var _settings_button: Button = $SettingsButton
@onready var _music_toggle:    HSlider = $SettingsOverlay/SettingsPanel/VBox/MusicRow/MusicToggle
@onready var _tts_toggle:      HSlider = $SettingsOverlay/SettingsPanel/VBox/TTSRow/TTSToggle
@onready var _music_label:     Label   = $SettingsOverlay/SettingsPanel/VBox/MusicRow/MusicLabel
@onready var _tts_label:       Label   = $SettingsOverlay/SettingsPanel/VBox/TTSRow/TTSLabel
@onready var _sfx_toggle:      HSlider = $SettingsOverlay/SettingsPanel/VBox/SFXRow/SFXToggle
@onready var _sfx_label:       Label   = $SettingsOverlay/SettingsPanel/VBox/SFXRow/SFXLabel
@onready var _dark_toggle:     Button = $SettingsOverlay/SettingsPanel/VBox/DarkToggle

var _username_regex := RegEx.new()
var _mode: String = "login"   # "login" or "signup"

const SHOW_LABEL := "Show"  # shown when the field is hidden — click to reveal
const HIDE_LABEL := "Hide"  # shown when the field is visible — click to hide it again

func _ready() -> void:
	_username_regex.compile(USERNAME_REGEX_PATTERN)

	_style_panel()
	_style_input(_username_input)
	_style_input(_password_input)
	_style_input(_confirm_input)
	_style_primary(_submit_button)
	_style_ghost(_toggle_button)
	_style_ghost(_exit_button)
	_style_eye_btn(_password_toggle)
	_style_eye_btn(_confirm_toggle)
	_style_settings_btn(_settings_button)
	_style_settings_panel()
	_style_btn(_dark_toggle,  "secondary")
	Fx.set_icon(_dark_toggle, "moon", 24)
	_apply_v2()

	_password_input.secret = true
	_confirm_input.secret  = true

	_username_input.text_submitted.connect(func(_t): GameManager.play_click(); _on_submit())
	_password_input.text_submitted.connect(func(_t): GameManager.play_click(); _on_submit())
	_confirm_input.text_submitted.connect(func(_t): GameManager.play_click(); _on_submit())
	_submit_button.pressed.connect(_on_submit)
	_toggle_button.pressed.connect(_on_toggle_mode)
	_exit_button.pressed.connect(_on_exit)

	_password_toggle.pressed.connect(func(): _toggle_secret(_password_input, _password_toggle))
	_confirm_toggle.pressed.connect(func(): _toggle_secret(_confirm_input, _confirm_toggle))

	_settings_button.pressed.connect(_on_settings_open)
	$SettingsOverlay/DimBG.gui_input.connect(_on_dim_input)
	$SettingsOverlay/SettingsPanel/VBox/TitleRow/CloseButton.pressed.connect(_on_settings_close)
	_music_toggle.value_changed.connect(_on_music_changed)
	_tts_toggle.value_changed.connect(_on_tts_changed)
	_sfx_toggle.value = GameManager.sfx_volume
	_sfx_toggle.value_changed.connect(_on_sfx_changed)
	_sfx_toggle.drag_ended.connect(func(_changed): GameManager.play_click_preview())
	_dark_toggle.pressed.connect(_on_dark_toggle)

	_update_music_button()
	_update_tts_button()
	_update_dark_button()

	_set_mode("login")

func _set_mode(mode: String) -> void:
	_mode = mode
	_error_label.visible = false
	_username_input.text = ""
	_password_input.text = ""
	_confirm_input.text  = ""

	if _mode == "login":
		_subtitle_label.text   = "Log in to continue"
		_confirm_row.visible   = false
		_submit_button.text    = "Log In"
		_toggle_button.text    = "Need an account?  Sign Up"
	else:
		_subtitle_label.text   = "Create a new account"
		_confirm_row.visible   = true
		_submit_button.text    = "Create Account"
		_toggle_button.text    = "Already have an account?  Log In"

	_username_input.grab_focus()

func _on_toggle_mode() -> void:
	_set_mode("signup" if _mode == "login" else "login")

func _on_exit() -> void:
	get_tree().quit()

# ── Password visibility ───────────────────────────────
func _toggle_secret(inp: LineEdit, btn: Button) -> void:
	inp.secret  = not inp.secret
	btn.text    = SHOW_LABEL if inp.secret else HIDE_LABEL
	inp.grab_focus()
	inp.caret_column = inp.text.length()

# ── Login / Sign Up ────────────────────────────────────
func _on_submit() -> void:
	var username: String = _username_input.text.strip_edges()
	var password: String = _password_input.text

	if not _username_regex.search(username):
		_show_error("Username must be 3-20 letters, numbers, or underscores.")
		return
	if password.is_empty():
		_show_error("Password cannot be empty.")
		return

	if _mode == "signup":
		var confirm: String = _confirm_input.text
		if password != confirm:
			_show_error("Passwords do not match.")
			return
		if GameManager.account_exists(username):
			_show_error("That username is already taken.")
			return
		GameManager.create_account(username, password)
		GameManager.login(username)
		_enter_app()
	else:
		if not GameManager.account_exists(username):
			_show_error("No account found with that username.")
			return
		if not GameManager.check_password(username, password):
			_show_error("Incorrect password.")
			return
		GameManager.login(username)
		_enter_app()

func _enter_app() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")

func _show_error(msg: String) -> void:
	_error_label.text    = msg
	_error_label.visible = true

# ── Settings overlay (music / TTS / dark mode) ────────
# Available before login since these are global, per-PC settings,
# not tied to any one account.
func _on_settings_open() -> void:
	$SettingsOverlay.visible = true

func _on_settings_close() -> void:
	$SettingsOverlay.visible = false

func _on_dim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_settings_close()

func _on_music_changed(value: float) -> void:
	get_tree().root.get_node("Main").set_music_volume(value)

func _on_tts_changed(value: float) -> void:
	GameManager.tts_volume = value
	if not GameManager.tts_enabled:
		GameManager.stop_speaking()
	GameManager.save_settings()

func _on_sfx_changed(value: float) -> void:
	GameManager.sfx_volume = value
	GameManager.save_settings()

func _on_dark_toggle() -> void:
	GameManager.dark_overlay_enabled = not GameManager.dark_overlay_enabled
	get_tree().root.get_node("Main").apply_dark_overlay()
	_update_dark_button()
	GameManager.save_settings()

func _update_music_button() -> void:
	_music_toggle.value = GameManager.music_volume

func _update_tts_button() -> void:
	_tts_toggle.value = GameManager.tts_volume

func _update_dark_button() -> void:
	_dark_toggle.text = "Dark Mode: ON" if GameManager.dark_overlay_enabled else "Dark Mode: OFF"

# ── Styling (comic look, from ComicStyle) ─────────────
func _style_panel() -> void:
	Comic.apply_halftone($FullBG)
	Comic.apply_panel($CenterContainer/CardPanel, Comic.PAPER_HI, 18, 9, 34, 28, 4)
	$CenterContainer/CardPanel/VBox/PasswordRow.add_theme_constant_override("separation", 8)
	$CenterContainer/CardPanel/VBox/ConfirmPasswordRow.add_theme_constant_override("separation", 8)
	Comic.title($CenterContainer/CardPanel/VBox/TitleLabel, 60, Comic.YELLOW, 10)
	Comic.heading(_subtitle_label, 26)
	Comic.body(_error_label, 17, Comic.RED)

func _style_settings_panel() -> void:
	Comic.apply_dim($SettingsOverlay/DimBG)
	Comic.apply_settings_panel(
		$SettingsOverlay/SettingsPanel,
		$SettingsOverlay/SettingsPanel/VBox/TitleRow/TitleLabel,
		$SettingsOverlay/SettingsPanel/VBox/TitleRow/CloseButton,
		[_music_label, _tts_label, _sfx_label])
	var gear := Fx.icon_rect("gear", 32)
	var title_row: Node = $SettingsOverlay/SettingsPanel/VBox/TitleRow
	title_row.add_child(gear)
	title_row.move_child(gear, 0)

func _style_input(inp: LineEdit) -> void:
	Comic.apply_input(inp, 19)

func _style_eye_btn(btn: Button) -> void:
	btn.custom_minimum_size = Vector2(72, 0)
	Comic.apply_button(btn, "secondary", 15, false, 8, 8)

func _style_primary(btn: Button) -> void:
	Comic.apply_button(btn, "primary", 28, true, 20, 10)

func _style_ghost(btn: Button) -> void:
	Comic.apply_button(btn, "ghost", 17, false, 10, 6)

func _style_settings_btn(btn: Button) -> void:
	btn.text = "SETTINGS"
	btn.offset_left = -170.0
	btn.offset_right = -14.0
	btn.offset_top = 14.0
	btn.offset_bottom = 62.0
	Comic.apply_button(btn, "dark", 26, true, 16, 6)

func _style_btn(btn: Button, variant: String = "secondary") -> void:
	Comic.apply_button(btn, variant, 19, true, 18, 9)

# ═══════════════════════════════════════════════════════
#  COMIC V2 LOOK (decoration only): cover-page rays, 3D logo,
#  a host character greeting the player, sticker buttons.
# ═══════════════════════════════════════════════════════
func _apply_v2() -> void:
	var rays := Fx.rays_rect(Color("#FFD85A"), Color("#FFC21A"), Color(0.9, 0.25, 0.18, 0.42), Vector2(0.5, 0.5))
	$FullBG.material = rays.material
	rays.free()

	var host := TextureRect.new()
	host.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	host.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var tex_path := "res://images/characters/NPC_adults/adult_1/talk.png"
	if ResourceLoader.exists(tex_path):
		host.texture = load(tex_path)
	Fx.place_right(host, Rect2(900, 40, 380, 800))
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(host)
	move_child(host, $FullBG.get_index() + 1)

	var bubble := Fx.Bubble.new()
	bubble.radius = 30
	bubble.outline = 4.0
	bubble.shadow = 5.0
	bubble.tail_width = 26.0
	bubble.tail_at = 0.32
	bubble.add_theme_constant_override("margin_left", 16)
	bubble.add_theme_constant_override("margin_right", 16)
	bubble.add_theme_constant_override("margin_top", 10)
	bubble.add_theme_constant_override("margin_bottom", 12)
	Fx.place_right(bubble, Rect2(846, 112, 0, 0))
	bubble.custom_minimum_size = Vector2(170, 0)
	var hello := Label.new()
	hello.text = "Welcome, rookie! Ready to crack some SQL?"
	hello.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hello.custom_minimum_size = Vector2(150, 0)
	Comic.body(hello, 17, Comic.INK)
	bubble.add_child(hello)
	add_child(bubble)
	move_child(bubble, host.get_index() + 1)
	bubble.tail_rel = Vector2(1.0, 0.62)
	bubble.tail_px = Vector2(46.0, 0.0)

	# 3D logo lettering for the title (the label keeps its text, just hidden)
	var title: Label = $CenterContainer/CardPanel/VBox/TitleLabel
	title.custom_minimum_size = Vector2(0, 104)
	title.self_modulate = Color(1, 1, 1, 0)
	var logo := Fx.Logo.new()
	logo.text = title.text
	logo.set_anchors_preset(Control.PRESET_FULL_RECT)
	logo.font_size = 92
	logo.depth = 9
	logo.outline = 13
	logo.rotation_degrees = -3.0
	title.add_child(logo)
	title.resized.connect(func(): logo.pivot_offset = logo.size / 2.0)

	Comic.apply_panel($CenterContainer/CardPanel, Comic.PAPER_HI, 18, 10, 34, 26, 5)
	Fx.hero_button(_submit_button, "primary", 32, 20, 4)

	# Settings: ink pill with a red print shadow
	var sbtn: Button = _settings_button
	sbtn.offset_left = -196.0
	sbtn.offset_right = -24.0
	sbtn.offset_top = 22.0
	sbtn.offset_bottom = 70.0
	Comic.apply_button(sbtn, "dark", 26, true, 18, 4)
	for st in ["normal", "hover", "pressed", "hover_pressed"]:
		var sb = sbtn.get_theme_stylebox(st)
		if sb is StyleBoxFlat:
			var c: StyleBoxFlat = sb.duplicate()
			c.set_corner_radius_all(24)
			c.shadow_color = Comic.RED
			c.shadow_offset = Vector2(5, 5) if not st.contains("pressed") else Vector2(2, 2)
			sbtn.add_theme_stylebox_override(st, c)
	Fx.tilt(sbtn, 2.0)
