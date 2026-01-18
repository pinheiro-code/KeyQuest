extends Node2D

@onready var anim := $casa1

func _ready() -> void:
	anim.play("casa2")
