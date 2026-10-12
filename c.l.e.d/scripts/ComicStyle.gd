extends RefCounted
# ═══════════════════════════════════════════════════════
#  COMIC STYLE  |  scripts/ComicStyle.gd
#  One shared look for the whole app: black ink outlines, cream paper,
#  comic yellow with red / blue accents, hard offset shadows, halftone dots.
#  Screens call these helpers instead of styling widgets one by one.
# ═══════════════════════════════════════════════════════

# ── Palette ───────────────────────────────────────────
const INK        := Color("#15110E")   # outlines, text, shadows
const INK_SOFT   := Color("#3A322B")
const PAPER      := Color("#FFF4D6")   # page / panels
const PAPER_HI   := Color("#FFFBEC")   # raised surfaces, inputs
const PAPER_DARK := Color("#EBD9AB")   # recessed / hover surfaces
const YELLOW     := Color("#FFC21A")   # signature accent
const YELLOW_HI  := Color("#FFD85A")
const YELLOW_LO  := Color("#E3A400")
const RED        := Color("#E5412D")
const RED_HI     := Color("#FF6A52")
const BLUE       := Color("#2F8DEB")
const BLUE_HI    := Color("#5BA9F5")
const GREEN      := Color("#2FB765")
const GREEN_HI   := Color("#58D184")
const GREY       := Color("#CFC6B0")
const GREY_TEXT  := Color("#8C8370")

const FONT_DISPLAY := "res://fonts/Bangers-Regular.ttf"
const FONT_BODY    := "res://fonts/ComicNeue-Bold.ttf"
const FONT_BODY_RG := "res://fonts/ComicNeue-Regular.ttf"

static var _fonts: Dictionary = {}

# ── Fonts ─────────────────────────────────────────────
static func _font(path: String, glyph_spacing: int = 0) -> Font:
	var key: String = path + "#" + str(glyph_spacing)
	if _fonts.has(key):
		return _fonts[key]
	var base = load(path)
	if base == null:
		return ThemeDB.fallback_font
	var f: Font = base
	if glyph_spacing != 0:
		var fv := FontVariation.new()
		fv.base_font = base
		fv.spacing_glyph = glyph_spacing
		f = fv
	_fonts[key] = f
	return f

static func display_font() -> Font:
	return _font(FONT_DISPLAY, 1)

static func body_font() -> Font:
	return _font(FONT_BODY)

static func body_regular_font() -> Font:
	return _font(FONT_BODY_RG)

# ── Building blocks ───────────────────────────────────
# A comic panel: thick ink outline, rounded corners, hard offset shadow.
static func box(bg: Color, border: Color = INK, border_w: int = 3, radius: int = 10,
		shadow: int = 0, pad_h: int = 16, pad_v: int = 12) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(border_w)
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad_h
	s.content_margin_right = pad_h
	s.content_margin_top = pad_v
	s.content_margin_bottom = pad_v
	if shadow > 0:
		s.shadow_color = INK
		s.shadow_size = 1
		s.shadow_offset = Vector2(shadow, shadow)
	s.anti_aliasing = true
	return s

static func apply_panel(ctrl: Control, bg: Color = PAPER, radius: int = 14, shadow: int = 6,
		pad_h: int = 22, pad_v: int = 20, border_w: int = 4) -> void:
	ctrl.add_theme_stylebox_override("panel", box(bg, INK, border_w, radius, shadow, pad_h, pad_v))

