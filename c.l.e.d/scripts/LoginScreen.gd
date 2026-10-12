extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
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
	_dark_toggle.text = "🌙  Dark Mode: ON" if GameManager.dark_overlay_enabled else "🌙  Dark Mode: OFF"

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
