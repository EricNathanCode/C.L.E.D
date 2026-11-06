extends Node
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
# ═══════════════════════════════════════════════════════
#  FOCUS GUARD  |  scripts/FocusGuard.gd  (Autoload)
#  Anti-cheat for class use (teacher's request, Nov 6, 2026). The game starts
#  in fullscreen (project.godot). Leaving the game window (Alt+Tab, the
#  Windows key, another app, another browser tab) during a lesson, a Folder
#  Challenge or a Simulation run starts a 10-second warning with an alarm:
#    • back within 10 s → a warning, then the student carries on
#    • away longer → that lesson / challenge / run stops and nothing from it
#      is saved (lessons and challenges only save when finished, and a
#      Simulation best score only when the run ends, so leaving to the
#      lesson list saves nothing)
#  Menus and the lesson list are not guarded, and Exit Game quits normally.
# ═══════════════════════════════════════════════════════

const GRACE_SEC := 10
const ALARM_DB := -8.0   # fixed: the warning is heard even with Sound Effects turned down

var _away_since: int = -1     # Time.get_ticks_msec() when the student left; -1 = not counting
var _activity: String = ""    # "lesson" | "challenge" | "simulation"
var _shown_left: int = -1     # seconds left shown on screen

var _root: Control = null
var _title: Label = null
var _burst: Control = null
var _count: Label = null
var _msg: Label = null
var _ok: Button = null
var _player: AudioStreamPlayer = null
var _alarm: AudioStreamWAV = null
var _tick: AudioStreamWAV = null
var _tick_hi: AudioStreamWAV = null
var _buzz: AudioStreamWAV = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	_player = AudioStreamPlayer.new()
	_player.bus = "Master"
	_player.volume_db = ALARM_DB
	add_child(_player)
	_alarm = _tone([880.0, 660.0, 880.0, 660.0], 0.6)
	_tick = _tone([990.0], 0.07)
	_tick_hi = _tone([1320.0], 0.09)
	_buzz = _tone([196.0, 147.0], 0.7)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_on_left()
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		_on_returned()

# ── What is running right now ──────────────────────────
func _main() -> Node:
	return get_tree().root.get_node_or_null("Main")

func _current_activity() -> String:
	var main := _main()
	if main == null:
		return ""
	if main.get_node("GameScreen").visible:
		return "lesson"
	if main.get_node("FolderQuizScreen").visible:
		return "challenge"
	var sim: Node = main.get_node("SimulationScreen")
	if sim.visible and not sim.get_node("GameOverOverlay").visible:
		return "simulation"   # (after the run has ended, its score is already saved)
	return ""

func _activity_name(a: String) -> String:
	match a:
		"challenge":
			return "Folder Challenge"
		"simulation":
			return "Simulation run"
	return "lesson"

# ── Leaving and coming back ────────────────────────────
func _on_left() -> void:
	if _away_since >= 0:
		return
	_activity = _current_activity()
	if _activity.is_empty():
		return
	_away_since = Time.get_ticks_msec()
	_shown_left = -1
	GameManager.stop_speaking()
	_title.text = "You left the game!"
	_msg.text = "Come back within %d seconds, or this %s stops and won't be saved. Looking up answers outside the game isn't allowed." % [GRACE_SEC, _activity_name(_activity)]
	_burst.visible = true
	_ok.visible = false
	_root.visible = true
	_play(_alarm)
	DisplayServer.window_request_attention()

func _on_returned() -> void:
	if _away_since < 0:
		return
	# Checked here too: a hidden browser tab can stop the game's clock
	if Time.get_ticks_msec() - _away_since >= GRACE_SEC * 1000:
		_time_up()
		return
	_away_since = -1
	_title.text = "Stay in the game!"
	_msg.text = "You came back in time, so you can keep going. Every time you leave during a %s, the %d-second warning starts again." % [_activity_name(_activity), GRACE_SEC]
	_burst.visible = false
	_ok.text = "Continue"
	_ok.visible = true
	_ok.grab_focus()

