extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/HotelButton.pressed.connect(_on_hotel)
	$CenterContainer/VBoxContainer/FastFoodButton.pressed.connect(_on_fastfood)

func _on_hotel() -> void:
	GameManager.world = "hotel"
	get_tree().root.get_node("Main").show_screen("dashboard")

func _on_fastfood() -> void:
	GameManager.world = "fastfood"
	get_tree().root.get_node("Main").show_screen("dashboard")
