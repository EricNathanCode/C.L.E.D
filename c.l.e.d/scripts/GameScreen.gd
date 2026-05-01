extends Control
# ═══════════════════════════════════════════════════════
#  GAME SCREEN  —  scripts/GameScreen.gd
#
#  Story engine. Reads steps from HotelData / FFData,
#  walks them in order:
#    dialogue  → show name + text, wait for Next click
#    sql_choice → load GM_Select,     call setup(), show overlay
#    sql_fill   → load correct GM_*,  call setup(), show overlay
#    end        → go to complete screen
#
#  When a GM_ scene emits on_correct → close overlay, next step.
# ═══════════════════════════════════════════════════════

# ── Gamemode scene paths (global — shared by all lessons) ──
const GM_SCENES: Dictionary = {
	"select":       "res://gamemode/scene/GM_Select.tscn",
	"insert_into":  "res://gamemode/scene/GM_InsertInto.tscn",
	"select_where": "res://gamemode/scene/GM_SelectWhere.tscn",
	"update_set":   "res://gamemode/scene/GM_UpdateSet.tscn",
	"delete":       "res://gamemode/scene/GM_Delete.tscn",
	"order_by":     "res://gamemode/scene/GM_OrderBy.tscn",
	"group_by":     "res://gamemode/scene/GM_GroupBy.tscn",
}

# ── Story state ───────────────────────────────────────────
var _story: Array  = []
var _step:  int    = 0
var _current_gm:   Node = null

func _ready() -> void:
	$TopBar/BackToHubButton.pressed.connect(_on_back_to_hub)
	$DialogueArea/NextButton.pressed.connect(_on_next)

# ── Called by Main.gd when entering game screen ───────────
func load_lesson(id) -> void:
	_story = _get_story(id)
	_step  = 0
	$TopBar/LessonLabel.text = "Lesson: " + str(id)
	_close_overlay()
	_run_step()

# ── Story engine ─────────────────────────────────────────
func _run_step() -> void:
	if _step >= _story.size():
		get_tree().root.get_node("Main").show_screen("complete")
		return

	var s: Dictionary = _story[_step]

	match s["type"]:
		"dialogue":
			$DialogueArea/CharacterName.text  = s.get("name", "")
			$DialogueArea/DialogueText.text   = s.get("text", "")
			$DialogueArea/NextButton.visible  = true

		"sql_choice":
			$DialogueArea/NextButton.visible = false
			_show_challenge(s, "select")

		"sql_fill":
			$DialogueArea/NextButton.visible = false
			_show_challenge(s, s.get("gamemode", ""))

		"end":
			get_tree().root.get_node("Main").show_screen("complete")

# ── Load and show a GM_ challenge scene ───────────────────
func _show_challenge(step: Dictionary, gm_key: String) -> void:
	var path: String = GM_SCENES.get(gm_key, "")
	if path.is_empty():
		push_error("GameScreen: unknown gamemode key: " + gm_key)
		return

	# Clear any previous GM_ instance
	_clear_gm()

	# Instance the GM_ scene
	var packed: PackedScene = load(path)
	_current_gm = packed.instantiate()

	# Add to GMContainer
	var container: Node = $SQLOverlay/CenterContainer/PanelContainer/ScrollContainer/GMContainer
	container.add_child(_current_gm)

	# Connect the correct signal
	_current_gm.on_correct.connect(_on_gm_correct)

	# Feed data to the GM_ scene
	_current_gm.setup(step)

	# Show the overlay
	$SQLOverlay.visible = true

# ── GM_ scene completed correctly ────────────────────────
func _on_gm_correct() -> void:
	_close_overlay()
	_step += 1
	_run_step()

# ── Advance dialogue ──────────────────────────────────────
func _on_next() -> void:
	_step += 1
	_run_step()

# ── Navigation ────────────────────────────────────────────
func _on_back_to_hub() -> void:
	_close_overlay()
	get_tree().root.get_node("Main").show_screen("dashboard")

# ── Helpers ───────────────────────────────────────────────
func _close_overlay() -> void:
	$SQLOverlay.visible = false
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
