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
	call_deferred("_go_victory")

func _go_victory() -> void:
	get_tree().paused = false
	print("EXIT DEBUG: trocando para -> ", victory_scene_path)

	var packed := ResourceLoader.load(victory_scene_path)
	if packed is PackedScene:
		var err := get_tree().change_scene_to_packed(packed)
		if err != OK:
			push_error("EXIT ERROR: change_scene falhou (%s)" % err)
	else:
		push_error("EXIT ERROR: cena não encontrada -> %s" % victory_scene_path)