# ── Buttons ───────────────────────────────────────────
# variant: primary | secondary | ghost | danger | info | success | dark | quiz | locked
static func apply_button(btn: Button, variant: String = "secondary", font_size: int = 20,
		display: bool = true, pad_h: int = 18, pad_v: int = 9) -> void:
	var bg: Color; var hi: Color; var lo: Color; var fg: Color; var border: Color = INK
	var shadow: int = 4
	match variant:
		"primary":
			bg = YELLOW; hi = YELLOW_HI; lo = YELLOW_LO; fg = INK
		"danger":
			bg = RED; hi = RED_HI; lo = Color("#C23220"); fg = Color.WHITE
		"quiz":
			bg = RED; hi = RED_HI; lo = Color("#C23220"); fg = Color.WHITE
		"info":
			bg = BLUE; hi = BLUE_HI; lo = Color("#2273CC"); fg = Color.WHITE
		"success":
			bg = GREEN; hi = GREEN_HI; lo = Color("#239A52"); fg = INK
		"dark":
			bg = INK; hi = INK_SOFT; lo = Color.BLACK; fg = YELLOW; shadow = 3
		"ghost":
			bg = Color(0, 0, 0, 0); hi = PAPER_DARK; lo = Color("#DCC98F"); fg = INK; border = Color(0, 0, 0, 0); shadow = 0
		"locked":
			bg = GREY; hi = GREY; lo = GREY; fg = GREY_TEXT; border = Color("#9A917C"); shadow = 0
		_:
			bg = PAPER_HI; hi = Color("#FFF0B8"); lo = PAPER_DARK; fg = INK
	var bw: int = 0 if variant == "ghost" else 3
	var normal := box(bg, border, bw, 9, shadow, pad_h, pad_v)
	var hover := box(hi, border, bw, 9, shadow + 2 if shadow > 0 else 0, pad_h, pad_v)
	var pressed := box(lo, border, bw, 9, 1 if shadow > 0 else 0, pad_h, pad_v)
	if shadow > 0:
		pressed.content_margin_top = pad_v + 2
		pressed.content_margin_left = pad_h + 1
	var disabled := box(GREY, Color("#9A917C"), 3, 9, 0, pad_h, pad_v)
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_stylebox_override("hover_pressed", pressed)
	btn.add_theme_stylebox_override("disabled", disabled if variant != "locked" else normal)
	btn.add_theme_stylebox_override("focus", box(Color(0, 0, 0, 0), BLUE, 3, 11, 0, pad_h, pad_v))
	btn.add_theme_color_override("font_color", fg)
	btn.add_theme_color_override("font_hover_color", fg)
	btn.add_theme_color_override("font_pressed_color", fg)
	btn.add_theme_color_override("font_hover_pressed_color", fg)
	btn.add_theme_color_override("font_focus_color", fg)
	btn.add_theme_color_override("font_disabled_color", GREY_TEXT)
	btn.add_theme_font_size_override("font_size", font_size)
	btn.add_theme_font_override("font", display_font() if display else body_font())

# ── Text ──────────────────────────────────────────────
# Big comic title: display font, fill colour, thick ink outline, hard shadow.
static func title(lbl: Label, size: int = 40, fill: Color = YELLOW, outline: int = 8) -> void:
	lbl.add_theme_font_override("font", display_font())
	lbl.add_theme_font_size_override("font_size", size)
	lbl.add_theme_color_override("font_color", fill)
	lbl.add_theme_color_override("font_outline_color", INK)
	lbl.add_theme_constant_override("outline_size", outline)
	lbl.add_theme_color_override("font_shadow_color", INK)
	lbl.add_theme_constant_override("shadow_offset_x", 3)
	lbl.add_theme_constant_override("shadow_offset_y", 4)

# Plain heading in ink, display font (no outline).
static func heading(lbl: Label, size: int = 24, color: Color = INK) -> void:
	lbl.add_theme_font_override("font", display_font())
	lbl.add_theme_font_size_override("font_size", size)
	lbl.add_theme_color_override("font_color", color)

# Readable body copy.
static func body(lbl: Label, size: int = 16, color: Color = INK) -> void:
	lbl.add_theme_font_override("font", body_font())
	lbl.add_theme_font_size_override("font_size", size)
	lbl.add_theme_color_override("font_color", color)

