extends VBoxContainer

signal on_correct
signal on_quit

var _answer: String = ""

func _ready() -> void:
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	$SQLBlock/Line2/Blank1.text_submitted.connect(func(_t): _on_execute())

func setup(data: Dictionary) -> void:
	_answer = data.get("answer", "").to_upper()
	$Description.text                 = data.get("desc", "")
	$HintLabel.text                   = "Hint: " + data.get("hint", "")
	$TableLabel.text                  = "TABLE: " + data.get("table", "[table]")
	$SQLBlock/Line1.text              = "SELECT * FROM " + data.get("table", "[table]")
	$SQLBlock/Line2/OrderKeyword.text = "ORDER BY " + data.get("column", "[column]")
	$SQLBlock/Line2/Blank1.text       = ""
	$HintLabel.visible                = false
	$ResultLabel.visible              = false
	$ContinueButton.visible           = false
	$SQLBlock/Line2/Blank1.grab_focus()

func _on_execute() -> void:
	var inp: LineEdit = $SQLBlock/Line2/Blank1
	var val: String = inp.text.strip_edges().to_upper()

	if val.is_empty():
		_show_result(false, "Type ASC (ascending) or DESC (descending).")
		return
	if val != "ASC" and val != "DESC":
		_show_result(false, "Only ASC or DESC are valid. Try again.")
		return
	if val == _answer:
		inp.text = _answer
		_show_result(true, "Query executed. Records sorted " + _answer + ".")
		$ContinueButton.visible = true
	else:
		_show_result(false, val + " is the wrong direction here. Try again.")

func _on_hint() -> void:
	$HintLabel.visible = true

func _on_continue() -> void:
	on_correct.emit()

func _show_result(ok: bool, msg: String) -> void:
	$ResultLabel.text    = ("OK: " if ok else "ERROR: ") + msg
	$ResultLabel.visible = true
