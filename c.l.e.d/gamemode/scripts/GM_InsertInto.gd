extends VBoxContainer

signal on_correct
signal on_quit

var _answers: Array = []
var _blanks:  Array = []

func _ready() -> void:
	_blanks = [
		$SQLBlock/Line2/Blank1,
		$SQLBlock/Line2/Blank2,
		$SQLBlock/Line2/Blank3,
		$SQLBlock/Line2/Blank4,
	]
	$ButtonRow/ExecuteButton.pressed.connect(_on_execute)
	$ButtonRow/HintButton.pressed.connect(_on_hint)
	$ContinueButton.pressed.connect(_on_continue)
	for b in _blanks:
		var le: LineEdit = b
		le.text_submitted.connect(func(_t): _on_execute())

func setup(data: Dictionary) -> void:
	_answers = data.get("answers", [])
	$Description.text    = data.get("desc", "")
	$HintLabel.text      = "Hint: " + data.get("hint", "")
	$TableLabel.text     = "TABLE: " + data.get("table", "[table]")
	$SQLBlock/Line1.text = "INSERT INTO " + data.get("table", "[table]") + \
		" (" + ", ".join(data.get("columns", [])) + ")"

	$HintLabel.visible      = false
	$ResultLabel.visible    = false
	$ContinueButton.visible = false

	var seps: Array = [
		$SQLBlock/Line2/Sep1,
		$SQLBlock/Line2/Sep2,
		$SQLBlock/Line2/Sep3,
	]
	for i in range(_blanks.size()):
		var le: LineEdit = _blanks[i]
		le.text    = ""
		le.visible = i < _answers.size()
	for i in range(seps.size()):
		var lbl: Label = seps[i]
		lbl.visible = i < (_answers.size() - 1)

	if _answers.size() > 0:
		var first: LineEdit = _blanks[0]
		first.grab_focus()

func _on_execute() -> void:
	if _answers.is_empty():
		return
	var all_correct: bool = true
	for i in range(_answers.size()):
		var inp: LineEdit = _blanks[i]
		var expected: String = str(_answers[i])
		if inp.text.strip_edges().to_lower() == expected.to_lower():
			inp.text = expected
		else:
			all_correct = false
	if all_correct:
		_show_result(true, "Query executed. Record inserted successfully.")
		$ContinueButton.visible = true
	else:
		_show_result(false, "Some values are wrong. Check the dialogue and try again.")

func _on_hint() -> void:
	$HintLabel.visible = true

func _on_continue() -> void:
	on_correct.emit()

func _show_result(ok: bool, msg: String) -> void:
	$ResultLabel.text    = ("OK: " if ok else "ERROR: ") + msg
	$ResultLabel.visible = true
