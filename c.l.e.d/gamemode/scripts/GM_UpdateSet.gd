extends VBoxContainer

signal on_correct
signal on_quit

var _answer_value: String = ""
var _answer_id:    String = ""

func _ready() -> void:
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	$SQLBlock/Line2/Blank1.text_submitted.connect(func(_t): _on_execute())
	$SQLBlock/Line3/Blank2.text_submitted.connect(func(_t): _on_execute())

func setup(data: Dictionary) -> void:
	_answer_value = data.get("answer_value", "")
	_answer_id    = str(data.get("answer_id", ""))
	$Description.text               = data.get("desc", "")
	$HintLabel.text                 = "Hint: " + data.get("hint", "")
	$TableLabel.text                = "TABLE: " + data.get("table", "[table]")
	$SQLBlock/Line1.text            = "UPDATE " + data.get("table", "[table]")
	$SQLBlock/Line2/SetKeyword.text = "SET " + data.get("column", "[column]") + " = '"
	$SQLBlock/Line2/Blank1.text     = ""
	$SQLBlock/Line3/Blank2.text     = ""
	$HintLabel.visible              = false
	$ResultLabel.visible            = false
	$ContinueButton.visible         = false
	$SQLBlock/Line2/Blank1.grab_focus()

func _on_execute() -> void:
	var inp1: LineEdit = $SQLBlock/Line2/Blank1
	var inp2: LineEdit = $SQLBlock/Line3/Blank2
	var val: String = inp1.text.strip_edges()
	var rid: String = inp2.text.strip_edges()

	if val.is_empty() or rid.is_empty():
		_show_result(false, "Fill in both blanks.")
		return

	var val_ok: bool = val.to_lower() == _answer_value.to_lower()
	var id_ok: bool  = rid == _answer_id

	if val_ok and id_ok:
		inp1.text = _answer_value
		inp2.text = _answer_id
		_show_result(true, "Query executed. 1 record updated.")
		$ContinueButton.visible = true
	else:
		var msg: String = "Wrong: "
		if not val_ok: msg += "new value is incorrect. "
		if not id_ok:  msg += "id is incorrect."
		_show_result(false, msg)

func _on_hint() -> void:
	$HintLabel.visible = true

func _on_continue() -> void:
	on_correct.emit()

func _show_result(ok: bool, msg: String) -> void:
	$ResultLabel.text    = ("OK: " if ok else "ERROR: ") + msg
	$ResultLabel.visible = true
