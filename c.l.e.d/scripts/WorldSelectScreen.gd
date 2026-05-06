extends Control
# ═══════════════════════════════════════════════════════
#  WORLD SELECT SCREEN  —  scripts/WorldSelectScreen.gd
#
#  Carousel-style world picker.
#  ▲ / ▼ cycle through worlds — background changes live.
#  "Enter World" confirms and goes to Dashboard.
# ═══════════════════════════════════════════════════════

const WORLDS: Array = ["hotel", "cafe", "police", "library"]

const WORLD_NAMES: Dictionary = {
	"hotel":   "Hotel World",
	"cafe":    "Cafe World",
	"police":  "Police Station",
	"library": "Library",
}

const WORLD_BGS: Dictionary = {
	"hotel":   "res://images/backgrounds/BG_hotel.png",
	"cafe":    "res://images/backgrounds/BG_cafe.png",
	"police":  "res://images/backgrounds/BG_police.png",
	"library": "res://images/backgrounds/BG_library.png",
}

# Cache loaded textures so arrow presses are instant
var _bg_cache: Dictionary = {}
var _index: int = 0

func _ready() -> void:
	$UpButton.pressed.connect(_on_up)
	$DownButton.pressed.connect(_on_down)
	$EnterButton.pressed.connect(_on_enter)
	$ExitButton.pressed.connect(_on_exit)

	# Style buttons — white bg, black border, black text
	_style_btn($UpButton,    18)
	_style_btn($DownButton,  18)
	_style_btn($EnterButton, 22)
	_style_btn($ExitButton,  18)

	# Style title
	$Title.add_theme_font_size_override("font_size", 28)
	$Title.add_theme_color_override("font_color", Color.WHITE)

	# Style world name
	$WorldName.add_theme_font_size_override("font_size", 42)
	$WorldName.add_theme_color_override("font_color", Color.WHITE)
	$WorldName.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$WorldName.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER

	# Pre-load all backgrounds in the background
	_preload_backgrounds()
	_update_display()

func _preload_backgrounds() -> void:
	for world in WORLDS:
		var path: String = WORLD_BGS[world]
		var tex := _load_texture(path)
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
	get_tree().quit()

func _update_display() -> void:
	var world: String = WORLDS[_index]
	$WorldName.text = WORLD_NAMES[world]
	if _bg_cache.has(world):
		$SceneBG.texture = _bg_cache[world]
	else:
		$SceneBG.texture = null

# ── Texture loader (same 3-method fallback as GameScreen) ──
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

# ── Button styling — white bg, black border, black text ──
func _style_btn(btn: Button, font_size: int) -> void:
	btn.add_theme_font_size_override("font_size", font_size)
	btn.add_theme_color_override("font_color", Color.BLACK)
	var s := StyleBoxFlat.new()
	s.bg_color     = Color.WHITE
	s.border_color = Color.BLACK
	s.set_border_width_all(2)
	s.set_corner_radius_all(8)
	s.content_margin_left   = 20
	s.content_margin_right  = 20
	s.content_margin_top    = 10
	s.content_margin_bottom = 10
	btn.add_theme_stylebox_override("normal", s)
	var h := s.duplicate() as StyleBoxFlat
	h.bg_color = Color("#F59E0B")  # yellow on hover
	h.border_color = Color("#B45309")
	btn.add_theme_stylebox_override("hover", h)
	var p := s.duplicate() as StyleBoxFlat
	p.bg_color = Color("#D97706")   # darker yellow on press
	p.border_color = Color("#92400E")
	btn.add_theme_stylebox_override("pressed", p)
