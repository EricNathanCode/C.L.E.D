extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/BackToHubButton.pressed.connect(_on_back)
	$CenterContainer/VBoxContainer/ChangeWorldButton.pressed.connect(_on_change_world)

func _on_back() -> void:
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_change_world() -> void:
	get_tree().root.get_node("Main").show_screen("world_select")
