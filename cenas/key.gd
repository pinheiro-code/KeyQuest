extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.obtain_key()
		queue_free() # a chave some