# ── Inputs ────────────────────────────────────────────
static func apply_input(inp: LineEdit, size: int = 18) -> void:
	inp.add_theme_stylebox_override("normal", box(PAPER_HI, INK, 3, 8, 0, 12, 9))
	inp.add_theme_stylebox_override("focus", box(Color("#FFFFFF"), BLUE, 4, 8, 0, 12, 8))
	inp.add_theme_stylebox_override("read_only", box(PAPER_DARK, INK, 3, 8, 0, 12, 9))
	inp.add_theme_color_override("font_color", INK)
	inp.add_theme_color_override("font_placeholder_color", GREY_TEXT)
	inp.add_theme_color_override("caret_color", RED)
	inp.add_theme_color_override("selection_color", YELLOW)
	inp.add_theme_font_override("font", body_font())
	inp.add_theme_font_size_override("font_size", size)

# ── Backgrounds ───────────────────────────────────────
const HALFTONE_SHADER := """
shader_type canvas_item;
uniform vec4 base_color : source_color = vec4(1.0, 0.957, 0.839, 1.0);
uniform vec4 dot_color : source_color = vec4(0.922, 0.851, 0.671, 1.0);
uniform float cell = 16.0;
uniform float min_r = 0.05;
uniform float max_r = 0.40;
void fragment() {
	vec2 p = FRAGCOORD.xy;
	vec2 q = vec2(p.x + p.y, p.y - p.x) * 0.7071 / cell;   // 45 degree grid
	vec2 g = fract(q) - 0.5;
	float grad = clamp(UV.x * 0.55 + UV.y * 0.45, 0.0, 1.0);
	float r = mix(min_r, max_r, grad);
	float m = smoothstep(r, r - 0.10, length(g));
	COLOR = mix(base_color, dot_color, m);
}
"""

static func make_halftone(base: Color = PAPER, dot: Color = PAPER_DARK, cell: float = 16.0,
		min_r: float = 0.05, max_r: float = 0.40) -> ColorRect:
	var rect := ColorRect.new()
	rect.color = base
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = HALFTONE_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("base_color", base)
	mat.set_shader_parameter("dot_color", dot)
	mat.set_shader_parameter("cell", cell)
	mat.set_shader_parameter("min_r", min_r)
	mat.set_shader_parameter("max_r", max_r)
	rect.material = mat
	return rect

# ── Theme (default look for any widget a screen does not style itself) ──
static func _slider_grabber(fill: Color) -> ImageTexture:
	var size: int = 26
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var c: float = (size - 1) / 2.0
	for y in size:
		for x in size:
			var d: float = Vector2(x, y).distance_to(Vector2(c, c))
			if d <= 12.0 and d > 9.0:
				img.set_pixel(x, y, INK)
			elif d <= 9.0:
				img.set_pixel(x, y, fill)
	return ImageTexture.create_from_image(img)

