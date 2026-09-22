extends Control
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
	_music_label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.92))
	_tts_label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.92))
	_style_btn(_dark_toggle,  "secondary")

	_password_input.secret = true
	_confirm_input.secret  = true

	_username_input.text_submitted.connect(func(_t): _on_submit())
	_password_input.text_submitted.connect(func(_t): _on_submit())
	_confirm_input.text_submitted.connect(func(_t): _on_submit())
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
	_dark_toggle.text = "🌙  Dark Mode: ON" if GameManager.dark_overlay_enabled else "🌙  Dark Mode: OFF"

# ── Styling (matches the rest of the app's dark/amber theme) ──
func _style_panel() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.10, 0.12, 0.17, 0.98)
	s.border_color = Color(0.28, 0.33, 0.46)
	s.set_border_width_all(2)
	s.set_corner_radius_all(14)
	s.content_margin_left   = 32
	s.content_margin_right  = 32
	s.content_margin_top    = 28
	s.content_margin_bottom = 28
	$CenterContainer/CardPanel.add_theme_stylebox_override("panel", s)

func _style_settings_panel() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.10, 0.12, 0.17, 0.98)
	s.border_color = Color(0.28, 0.33, 0.46)
	s.set_border_width_all(2)
	s.set_corner_radius_all(14)
	s.content_margin_left   = 22
	s.content_margin_right  = 22
	s.content_margin_top    = 20
	s.content_margin_bottom = 20
	$SettingsOverlay/SettingsPanel.add_theme_stylebox_override("panel", s)
	var title_lbl := $SettingsOverlay/SettingsPanel/VBox/TitleRow/TitleLabel
	title_lbl.add_theme_font_size_override("font_size", 17)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)
	_style_ghost($SettingsOverlay/SettingsPanel/VBox/TitleRow/CloseButton)

func _style_input(inp: LineEdit) -> void:
	var ns := StyleBoxFlat.new()
	ns.bg_color = Color(0.04, 0.07, 0.13, 1.0)
	ns.border_color = Color(1.0, 0.78, 0.0)
	ns.border_width_bottom = 2
	ns.content_margin_left = 10; ns.content_margin_right  = 10
	ns.content_margin_top  = 8;  ns.content_margin_bottom = 8
	inp.add_theme_stylebox_override("normal", ns)
	var fs := ns.duplicate() as StyleBoxFlat
	fs.border_width_bottom = 3
	inp.add_theme_stylebox_override("focus", fs)
	inp.add_theme_color_override("font_color", Color(1.0, 0.78, 0.0))
	inp.add_theme_color_override("font_placeholder_color", Color(1.0, 0.78, 0.0, 0.35))

func _style_eye_btn(btn: Button) -> void:
	btn.custom_minimum_size = Vector2(58, 0)
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", Color(1.0, 0.78, 0.0))
	# Sits flush against the LineEdit to its left, so no left border/margin —
	# reads as one continuous field with a "Show/Hide" tab on the end.
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.04, 0.07, 0.13, 1.0)
	s.border_color = Color(1.0, 0.78, 0.0)
	s.border_width_bottom = 2
	s.content_margin_left  = 4
	s.content_margin_right = 4
	btn.add_theme_stylebox_override("normal",  s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color = Color(0.07, 0.11, 0.19, 1.0)
	btn.add_theme_stylebox_override("hover",   h)
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color(0.02, 0.04, 0.08, 1.0)
	btn.add_theme_stylebox_override("pressed", p)
	btn.add_theme_stylebox_override("focus",   s)

func _style_primary(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 16)
	btn.add_theme_color_override("font_color", Color(0.10, 0.06, 0.00))
	var s := StyleBoxFlat.new()
	s.bg_color = Color("#F59E0B")
	s.set_corner_radius_all(8)
	s.content_margin_left   = 20; s.content_margin_right  = 20
	s.content_margin_top    = 10; s.content_margin_bottom = 10
	var h := s.duplicate() as StyleBoxFlat; h.bg_color = Color("#FBBF24")
	var p := s.duplicate() as StyleBoxFlat; p.bg_color = Color("#D97706")
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)

func _style_ghost(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", Color(0.55, 0.60, 0.70))
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0, 0, 0, 0)
	s.border_color = Color(0.30, 0.35, 0.46)
	s.set_border_width_all(0)
	s.content_margin_top    = 6
	s.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)

func _style_settings_btn(btn: Button) -> void:
	btn.add_theme_font_size_override("font_size", 20)
	btn.add_theme_color_override("font_color", Color(0.82, 0.86, 0.93))
	var s := StyleBoxFlat.new()
	s.bg_color     = Color(0.10, 0.12, 0.18, 0.88)
	s.border_color = Color(0.28, 0.33, 0.45)
	s.set_border_width_all(2)
	s.set_corner_radius_all(8)
	s.content_margin_left   = 10; s.content_margin_right  = 10
	s.content_margin_top    = 10; s.content_margin_bottom = 10
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.18, 0.21, 0.30, 0.95)
	h.border_color = Color("#F59E0B")
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color(0.08, 0.10, 0.15, 0.95)
	btn.add_theme_stylebox_override("normal", s)
	btn.add_theme_stylebox_override("hover",  h)
	btn.add_theme_stylebox_override("pressed", p)

func _style_btn(btn: Button, variant: String = "secondary") -> void:
	btn.add_theme_font_size_override("font_size", 15)
	var s := StyleBoxFlat.new()
	s.set_corner_radius_all(8)
	btn.add_theme_color_override("font_color", Color(0.88, 0.90, 0.95))
	s.bg_color     = Color(0.13, 0.15, 0.21, 0.95)
	s.border_color = Color(0.30, 0.35, 0.46)
	s.set_border_width_all(2)
	s.content_margin_left   = 20; s.content_margin_right  = 20
	s.content_margin_top    = 10; s.content_margin_bottom = 10
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.20, 0.23, 0.32, 0.95)
	h.border_color = Color("#F59E0B")
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color(0.09, 0.11, 0.16, 0.95)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)
