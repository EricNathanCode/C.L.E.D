extends RefCounted
# ═══════════════════════════════════════════════════════
#  COMIC FX  |  scripts/ComicFx.gd
#  Drawn comic pieces for the v2 look: burst stickers, 3D logo lettering,
#  speed lines, speech bubbles with tails, caution tape, stars, a film-strip
#  progress meter, double-shadow buttons and ray / dot backgrounds.
#  Everything here is decoration only; nothing touches game logic.
# ═══════════════════════════════════════════════════════

const Comic = preload("res://scripts/ComicStyle.gd")

const INK    := Color("#15110E")
const PAPER  := Color("#FFF4D6")
const YELLOW := Color("#FFC21A")
const RED    := Color("#E5412D")

# Draws a closed outline as thick lines with round joints (clean on sharp spikes).
static func stroke_loop(ci: CanvasItem, pts: PackedVector2Array, color: Color, width: float) -> void:
	var n: int = pts.size()
	for i in n:
		ci.draw_line(pts[i], pts[(i + 1) % n], color, width, true)
	for p in pts:
		ci.draw_circle(p, width * 0.5, color)

static func star_points(c: Vector2, r_out: float, r_in: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 10:
		var a: float = -PI / 2.0 + i * PI / 5.0
		var r: float = r_in if i % 2 == 1 else r_out
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	return pts

# Rotate a control about its centre. Inside a container the tilt is re-applied
# after every re-sort (containers reset rotation when they lay children out).
static func tilt(ctrl: Control, degrees: float) -> void:
	var apply := func():
		if not is_instance_valid(ctrl):
			return
		ctrl.pivot_offset = ctrl.size / 2.0
		ctrl.rotation_degrees = degrees
	ctrl.resized.connect(apply)
	var parent := ctrl.get_parent()
	if parent is Container:
		parent.sort_children.connect(apply)
		# Stop listening to the container once this control leaves it
		ctrl.tree_exiting.connect(func():
			if is_instance_valid(parent) and parent.sort_children.is_connected(apply):
				parent.sort_children.disconnect(apply)
		, CONNECT_ONE_SHOT)
	apply.call()

# A label drawn as a little sticker tag (ink outline + hard shadow).
static func tag(lbl: Label, bg: Color, fg: Color, size: int = 22, display: bool = true,
		shadow: Color = INK, pad_h: int = 14, pad_v: int = 3) -> void:
	var s := Comic.box(bg, INK, 4, 4, 0, pad_h, pad_v)
	s.shadow_color = shadow
	s.shadow_size = 1
	s.shadow_offset = Vector2(5, 5)
	lbl.add_theme_stylebox_override("normal", s)
	lbl.add_theme_font_override("font", Comic.display_font() if display else Comic.body_font())
	lbl.add_theme_font_size_override("font_size", size)
	lbl.add_theme_color_override("font_color", fg)

# Hard ink shadow on a button's states turned red (the "print offset" look).
static func red_shadow(btn: Button) -> void:
	for st in ["normal", "hover", "pressed", "hover_pressed"]:
		var sb = btn.get_theme_stylebox(st)
		if sb is StyleBoxFlat:
			var c: StyleBoxFlat = sb.duplicate()
			c.shadow_color = RED
			btn.add_theme_stylebox_override(st, c)

# Big "hero" button: ink shadow plus a second red print-offset shadow.
static func hero_button(btn: Button, variant: String = "primary", font_size: int = 40,
		pad_h: int = 30, pad_v: int = 10) -> void:
	Comic.apply_button(btn, variant, font_size, true, pad_h, pad_v)
	for st in ["normal", "hover", "pressed", "hover_pressed"]:
		var sb = btn.get_theme_stylebox(st)
		if not (sb is StyleBoxFlat):
			continue
		var front: StyleBoxFlat = sb.duplicate()
		front.set_border_width_all(5)
		front.set_corner_radius_all(14)
		var off: float = 2.0 if st.contains("pressed") else 8.0
		front.shadow_offset = Vector2(off, off)
		var dbl := DoubleShadowBox.new()
		dbl.front = front
		dbl.back = Comic.box(RED, RED, 0, 14, 0, 0, 0)
		dbl.back_offset = Vector2(off + 6.0, off + 6.0)
		dbl.content_margin_left = front.content_margin_left
		dbl.content_margin_right = front.content_margin_right
		dbl.content_margin_top = front.content_margin_top
		dbl.content_margin_bottom = front.content_margin_bottom
		btn.add_theme_stylebox_override(st, dbl)

class DoubleShadowBox extends StyleBox:
	var front: StyleBoxFlat
	var back: StyleBoxFlat
	var back_offset: Vector2 = Vector2(14, 14)
	func _draw(to_canvas_item: RID, rect: Rect2) -> void:
		if back:
			back.draw(to_canvas_item, Rect2(rect.position + back_offset, rect.size))
		if front:
			front.draw(to_canvas_item, rect)

# ── Spiky burst sticker ("POW!" shape) ────────────────
class Burst extends Control:
	var fill: Color = Color.WHITE
	var shadow_color: Color = Color("#15110E")
	var spikes: int = 20
	var inner: float = 0.8
	var seed_value: int = 5
	var shadow: float = 9.0
	var outline: float = 6.0

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _pts(c: Vector2, rx: float, ry: float) -> PackedVector2Array:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		var pts := PackedVector2Array()
		for i in spikes * 2:
			var a: float = TAU * i / float(spikes * 2) - PI / 2.0
			var k: float = inner * (0.94 + rng.randf() * 0.1) if i % 2 == 1 else 0.9 + rng.randf() * 0.1
			pts.append(c + Vector2(cos(a) * rx * k, sin(a) * ry * k))
		return pts

	func _draw() -> void:
		var rx: float = size.x / 2.0 - outline - shadow * 0.5
		var ry: float = size.y / 2.0 - outline - shadow * 0.5
		var c: Vector2 = size / 2.0 - Vector2(shadow, shadow) * 0.5
		if shadow > 0.0:
			draw_colored_polygon(_pts(c + Vector2(shadow, shadow), rx, ry), shadow_color)
		var p := _pts(c, rx, ry)
		draw_colored_polygon(p, fill)
		ComicFx_stroke(self, p, Color("#15110E"), outline)

	static func ComicFx_stroke(ci: CanvasItem, pts: PackedVector2Array, color: Color, width: float) -> void:
		var n: int = pts.size()
		for i in n:
			ci.draw_line(pts[i], pts[(i + 1) % n], color, width, true)
		for q in pts:
			ci.draw_circle(q, width * 0.5, color)

# ── 3D comic logo lettering ───────────────────────────
class Logo extends Control:
	var text: String = "":
		set(v):
			text = v
			queue_redraw()
	var font_size: int = 64
	var fill: Color = Color("#FFC21A")
	var extrude: Color = Color("#E5412D")
	var depth: int = 8
	var outline: int = 12
	var align_left: bool = false

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		if text.is_empty():
			return
		var f: Font = load("res://fonts/Bangers-Regular.ttf")
		var fs: int = font_size
		var w: float = f.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var room: float = size.x - outline - depth - 4.0
		if w > room and w > 0.0:
			fs = int(floor(fs * room / w))
			w = f.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var asc: float = f.get_ascent(fs)
		var desc: float = f.get_descent(fs)
		var x: float = outline * 0.5 + 2.0 if align_left else (size.x - w - depth) / 2.0
		var y: float = (size.y + asc - desc) / 2.0 - depth / 2.0
		var ink := Color("#15110E")
		for i in range(depth, -1, -1):
			var p := Vector2(x + i, y + i)
			draw_string_outline(f, p, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, outline, ink)
			draw_string(f, p, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, ink)
		for i in range(depth - 1, 0, -1):
			draw_string(f, Vector2(x + i, y + i), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, extrude)
		draw_string_outline(f, Vector2(x, y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 3, ink)
		draw_string(f, Vector2(x, y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, fill)

# ── Radiating action lines ────────────────────────────
class SpeedLines extends Control:
	var center: Vector2 = Vector2(0.5, 0.46)   # relative to size
	var count: int = 80
	var inner_r: float = 300.0
	var squash: float = 0.62
	var color: Color = Color(0.08, 0.07, 0.05, 0.12)
	var seed_value: int = 9

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		clip_contents = true

	func _draw() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		var c: Vector2 = size * center
		var far: float = size.length() * 1.2
		for i in count:
			var a: float = TAU * (i + rng.randf() * 0.7) / float(count)
			var w: float = 0.004 + rng.randf() * 0.012
			var rr: float = inner_r + rng.randf() * 140.0
			var pts := PackedVector2Array([
				c + Vector2(cos(a) * rr, sin(a) * rr * squash),
				c + Vector2(cos(a - w), sin(a - w)) * far,
				c + Vector2(cos(a + w), sin(a + w)) * far])
			draw_colored_polygon(pts, color)

# ── Speech bubble with a tail (draws behind its children) ──
# tail_tip is in this control's local coordinates. tail_side: right|left|bottom|top|none
class Bubble extends MarginContainer:
	var tail_tip: Vector2 = Vector2.ZERO:
		set(v):
			tail_tip = v
			queue_redraw()
	var tail_side: String = "right":
		set(v):
			tail_side = v
			queue_redraw()
	var tail_at: float = 0.2
	var tail_width: float = 48.0
	var radius: int = 60
	var outline: float = 5.0
	var shadow: float = 7.0
	var fill: Color = Color.WHITE:
		set(v):
			fill = v
			queue_redraw()
	var square: bool = false:
		set(v):
			square = v
			queue_redraw()
	# When set, the tail tip follows the bubble's size: tip = size * tail_rel + tail_px
	var tail_rel: Vector2 = Vector2(-1, -1)
	var tail_px: Vector2 = Vector2.ZERO

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Corner radius actually used: small enough that the tail always sits on a
	# straight stretch of the edge (never on a rounded corner).
	func _radius() -> float:
		var r: float = 6.0 if square else float(radius)
		var room: float = size.y if tail_side == "left" or tail_side == "right" else size.x
		if tail_side != "none":
			r = minf(r, (room - tail_width - 8.0) * 0.5)
		return maxf(4.0, minf(r, minf(size.x, size.y) * 0.5))

	# Returns [edge point 0, edge point 1, inward normal] on the bubble's outer edge.
	func _base(r: float) -> Array:
		match tail_side:
			"left":
				var y1: float = clampf(size.y * tail_at, r + 2.0, size.y - r - 2.0 - tail_width)
				return [Vector2(0, y1), Vector2(0, y1 + tail_width), Vector2(1, 0)]
			"bottom":
				var x1: float = clampf(size.x * tail_at, r + 2.0, size.x - r - 2.0 - tail_width)
				return [Vector2(x1, size.y), Vector2(x1 + tail_width, size.y), Vector2(0, -1)]
			"top":
				var x2: float = clampf(size.x * tail_at, r + 2.0, size.x - r - 2.0 - tail_width)
				return [Vector2(x2, 0), Vector2(x2 + tail_width, 0), Vector2(0, 1)]
			_:
				var y2: float = clampf(size.y * tail_at, r + 2.0, size.y - r - 2.0 - tail_width)
				return [Vector2(size.x, y2), Vector2(size.x, y2 + tail_width), Vector2(-1, 0)]

	func _draw() -> void:
		var ink := Color("#15110E")
		var r: float = _radius()
		var o: float = outline
		var body := StyleBoxFlat.new()
		body.bg_color = fill
		body.border_color = ink
		body.set_border_width_all(int(o))
		body.set_corner_radius_all(int(r))
		body.anti_aliasing = true
		var sh := StyleBoxFlat.new()
		sh.bg_color = ink
		sh.set_corner_radius_all(int(r))
		var d := Vector2(shadow, shadow)
		var has_tail: bool = tail_side != "none"
		var e0 := Vector2.ZERO
		var e1 := Vector2.ZERO
		var n := Vector2.ZERO
		var tip := tail_tip
		if has_tail:
			var b: Array = _base(r)
			e0 = b[0]
			e1 = b[1]
			n = b[2]
			if tail_rel.x >= 0.0:
				tip = size * tail_rel + tail_px
		# shadow
		draw_style_box(sh, Rect2(d, size))
		# body
		draw_style_box(body, Rect2(Vector2.ZERO, size))
		if not has_tail:
			return
		# tail: fill reaches inside the body so the border under its mouth is covered
		var t: Vector2 = (e1 - e0).normalized()
		var inner: float = o + 2.0
		draw_colored_polygon(PackedVector2Array([e0 + n * inner, tip, e1 + n * inner]), fill)
		draw_colored_polygon(PackedVector2Array([
			e0 + n * inner + t * (o * 0.5), e1 + n * inner - t * (o * 0.5),
			e1 - n * 1.0 - t * (o * 0.5), e0 - n * 1.0 + t * (o * 0.5)]), fill)
		var s0: Vector2 = e0 + n * (o * 0.5)
		var s1: Vector2 = e1 + n * (o * 0.5)
		draw_line(s0, tip, ink, o, true)
		draw_line(s1, tip, ink, o, true)
		draw_circle(tip, o * 0.5, ink)
		draw_circle(s0, o * 0.5, ink)
		draw_circle(s1, o * 0.5, ink)

# ── Yellow / ink caution tape ─────────────────────────
class Tape extends Control:
	var stripe: float = 13.0

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var ink := Color("#15110E")
		var h: float = size.y
		draw_rect(Rect2(Vector2.ZERO, size), Color("#FFC21A"))
		var rect := PackedVector2Array([Vector2.ZERO, Vector2(size.x, 0), size, Vector2(0, h)])
		var x: float = -h
		while x < size.x + h:
			var band := PackedVector2Array([Vector2(x, 0), Vector2(x + stripe, 0),
				Vector2(x + stripe - h, h), Vector2(x - h, h)])
			for poly in Geometry2D.intersect_polygons(band, rect):
				draw_colored_polygon(poly, ink)
			x += stripe * 2.0
		draw_rect(Rect2(0, 0, size.x, 3), ink)
		draw_rect(Rect2(0, h - 3, size.x, 3), ink)

# ── Row of stars (filled / empty) ─────────────────────
class Stars extends Control:
	var filled: int = 0:
		set(v):
			filled = v
			queue_redraw()
	var big_middle: bool = false
	var pop_lines: bool = false
	var outline: float = 6.0
	var shadow: float = 6.0

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var ink := Color("#15110E")
		var unit: float = size.x / 3.0
		for i in 3:
			var r: float = minf(unit * 0.46, size.y * 0.46)
			var cy: float = size.y * 0.55
			if big_middle:
				r = minf(unit * 0.42, size.y * 0.36) * (1.25 if i == 1 else 1.0)
				cy = size.y * (0.46 if i == 1 else 0.6)
			var c := Vector2(unit * (i + 0.5), cy)
			if pop_lines and i == 1:
				for k in 7:
					if k == 3:
						continue
					var a: float = -PI * 0.95 + k * PI * 0.9 / 6.0
					draw_line(c + Vector2(cos(a), sin(a)) * (r * 1.18), c + Vector2(cos(a), sin(a)) * (r * 1.48), ink, 5.0, true)
			var pts: PackedVector2Array = ComicFxStars_pts(c, r, r * 0.46)
			if shadow > 0.0:
				draw_colored_polygon(ComicFxStars_pts(c + Vector2(shadow, shadow), r, r * 0.46), ink)
			draw_colored_polygon(pts, Color("#FFC21A") if i < filled else Color("#FFF4D6"))
			var n: int = pts.size()
			for j in n:
				draw_line(pts[j], pts[(j + 1) % n], ink, outline, true)
			for q in pts:
				draw_circle(q, outline * 0.5, ink)
			if i < filled and r > 14.0:
				draw_colored_polygon(ComicFxStars_pts(c + Vector2(-r * 0.2, -r * 0.22), r * 0.22, r * 0.1), Color(1, 1, 1, 0.85))

	static func ComicFxStars_pts(c: Vector2, r_out: float, r_in: float) -> PackedVector2Array:
		var pts := PackedVector2Array()
		for i in 10:
			var a: float = -PI / 2.0 + i * PI / 5.0
			var r: float = r_in if i % 2 == 1 else r_out
			pts.append(c + Vector2(cos(a), sin(a)) * r)
		return pts

# ── Film-strip progress (reads a ProgressBar's value) ──
class Film extends Control:
	var bar: Range = null
	var frames: int = 10

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func watch(r: Range) -> void:
		bar = r
		r.value_changed.connect(func(_v): queue_redraw())
		r.changed.connect(queue_redraw)
		queue_redraw()

	func _draw() -> void:
		if bar == null:
			return
		var ratio: float = 0.0
		if bar.max_value > bar.min_value:
			ratio = (bar.value - bar.min_value) / (bar.max_value - bar.min_value)
		var lit: int = int(ceil(ratio * frames - 0.001))
		var gap: float = 6.0
		var w: float = (size.x - gap * (frames - 1)) / float(frames)
		var font: Font = load("res://fonts/Bangers-Regular.ttf")
		for i in frames:
			var r := Rect2(i * (w + gap), 0, w, size.y)
			var done: bool = i < lit
			var bg: Color = Color("#FFC21A") if done else Color("#3A322B")
			var edge: Color = Color("#FFFBEC") if done else Color("#5A5048")
			var sb := StyleBoxFlat.new()
			sb.bg_color = bg
			sb.border_color = edge
			sb.set_border_width_all(3)
			sb.set_corner_radius_all(4)
			draw_style_box(sb, r)
			if done and i == lit - 1:
				var s: float = minf(r.size.y, r.size.x) * 0.36
				var pts := PackedVector2Array()
				for k in 10:
					var a: float = -PI / 2.0 + k * PI / 5.0
					pts.append(r.get_center() + Vector2(cos(a), sin(a)) * (s if k % 2 == 0 else s * 0.45))
				draw_colored_polygon(pts, Color("#E5412D"))

# ── Shaders ───────────────────────────────────────────
# Sun-burst rays with halftone dots that grow toward the edges.
const RAYS_SHADER := """
shader_type canvas_item;
uniform vec4 color_a : source_color = vec4(1.0, 0.847, 0.353, 1.0);
uniform vec4 color_b : source_color = vec4(1.0, 0.698, 0.102, 1.0);
uniform vec4 dot_color : source_color = vec4(0.898, 0.255, 0.176, 0.5);
uniform vec2 center = vec2(0.56, 0.40);
uniform float rays = 26.0;
uniform float cell = 18.0;
uniform float aspect = 1.7778;
void fragment() {
	vec2 d = (UV - center) * vec2(aspect, 1.0);
	float ang = atan(d.y, d.x);
	float s = step(0.5, fract(ang / 6.2831853 * rays));
	vec4 base = mix(color_a, color_b, s);
	vec2 p = FRAGCOORD.xy;
	vec2 q = vec2(p.x + p.y, p.y - p.x) * 0.7071 / cell;
	vec2 g = fract(q) - 0.5;
	float r = 0.36 * smoothstep(0.30, 1.05, length(d));
	float m = smoothstep(r, r - 0.08, length(g)) * step(0.01, r);
	COLOR = vec4(mix(base.rgb, dot_color.rgb, m * dot_color.a), 1.0);
}
"""

# Transparent layer of dots that fade out from one point (a corner, usually).
const DOTS_SHADER := """
shader_type canvas_item;
uniform vec4 dot_color : source_color = vec4(0.18, 0.55, 0.92, 0.5);
uniform vec2 origin = vec2(0.0, 1.0);
uniform float reach = 0.45;
uniform float cell = 15.0;
uniform float aspect = 1.7778;
void fragment() {
	vec2 d = (UV - origin) * vec2(aspect, 1.0);
	float k = 1.0 - smoothstep(0.0, reach * aspect, length(d));
	vec2 p = FRAGCOORD.xy;
	vec2 q = vec2(p.x + p.y, p.y - p.x) * 0.7071 / cell;
	vec2 g = fract(q) - 0.5;
	float r = 0.36 * k;
	float m = smoothstep(r, r - 0.08, length(g)) * step(0.01, r);
	COLOR = vec4(dot_color.rgb, m * dot_color.a);
}
"""

static func rays_rect(color_a: Color, color_b: Color, dot: Color, center: Vector2 = Vector2(0.56, 0.4)) -> ColorRect:
	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = RAYS_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("color_a", color_a)
	mat.set_shader_parameter("color_b", color_b)
	mat.set_shader_parameter("dot_color", dot)
	mat.set_shader_parameter("center", center)
	rect.material = mat
	return rect

static func dots_rect(dot: Color, origin: Vector2, reach: float = 0.45, cell: float = 15.0) -> ColorRect:
	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = DOTS_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("dot_color", dot)
	mat.set_shader_parameter("origin", origin)
	mat.set_shader_parameter("reach", reach)
	mat.set_shader_parameter("cell", cell)
	rect.material = mat
	return rect

# A small sound-effect word ("DING!") made from logo lettering.
static func sfx(text: String, font_size: int, fill: Color, extrude: Color, degrees: float = -10.0) -> Logo:
	var l := Logo.new()
	l.text = text
	l.font_size = font_size
	l.fill = fill
	l.extrude = extrude
	l.depth = 5
	l.outline = 9
	l.rotation_degrees = degrees
	return l

# A burst sticker with a word on it ("CORRECT!", "GO!", "NEW!").
static func sticker(word: String, sub: String, fill: Color, word_color: Color, sz: Vector2,
		word_size: int = 40, spikes: int = 14, degrees: float = 8.0) -> Burst:
	var b := Burst.new()
	b.fill = fill
	b.spikes = spikes
	b.inner = 0.74
	b.shadow = 7.0
	b.outline = 5.0
	b.seed_value = 33
	b.size = sz
	b.custom_minimum_size = sz
	b.pivot_offset = sz / 2.0
	b.rotation_degrees = degrees
	var lbl := Label.new()
	lbl.text = word
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.offset_top = -10.0 if sub != "" else -4.0
	lbl.offset_bottom = lbl.offset_top
	lbl.offset_right = -6.0
	lbl.add_theme_font_override("font", Comic.display_font())
	lbl.add_theme_font_size_override("font_size", word_size)
	lbl.add_theme_color_override("font_color", word_color)
	lbl.add_theme_color_override("font_outline_color", INK)
	lbl.add_theme_constant_override("outline_size", 6)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(lbl)
	if sub != "":
		var s := Label.new()
		s.text = sub
		s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		s.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		s.set_anchors_preset(Control.PRESET_FULL_RECT)
		s.offset_top = word_size * 0.62
		s.offset_bottom = s.offset_top
		s.offset_right = -6.0
		s.add_theme_font_override("font", Comic.display_font())
		s.add_theme_font_size_override("font_size", maxi(14, int(word_size * 0.42)))
		s.add_theme_color_override("font_color", INK)
		s.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(s)
	return b

# Quick "pop in" for a sticker.
static func pop(ctrl: Control) -> void:
	var final_scale: Vector2 = ctrl.scale
	ctrl.scale = final_scale * 0.2
	var tw := ctrl.create_tween()
	tw.tween_property(ctrl, "scale", final_scale * 1.12, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(ctrl, "scale", final_scale, 0.08)

# ── Comic page frame: paper gutters around one big panel ──
# Drawn on top of the scene art so anything outside the panel is covered.
class Frame extends Control:
	var panel_rect: Rect2 = Rect2(16, 84, 1248, 620)
	var gutter: Color = Color("#FFF4D6")
	var border: float = 6.0
	var shadow: float = 8.0

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var ink := Color("#15110E")
		var r: Rect2 = panel_rect
		var full := Rect2(Vector2.ZERO, size)
		draw_rect(Rect2(0, 0, full.size.x, r.position.y), gutter)
		draw_rect(Rect2(0, r.end.y, full.size.x, full.size.y - r.end.y), gutter)
		draw_rect(Rect2(0, r.position.y, r.position.x, r.size.y), gutter)
		draw_rect(Rect2(r.end.x, r.position.y, full.size.x - r.end.x, r.size.y), gutter)
		draw_rect(Rect2(r.end.x, r.position.y + shadow, shadow, r.size.y), ink)
		draw_rect(Rect2(r.position.x + shadow, r.end.y, r.size.x, shadow), ink)
		draw_rect(r.grow(-border / 2.0), ink, false, border)

# ── Where to aim a speech-bubble tail ─────────────────
# Finds, once per character picture, the left edge of the face at mouth height
# (as 0..1 of the picture). Measured from the first opaque row (top of hair).
static var _face_cache: Dictionary = {}

static func face_uv(tex: Texture2D) -> Vector2:
	if tex == null:
		return Vector2(0.4, 0.11)
	var key: int = tex.get_rid().get_id()
	if _face_cache.has(key):
		return _face_cache[key]
	var uv := Vector2(0.4, 0.11)
	var img: Image = tex.get_image()
	if img != null:
		img = img.duplicate()
		if img.is_compressed():
			img.decompress()
		var sw: int = 160
		var sh: int = maxi(16, int(sw * float(img.get_height()) / maxf(1.0, img.get_width())))
		img.resize(sw, sh, Image.INTERPOLATE_BILINEAR)
		var top: int = -1
		for y in sh:
			for x in sw:
				if img.get_pixel(x, y).a > 0.5:
					top = y
					break
			if top >= 0:
				break
		if top >= 0:
			# The head is roughly the top 14% of a standing figure
			# Left edge of the face on the mouth row (hair above can stick out further)
			var mouth_y: int = mini(sh - 1, top + int(sh * 0.125))
			var lo: int = sw
			for x in sw:
				if img.get_pixel(x, mouth_y).a > 0.5:
					lo = x
					break
			if lo < sw:
				uv = Vector2(float(lo) / sw, float(mouth_y) / sh)
	_face_cache[key] = uv
	return uv

# The point (in the TextureRect's parent space) just left of the character's
# mouth, for a TextureRect drawn with STRETCH_KEEP_ASPECT_CENTERED.
static func mouth_point(tr: TextureRect, rect: Rect2 = Rect2()) -> Vector2:
	var tex: Texture2D = tr.texture
	var r: Rect2 = rect if rect.size != Vector2.ZERO else Rect2(tr.position, tr.size)
	if tex == null:
		return r.position + r.size * Vector2(0.4, 0.11)
	var ts: Vector2 = tex.get_size()
	var sc: float = minf(r.size.x / ts.x, r.size.y / ts.y)
	var ds: Vector2 = ts * sc
	var origin: Vector2 = r.position + (r.size - ds) * 0.5
	return origin + ds * face_uv(tex)

# Lay a control out on the 1280x720 design page, kept centred on screens
# that are wider or taller (the project stretches with aspect "expand").
static func place_centered(ctrl: Control, rect: Rect2) -> void:
	ctrl.anchor_left = 0.5
	ctrl.anchor_right = 0.5
	ctrl.anchor_top = 0.5
	ctrl.anchor_bottom = 0.5
	ctrl.offset_left = rect.position.x - 640.0
	ctrl.offset_right = rect.end.x - 640.0
	ctrl.offset_top = rect.position.y - 360.0
	ctrl.offset_bottom = rect.end.y - 360.0

# Same, but pinned to the right edge (x measured from the right of the page).
static func place_right(ctrl: Control, rect: Rect2) -> void:
	ctrl.anchor_left = 1.0
	ctrl.anchor_right = 1.0
	ctrl.anchor_top = 0.0
	ctrl.anchor_bottom = 0.0
	ctrl.offset_left = rect.position.x - 1280.0
	ctrl.offset_right = rect.end.x - 1280.0
	ctrl.offset_top = rect.position.y
	ctrl.offset_bottom = rect.end.y

# ── Comic icons (res://images/icons/*.svg) ─────────────
# Returns the icon scaled to `px` pixels square (cached).
static var _icon_cache: Dictionary = {}

static func icon(name: String, px: int = 26) -> Texture2D:
	var key: String = name + "@" + str(px)
	if _icon_cache.has(key):
		return _icon_cache[key]
	var path: String = "res://images/icons/%s.svg" % name
	var img: Image = null
	if ResourceLoader.exists(path):
		var tex: Texture2D = load(path)
		if tex != null:
			img = tex.get_image()
	if img == null:
		# Not imported yet: rasterise the SVG directly
		var f := FileAccess.open(path, FileAccess.READ)
		if f != null:
			img = Image.new()
			if img.load_svg_from_buffer(f.get_buffer(f.get_length()), px / 128.0) != OK:
				img = null
	if img == null:
		return null
	img = img.duplicate()
	if img.is_compressed():
		img.decompress()
	if img.get_width() != px:
		img.resize(px, px, Image.INTERPOLATE_LANCZOS)
	var out := ImageTexture.create_from_image(img)
	_icon_cache[key] = out
	return out

# Put an icon on a button, left of its text.
static func set_icon(btn: Button, name: String, px: int = 26) -> void:
	btn.icon = icon(name, px)
	btn.add_theme_constant_override("h_separation", 10)

# A centred icon as its own control (for labels and headers).
static func icon_rect(name: String, px: int = 26) -> TextureRect:
	var r := TextureRect.new()
	r.texture = icon(name, px)
	r.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	r.custom_minimum_size = Vector2(px, px)
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r
