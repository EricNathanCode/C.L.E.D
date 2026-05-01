extends VBoxContainer
# ═══════════════════════════════════════════
#  GAMEMODE: SELECT  (sql_choice)
#  Global scene — reused by any lesson that
#  uses a SELECT id = ? challenge.
# ═══════════════════════════════════════════

signal on_correct
signal on_quit

var _correct_id: int = -1

func _ready() -> void:
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	$QueryLine/IdInput.text_submitted.connect(func(_t): _on_execute())

# ── Called by GameScreen with the step data dict ──────────
func setup(data: Dictionary) -> void:
	_correct_id = data.get("correct_id", -1)

	$Description.text         = data.get("desc", "")
	$HintLabel.text           = "Hint: " + data.get("hint", "")
	$QueryLine/IdInput.text   = ""
	$HintLabel.visible        = false
	$ResultLabel.visible      = false
	$ContinueButton.visible   = false

	# Build option rows from data["options"] → [[id, text], ...]
	var rows_node: Node = $OptionsTable/OptionRows
	for child in rows_node.get_children():
		child.queue_free()

	var options: Array = data.get("options", [])
	for opt in options:
		var row: HBoxContainer = HBoxContainer.new()
		row.add_theme_constant_override("separation", 0)

		var id_lbl: Label = Label.new()
		id_lbl.text = " " + str(opt[0]) + " "
		id_lbl.custom_minimum_size = Vector2(40, 0)

		var opt_lbl: Label = Label.new()
		opt_lbl.text = " " + str(opt[1])
		opt_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		opt_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		row.add_child(id_lbl)
		row.add_child(opt_lbl)
		rows_node.add_child(row)

	# Focus the input
	$QueryLine/IdInput.grab_focus()

# ── Buttons ───────────────────────────────────────────────
func _on_execute() -> void:
	var inp: LineEdit = $QueryLine/IdInput
	var val: String = inp.text.strip_edges()

	if val.is_empty():
		_show_result(false, "Please type an id number from the table.")
		return
	if not val.is_valid_int():
		_show_result(false, "id must be a number. Try again.")
		return
	if int(val) == _correct_id:
		_show_result(true, "Query executed. id = " + val + " selected.")
		$ContinueButton.visible = true
	else:
		_show_result(false, "id = " + val + " is not the correct response. Try again.")

func _on_hint() -> void:
	$HintLabel.visible = true

func _on_continue() -> void:
	on_correct.emit()

func _show_result(ok: bool, msg: String) -> void:
	$ResultLabel.text    = ("OK: " if ok else "ERROR: ") + msg
	$ResultLabel.visible = true
