extends Node2D
	
@onready var anim := $casa3

func _ready() -> void:
	anim.play("casa2")