func _process(_delta: float) -> void:
	if _away_since < 0:
		return
	var elapsed: int = Time.get_ticks_msec() - _away_since
	if elapsed >= GRACE_SEC * 1000:
		_time_up()
		return
	var left: int = GRACE_SEC - elapsed / 1000
	if left != _shown_left:
		_shown_left = left
		_count.text = str(left)
		_pulse()
		if _shown_left != GRACE_SEC:   # the alarm already covers the first second
			_play(_tick_hi if left <= 3 else _tick)

# Away too long: stop the lesson / challenge / run without saving it
func _time_up() -> void:
	_away_since = -1
	var main := _main()
	if main != null:
		match _activity:
			"lesson":
				main.get_node("GameScreen")._on_back_to_hub()
			_:
				main.show_screen("dashboard")
	_play(_buzz)
	_title.text = "Time's up!"
	_msg.text = "You were away for more than %d seconds, so this %s was stopped and nothing from it was saved." % [GRACE_SEC, _activity_name(_activity)]
	_burst.visible = false
	_ok.text = "OK"
	_ok.visible = true
	_ok.grab_focus()
	_root.visible = true
	DisplayServer.window_request_attention()

func _close() -> void:
	if _away_since < 0:
		_root.visible = false

# While the warning is up, keys only close it (and never reach the lesson)
func _input(event: InputEvent) -> void:
	if _root == null or not _root.visible:
		return
	if event is InputEventKey:
		get_viewport().set_input_as_handled()
		if event.pressed and _ok.visible and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE, KEY_ESCAPE]:
			_close()

# ── Look ───────────────────────────────────────────────
func _build_ui() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 120   # above every screen and pop-up
	add_child(layer)

	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.visible = false
	layer.add_child(_root)

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Comic.apply_dim(dim, 0.82)
	_root.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(640, 0)
	Comic.apply_panel(panel, Comic.PAPER, 16, 8, 34, 26, 5)
	center.add_child(panel)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 14)
	panel.add_child(vb)

	_title = Label.new()
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Comic.title(_title, 48, Comic.RED, 9)
	vb.add_child(_title)

	var b := Fx.Burst.new()
	b.fill = Comic.RED
	b.spikes = 16
	b.inner = 0.72
	b.shadow = 8.0
	b.outline = 5.0
	b.seed_value = 12
	b.custom_minimum_size = Vector2(230, 170)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.resized.connect(func(): b.pivot_offset = b.size / 2.0)
	vb.add_child(b)
	_burst = b
	_count = Label.new()
	_count.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_count.offset_right = -8.0
	_count.offset_bottom = -6.0
	_count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_count.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	Comic.title(_count, 92, Comic.YELLOW, 12)
	b.add_child(_count)

	_msg = Label.new()
	_msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_msg.custom_minimum_size = Vector2(560, 0)
	Comic.body(_msg, 20, Comic.INK)
	vb.add_child(_msg)

	_ok = Button.new()
	_ok.text = "OK"
	_ok.custom_minimum_size = Vector2(220, 0)
	_ok.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	Comic.apply_button(_ok, "primary", 26, true, 26, 8)
	_ok.pressed.connect(_close)
	vb.add_child(_ok)

func _pulse() -> void:
	_burst.scale = Vector2(1.18, 1.18)
	var tw := _burst.create_tween()
	tw.tween_property(_burst, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ── Sounds (made here, no sound files needed) ─────────
func _play(stream: AudioStream) -> void:
	_player.stream = stream
	_player.play()

# A square-wave beep that steps through `freqs` over `dur` seconds.
static func _tone(freqs: Array, dur: float) -> AudioStreamWAV:
	var rate: int = 22050
	var n: int = int(rate * dur)
	var data := PackedByteArray()
	data.resize(n * 2)
	for i in n:
		var t: float = float(i) / rate
		var f: float = freqs[mini(int(t / dur * freqs.size()), freqs.size() - 1)]
		var env: float = minf(1.0, minf(t / 0.004, (dur - t) / 0.03))   # no clicks
		var s: float = (1.0 if fmod(t * f, 1.0) < 0.5 else -1.0) * 0.32 * env
		data.encode_s16(i * 2, int(s * 32767.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = rate
	w.stereo = false
	w.data = data
	return w
