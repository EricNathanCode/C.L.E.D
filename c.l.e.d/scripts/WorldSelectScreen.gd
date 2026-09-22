extends Control
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
	_style_btn($UpButton,    "secondary", 20)
	_style_btn($DownButton,  "secondary", 20)
	_style_btn($EnterButton, "primary",   22)
	_style_btn($ExitButton,  "ghost",     15)
	_style_btn($SettingsOverlay/SettingsPanel/VBox/TitleRow/CloseButton, "ghost", 15)
	_music_label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.92))
	_tts_label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.92))
	_style_btn(_dark_btn,  "secondary", 15)
	_style_settings_btn($SettingsButton)

	# Title | small caps label
	$Title.add_theme_font_size_override("font_size", 13)
	$Title.add_theme_color_override("font_color", Color(0.65, 0.70, 0.80))
	$Title.add_theme_constant_override("outline_size", 1)
	$Title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))

	# World name | large hero text
	$WorldName.add_theme_font_size_override("font_size", 46)
	$WorldName.add_theme_color_override("font_color", Color.WHITE)
	$WorldName.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$WorldName.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	$WorldName.add_theme_constant_override("outline_size", 2)
	$WorldName.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))

	# Settings panel dark card
	_style_settings_panel()
	_style_exit_confirm_panel()

	var title_lbl := $SettingsOverlay/SettingsPanel/VBox/TitleRow/TitleLabel
	title_lbl.text = "Settings"
	title_lbl.add_theme_font_size_override("font_size", 17)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)

	# Reset Progress button | danger action, lives at the bottom of Settings
	$SettingsOverlay/SettingsPanel/VBox.add_child(HSeparator.new())
	_reset_btn = Button.new()
	_reset_btn.pressed.connect(_on_reset_pressed)
	$SettingsOverlay/SettingsPanel/VBox.add_child(_reset_btn)
	_style_btn(_reset_btn, "secondary", 15)
	_reset_btn.text = "Reset Progress"

	# Log Out | switches back to the Login Screen so another
	# student can sign in on the same PC
	$SettingsOverlay/SettingsPanel/VBox.add_child(HSeparator.new())
	_logout_btn = Button.new()
	_logout_btn.pressed.connect(_on_logout_pressed)
	$SettingsOverlay/SettingsPanel/VBox.add_child(_logout_btn)
	_style_btn(_logout_btn, "secondary", 15)
	_update_logout_button()

	# Completion % label under the world name
	_completion_lbl = Label.new()
	_completion_lbl.anchor_left = 0.0
	_completion_lbl.anchor_right = 1.0
	_completion_lbl.offset_top = 453.0
	_completion_lbl.offset_bottom = 485.0
	_completion_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_completion_lbl.add_theme_font_size_override("font_size", 16)
	_completion_lbl.add_theme_color_override("font_color", Color("#F59E0B"))
	_completion_lbl.add_theme_constant_override("outline_size", 2)
	_completion_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	add_child(_completion_lbl)

	# Refresh completion % whenever this screen becomes visible again
	visibility_changed.connect(func():
		if visible:
			_update_display()
			_update_logout_button()
	)

	_preload_backgrounds()
	_update_display()
	_update_tts_button()
	_update_music_button()
	_update_dark_button()

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
	_panel.add_theme_stylebox_override("panel", s)

func _style_exit_confirm_panel() -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.10, 0.12, 0.17, 0.98)
	s.border_color = Color(0.28, 0.33, 0.46)
	s.set_border_width_all(2)
	s.set_corner_radius_all(14)
	s.content_margin_left   = 22
	s.content_margin_right  = 22
	s.content_margin_top    = 20
	s.content_margin_bottom = 20
	$ExitConfirmOverlay/ConfirmPanel.add_theme_stylebox_override("panel", s)

	var title_lbl := $ExitConfirmOverlay/ConfirmPanel/VBox/TitleLabel
	title_lbl.add_theme_font_size_override("font_size", 18)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)

	var msg_lbl := $ExitConfirmOverlay/ConfirmPanel/VBox/MessageLabel
	msg_lbl.add_theme_font_size_override("font_size", 14)
	msg_lbl.add_theme_color_override("font_color", Color(0.70, 0.74, 0.82))

	_style_btn($ExitConfirmOverlay/ConfirmPanel/VBox/LogoutExitButton,    "secondary", 15)
	_style_btn($ExitConfirmOverlay/ConfirmPanel/VBox/StaySignedInButton, "primary",   15)
	_style_btn($ExitConfirmOverlay/ConfirmPanel/VBox/CancelButton,       "ghost",     14)

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

# ── 3-variant button style ────────────────────────────
# primary   | amber fill, dark text  (main CTAs)
# secondary | dark panel, light text (nav / toggles)
# ghost     | transparent, dim border (exit / close)
func _style_btn(btn: Button, variant: String = "primary", font_size: int = 18) -> void:
	btn.add_theme_font_size_override("font_size", font_size)
	var s := StyleBoxFlat.new()
	s.set_corner_radius_all(8)

	match variant:
		"primary":
			btn.add_theme_color_override("font_color", Color(0.10, 0.06, 0.00))
			s.bg_color     = Color("#F59E0B")
			s.border_color = Color("#D97706")
			s.set_border_width_all(0)
			s.content_margin_left   = 28; s.content_margin_right  = 28
			s.content_margin_top    = 12; s.content_margin_bottom = 12
		"secondary":
			btn.add_theme_color_override("font_color", Color(0.88, 0.90, 0.95))
			s.bg_color     = Color(0.13, 0.15, 0.21, 0.95)
			s.border_color = Color(0.30, 0.35, 0.46)
			s.set_border_width_all(2)
			s.content_margin_left   = 20; s.content_margin_right  = 20
			s.content_margin_top    = 10; s.content_margin_bottom = 10
		"ghost":
			btn.add_theme_color_override("font_color", Color(0.55, 0.60, 0.70))
			s.bg_color     = Color(0, 0, 0, 0)
			s.border_color = Color(0.32, 0.37, 0.48)
			s.set_border_width_all(2)
			s.content_margin_left   = 20; s.content_margin_right  = 20
			s.content_margin_top    = 10; s.content_margin_bottom = 10

	var h := s.duplicate() as StyleBoxFlat
	var p := s.duplicate() as StyleBoxFlat

	match variant:
		"primary":
			h.bg_color = Color("#FBBF24")
			p.bg_color = Color("#D97706")
		"secondary":
			h.bg_color     = Color(0.20, 0.23, 0.32, 0.95)
			h.border_color = Color("#F59E0B")
			p.bg_color     = Color(0.09, 0.11, 0.16, 0.95)
		"ghost":
			h.bg_color     = Color(0.14, 0.17, 0.23, 0.50)
			h.border_color = Color(0.55, 0.60, 0.72)
			p.bg_color     = Color(0.09, 0.11, 0.16, 0.50)

	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", p)

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
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color     = Color(0.18, 0.21, 0.30, 0.95)
	h.border_color = Color("#F59E0B")
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color(0.08, 0.10, 0.15, 0.95)
	btn.add_theme_stylebox_override("pressed", p)
