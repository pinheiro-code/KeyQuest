extends Node2D
@onready var anim := $casa2

func _ready() -> void:
	anim.play("casa2")
