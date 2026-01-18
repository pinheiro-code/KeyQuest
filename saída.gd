extends Area2D

@export var needs_key: bool = true
@export_file("*.tscn") var victory_scene_path := "res://cenas/victory.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not (body is Player):
		return
	if needs_key and not body.has_key:
		return
	get_tree().change_scene_to_file(victory_scene_path)
