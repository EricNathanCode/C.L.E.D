extends Control
# ═══════════════════════════════════════════════════════
#  GAME SCREEN  —  scripts/GameScreen.gd
#
#  Back button behaviour:
#    In dialogue  → step - 1, re-run step (hidden at step 0)
#    In overlay   → close overlay, step - 1, re-run step
#                   (player sees the dialogue they came from)
# ═══════════════════════════════════════════════════════

const GM_SCENES: Dictionary = {
	"select":       "res://gamemode/scene/GM_Select.tscn",
	"insert_into":  "res://gamemode/scene/GM_InsertInto.tscn",
	"select_where": "res://gamemode/scene/GM_SelectWhere.tscn",
	"update_set":   "res://gamemode/scene/GM_UpdateSet.tscn",
	"delete":       "res://gamemode/scene/GM_Delete.tscn",
	"order_by":     "res://gamemode/scene/GM_OrderBy.tscn",
	"group_by":     "res://gamemode/scene/GM_GroupBy.tscn",
}

var _story:      Array = []
var _step:       int   = 0
var _current_gm: Node  = null

func _ready() -> void:
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/DialogueButtons/NextButton.pressed.connect(_on_next)
	$DialogueArea/DialogueButtons/BackButton.pressed.connect(_on_back)
	$SQLOverlay/CenterContainer/PanelContainer/OuterVBox/BackToDialogueButton.pressed.connect(_on_back)

func load_lesson(id) -> void:
	_story = _get_story(id)
	_step  = 0
	$TopBar/LessonLabel.text = "Lesson: " + str(id)
	_close_overlay()
	_run_step()

# ── Story engine ──────────────────────────────────────────
func _run_step() -> void:
	if _step >= _story.size():
		get_tree().root.get_node("Main").show_screen("complete")
		return

	var s: Dictionary = _story[_step]

	# Back button: visible only when there is a previous step
	$DialogueArea/DialogueButtons/BackButton.visible = _step > 0

	match s["type"]:
		"dialogue":
			$DialogueArea/CharacterName.text             = s.get("name", "")
			$DialogueArea/DialogueText.text              = s.get("text", "")
			$DialogueArea/DialogueButtons/NextButton.visible = true

		"sql_choice":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, "select")

		"sql_fill":
			$DialogueArea/DialogueButtons/NextButton.visible = false
			_show_challenge(s, s.get("gamemode", ""))

		"end":
			get_tree().root.get_node("Main").show_screen("complete")

# ── Challenge overlay ─────────────────────────────────────
func _show_challenge(step: Dictionary, gm_key: String) -> void:
	var path: String = GM_SCENES.get(gm_key, "")
	if path.is_empty():
		push_error("GameScreen: unknown gamemode key: " + gm_key)
		return

	_clear_gm()

	var packed: PackedScene = load(path)
	_current_gm = packed.instantiate()

	var container: Node = $SQLOverlay/CenterContainer/PanelContainer/OuterVBox/ScrollContainer/GMContainer
	container.add_child(_current_gm)
	_current_gm.on_correct.connect(_on_gm_correct)
	_current_gm.setup(step)

	$SQLOverlay.visible  = true
	$DialogueBG.visible  = false
	$DialogueArea.visible = false

func _on_gm_correct() -> void:
	_close_overlay()
	_step += 1
	_run_step()

# ── Navigation ────────────────────────────────────────────
func _on_next() -> void:
	_step += 1
	_run_step()

func _on_back() -> void:
	# If overlay is open, close it first — player returns to the
	# dialogue step that came just before this SQL challenge
	_close_overlay()
	# Go back one step (clamp at 0)
	_step = max(0, _step - 1)
	_run_step()

func _on_back_to_hub() -> void:
	_close_overlay()
	get_tree().root.get_node("Main").show_screen("dashboard")

# ── Helpers ───────────────────────────────────────────────
func _close_overlay() -> void:
	$SQLOverlay.visible   = false
	$DialogueBG.visible   = true
	$DialogueArea.visible = true
	_clear_gm()

func _clear_gm() -> void:
	if _current_gm != null and is_instance_valid(_current_gm):
		_current_gm.queue_free()
		_current_gm = null

func _get_story(id) -> Array:
	var script: Node
	if GameManager.world == "hotel":
		script = preload("res://scripts/data/HotelData.gd").new()
	else:
		script = preload("res://scripts/data/FFData.gd").new()

	var result: Array = []
	if script.LESSONS.has(id):
		result = script.LESSONS[id].duplicate(true)
	else:
		push_error("GameScreen: lesson id not found: " + str(id))

	script.free()
	return result
