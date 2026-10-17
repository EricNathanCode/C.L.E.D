extends Control
const Comic = preload("res://scripts/ComicStyle.gd")
const Fx = preload("res://scripts/ComicFx.gd")
# ═══════════════════════════════════════════════════════
#  TERMS OVERLAY  |  scripts/TermsOverlay.gd
#  The "Terms of Use & Privacy Notice" pop-up. Opened from the Login screen
#  and from the Settings panels:  TermsOverlay.open(self)
# ═══════════════════════════════════════════════════════

const LAST_UPDATED := "October 13, 2026"

const TERMS_BBCODE := """[h]TERMS OF USE[/h]
[small]Last updated: {date}[/small]

[b]1. About C.L.I.D[/b]
C.L.I.D is a free educational game for practicing SQL through story-based lessons. It was made as a student capstone project to support classroom learning (such as DCIT 24 – Information Management). It does not replace your course, your teacher, or official course materials.

[b]2. Using the game[/b]
You may play C.L.I.D for free for personal and educational use. Please do not sell it, re-upload it as your own work, or remove its credits.

[b]3. Your account[/b]
Your account exists only on this device (or in this web browser). There is no online server, so:
  • We cannot recover a forgotten password or a lost account.
  • Your password is saved on this device without encryption. [b]Do not use a password that you use anywhere else.[/b]
  • Anyone who uses this computer or browser could see the saved data. On shared computers, log out when you are done.

[b]4. No warranty[/b]
The game is provided "as is". We work to keep the lessons accurate, but we cannot promise that it is free of mistakes or bugs.

[b]5. Changes to these terms[/b]
We may update these terms when the game is updated. The date at the top shows the latest version.


[h]PRIVACY NOTICE[/h]

[b]What the game saves (on your device only)[/b]
  • Your username and password
  • Your lesson progress, stars, Folder Challenge results and Simulation best scores
  • Your settings (music, sound effects, text-to-speech, dark mode)

[b]What the game does NOT do[/b]
  • It does not send any of your information to us or to anyone else. It has no online accounts, no ads and no tracking.
  • Text-to-speech uses the voices already built into your computer or browser.

[b]Where your data is stored[/b]
  • Windows app: in your user folder, under AppData\\Roaming\\Godot\\app_userdata\\C.L.E.D
  • Linux app: in your home folder, under .local/share/Godot/app_userdata/C.L.E.D
  • Web version: in your browser's storage for the itch.io website. The itch.io website itself is run by itch.io and follows its own privacy policy.

[b]Removing your data[/b]
  • Settings → [b]Reset Progress[/b] clears your lesson and Folder Challenge progress.
  • Settings → [b]Delete My Account[/b] (while logged in) permanently removes your account, progress, stars and Simulation scores. Other accounts on the device are kept.
  • Settings on the Login screen → [b]Delete All Data[/b] removes every account and all progress on this device (or in this browser), and resets all settings to their defaults.

[b]Removing the game[/b]
  • Windows app: delete the folder you unzipped the game into (it holds CLID.exe), or uninstall it in the itch.io app if you installed it there. Use Delete All Data first if you also want your saved data gone.
  • Linux app: delete the folder you extracted the game into (it holds CLID.x86_64). Use Delete All Data first if you also want your saved data gone.
  • Web version: nothing is installed. Use Delete All Data, or clear your browser's site data for itch.io.

[b]Younger players[/b]
If you are under 18, please play with the guidance of a parent, guardian or teacher.


[h]CREDITS[/h]
  • Made with the Godot Engine (MIT License)
  • SQL engine: SQLite (public domain) through godot-sqlite (MIT License)
  • Fonts: Bangers and Comic Neue (SIL Open Font License), DejaVu Sans (free font license)
  • Sound effects: Kenney, kenney.nl (CC0 public domain)

[b]Questions?[/b] Message the C.L.I.D team through the game's page on itch.io."""

var _closed_cb: Callable = Callable()

# Adds the pop-up on top of `host` and shows it. `on_close` runs when it closes.
static func open(host: Control, on_close: Callable = Callable()) -> Control:
	var o := preload("res://scripts/TermsOverlay.gd").new()
	o._closed_cb = on_close
	host.add_child(o)
	return o

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = 120
	mouse_filter = Control.MOUSE_FILTER_STOP

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Comic.apply_dim(dim, 0.75)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			_close()
	)
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	var panel := PanelContainer.new()
	Comic.apply_panel(panel, Comic.PAPER, 16, 8, 28, 22, 5)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	var head := HBoxContainer.new()
	vbox.add_child(head)
	var title := Label.new()
	title.text = "Terms & Privacy"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Comic.title(title, 38, Comic.YELLOW, 8)
	head.add_child(title)
	var x_btn := Button.new()
	x_btn.text = "✕"
	x_btn.pressed.connect(_close)
	Comic.apply_icon_button(x_btn, "danger", 22)
	head.add_child(x_btn)

	var rule := ColorRect.new()
	rule.custom_minimum_size = Vector2(0, 4)
	rule.color = Comic.INK
	vbox.add_child(rule)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)
	var pad := MarginContainer.new()
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_right", 20)
	scroll.add_child(pad)

	var text := RichTextLabel.new()
	text.bbcode_enabled = true
	text.fit_content = true
	text.scroll_active = false
	text.selection_enabled = false
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text.add_theme_font_override("normal_font", Comic.body_regular_font())
	text.add_theme_font_override("bold_font", Comic.body_font())
	text.add_theme_font_size_override("normal_font_size", 17)
	text.add_theme_font_size_override("bold_font_size", 18)
	text.add_theme_color_override("default_color", Comic.INK)
	text.add_theme_constant_override("line_separation", 3)
	text.text = _format(TERMS_BBCODE.replace("{date}", LAST_UPDATED))
	pad.add_child(text)

	var ok := Button.new()
	ok.text = "Got it"
	ok.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ok.custom_minimum_size = Vector2(200, 0)
	ok.pressed.connect(_close)
	Comic.apply_button(ok, "primary", 26, true, 26, 8)
	vbox.add_child(ok)

	# Size: wide enough to read comfortably, never taller than the screen
	var fit := func():
		var w: float = clampf(size.x - 80.0, 420.0, 760.0)
		panel.custom_minimum_size.x = w
		scroll.custom_minimum_size.y = maxf(180.0, size.y - 250.0)
	resized.connect(fit)
	fit.call.call_deferred()
	ok.grab_focus()

# Comic section headings and small print, as plain BBCode tags
func _format(src: String) -> String:
	var out := src
	out = out.replace("[h]", "[font=%s][font_size=30][color=#E5412D]" % Comic.FONT_DISPLAY)
	out = out.replace("[/h]", "[/color][/font_size][/font]")
	out = out.replace("[small]", "[font_size=14][color=#8C8370]")
	out = out.replace("[/small]", "[/color][/font_size]")
	return out

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_close()

func _close() -> void:
	if _closed_cb.is_valid():
		_closed_cb.call()
	queue_free()
