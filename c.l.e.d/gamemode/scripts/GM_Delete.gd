extends VBoxContainer

signal on_correct
signal on_quit

var _answer_id: String = ""

func _ready() -> void:
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	$SQLBlock/Line2/Blank1.text_submitted.connect(func(_t): _on_execute())

func setup(data: Dictionary) -> void:
	_answer_id = str(data.get("answer_id", ""))
	$Description.text     = data.get("desc", "")
	$HintLabel.text       = "Hint: " + data.get("hint", "")
	$TableLabel.text      = "TABLE: " + data.get("table", "[table]")
	$SQLBlock/Line1.text  = "DELETE FROM " + data.get("table", "[table]")
	$SQLBlock/Line2/Blank1.text = ""
	$HintLabel.visible          = false
	$ResultLabel.visible        = false
	$ContinueButton.visible     = false
	$SQLBlock/Line2/Blank1.grab_focus()

func _on_execute() -> void:
	var inp: LineEdit = $SQLBlock/Line2/Blank1
	var val: String = inp.text.strip_edges()

	if val.is_empty():
		_show_result(false, "Please type the record id to delete.")
		return
	if val == _answer_id:
		_show_result(true, "Query executed. Record with id = " + val + " deleted.")
		$ContinueButton.visible = true
	else:
		_show_result(false, "id = " + val + " is not the correct record. Try again.")

func _on_hint() -> void:
	$HintLabel.visible = true

func _on_continue() -> void:
	on_correct.emit()

func _show_result(ok: bool, msg: String) -> void:
	$ResultLabel.text    = ("OK: " if ok else "ERROR: ") + msg
	$ResultLabel.visible = true