static func build_theme() -> Theme:
	var t := Theme.new()
	t.default_font = body_font()
	t.default_font_size = 17
	t.set_color("font_color", "Label", INK)
	t.set_color("font_color", "CheckBox", INK)

	# Buttons nobody styled explicitly
	t.set_stylebox("normal", "Button", box(PAPER_HI, INK, 3, 9, 4, 16, 8))
	t.set_stylebox("hover", "Button", box(Color("#FFF0B8"), INK, 3, 9, 6, 16, 8))
	t.set_stylebox("pressed", "Button", box(PAPER_DARK, INK, 3, 9, 1, 17, 10))
	t.set_stylebox("disabled", "Button", box(GREY, Color("#9A917C"), 3, 9, 0, 16, 8))
	t.set_stylebox("focus", "Button", box(Color(0, 0, 0, 0), BLUE, 3, 11, 0, 16, 8))
	t.set_color("font_color", "Button", INK)
	t.set_color("font_hover_color", "Button", INK)
	t.set_color("font_pressed_color", "Button", INK)
	t.set_color("font_disabled_color", "Button", GREY_TEXT)
	t.set_font("font", "Button", display_font())
	t.set_font_size("font_size", "Button", 20)

	# Text inputs
	t.set_stylebox("normal", "LineEdit", box(PAPER_HI, INK, 3, 8, 0, 12, 9))
	t.set_stylebox("focus", "LineEdit", box(Color.WHITE, BLUE, 4, 8, 0, 12, 8))
	t.set_color("font_color", "LineEdit", INK)
	t.set_color("font_placeholder_color", "LineEdit", GREY_TEXT)
	t.set_color("caret_color", "LineEdit", RED)
	t.set_color("selection_color", "LineEdit", YELLOW)

	# Scroll bars: chunky ink track with a yellow thumb
	for sb in ["VScrollBar", "HScrollBar"]:
		t.set_stylebox("scroll", sb, box(PAPER_DARK, INK, 2, 7, 0, 7, 7))
		t.set_stylebox("scroll_focus", sb, box(PAPER_DARK, INK, 2, 7, 0, 7, 7))
		t.set_stylebox("grabber", sb, box(YELLOW, INK, 2, 7, 0, 7, 7))
		t.set_stylebox("grabber_highlight", sb, box(YELLOW_HI, INK, 2, 7, 0, 7, 7))
		t.set_stylebox("grabber_pressed", sb, box(YELLOW_LO, INK, 2, 7, 0, 7, 7))

	# Sliders: ink outlined track, yellow fill, round yellow grabber
	t.set_stylebox("slider", "HSlider", box(PAPER_DARK, INK, 3, 8, 0, 0, 5))
	t.set_stylebox("grabber_area", "HSlider", box(YELLOW, INK, 3, 8, 0, 0, 5))
	t.set_stylebox("grabber_area_highlight", "HSlider", box(YELLOW_HI, INK, 3, 8, 0, 0, 5))
	t.set_icon("grabber", "HSlider", _slider_grabber(YELLOW))
	t.set_icon("grabber_highlight", "HSlider", _slider_grabber(YELLOW_HI))
	t.set_icon("grabber_disabled", "HSlider", _slider_grabber(GREY))

	# Progress bars
	t.set_stylebox("background", "ProgressBar", box(PAPER_HI, INK, 3, 10, 0, 0, 0))
	t.set_stylebox("fill", "ProgressBar", box(YELLOW, INK, 3, 10, 0, 0, 0))

	# Tooltips
	t.set_stylebox("panel", "TooltipPanel", box(INK, INK, 2, 8, 0, 10, 6))
	t.set_color("font_color", "TooltipLabel", YELLOW)

	# Separators
	var line := StyleBoxLine.new()
	line.color = INK
	line.thickness = 3
	t.set_stylebox("separator", "HSeparator", line)
	t.set_constant("separation", "HSeparator", 10)
	return t

# ── Shared composites ─────────────────────────────────
# Turn an existing ColorRect into a halftone page background.
static func apply_halftone(rect: ColorRect, base: Color = PAPER, dot: Color = PAPER_DARK,
		cell: float = 16.0, min_r: float = 0.05, max_r: float = 0.40) -> void:
	rect.color = base
	var sh := Shader.new()
	sh.code = HALFTONE_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("base_color", base)
	mat.set_shader_parameter("dot_color", dot)
	mat.set_shader_parameter("cell", cell)
	mat.set_shader_parameter("min_r", min_r)
	mat.set_shader_parameter("max_r", max_r)
	rect.material = mat

# The dark veil behind pop-ups (warm ink instead of flat black).
static func apply_dim(rect: ColorRect, alpha: float = 0.62) -> void:
	rect.color = Color(0.08, 0.06, 0.04, alpha)

# Small square icon-style button (close "x", gear, ...).
static func apply_icon_button(btn: Button, variant: String = "danger", size: int = 22) -> void:
	apply_button(btn, variant, size, false, 10, 4)

# The Settings pop-up shared by the Login and World Select screens.
static func apply_settings_panel(panel: PanelContainer, title_lbl: Label, close_btn: Button, labels: Array) -> void:
	apply_panel(panel, PAPER, 16, 8, 26, 22, 4)
	heading(title_lbl, 30)
	apply_icon_button(close_btn, "danger", 22)
	for l in labels:
		body(l, 18)
