extends Control

func _ready() -> void:
	# ajuste os nomes conforme seus nós/botões
	$VBoxContainer/Button.pressed.connect(_on_restart_pressed)
	if $VBoxContainer.get_child_count() > 2 and $VBoxContainer.get_child(2) is Button:
		$VBoxContainer.get_child(2).pressed.connect(_on_menu_pressed)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/menu.tscn") # ajuste se quiser
