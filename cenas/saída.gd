extends Area2D

@export var needs_key: bool = true
@export_node_path(Control) var victory_ui_path  # arraste o nó VictoryUI aqui pelo Inspector

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not (body is Player):
		return
	if needs_key and not body.has_key:
		return

	var ui := get_node(victory_ui_path) as Control
	if ui:
		# garanta que a UI processa mesmo com o jogo pausado
		ui.process_mode = Node.PROCESS_MODE_ALWAYS
		ui.visible = true
		get_tree().paused = true
