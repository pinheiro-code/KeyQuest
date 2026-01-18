extends Control

@export var menu_button_path: NodePath
@onready var menu_btn: Button = get_node(menu_button_path) as Button

func _ready() -> void:
	get_tree().paused = false
	if is_instance_valid(menu_btn):
		menu_btn.pressed.connect(_on_menu_pressed)
	else:
		push_error("Victory: defina menu_button_path apontando para o botão.")

func _on_menu_pressed() -> void:
	print("VICTORY: clique no menu")
	get_tree().paused = false
	var err := get_tree().change_scene_to_file("res://cenas/menu.tscn")
	if err != OK:
		push_error("Victory: falha ao trocar pra menu.tscn (código %s)" % err)
