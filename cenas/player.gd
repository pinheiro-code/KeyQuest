extends CharacterBody2D

class_name Player

@export_group("Locomotion")
@export var speed = 200
@export var jump_velocity = -350
@export var run_speed_damping = 0.5

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -250

@export_group("Fall Death")
@export var fall_death_height: float = 300.0  
@export var fall_death_speed: float  = 900.0  
@export var fall_debug: bool = false          

var falling: bool = false          
var fall_start_y: float = 0.0     
var max_fall_speed: float = 0.0   


var has_key: bool = false
func obtain_key() -> void:
	has_key = true
	


var is_dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	
	if not is_on_floor():
		falling = true
		fall_start_y = global_position.y
		max_fall_speed = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
		if not falling:
			falling = true
			fall_start_y = global_position.y
			max_fall_speed = 0.0
		
		if velocity.y > max_fall_speed:
			max_fall_speed = velocity.y

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	var direction = Input.get_axis("left","right")
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)

	$AnimatedSprite2D.trigger_animation(velocity, direction)

	move_and_slide()

	if is_on_floor() and falling:
		var fall_distance := global_position.y - fall_start_y
		if fall_debug:
			print("Fall -> dist:", fall_distance, "  peak_speed:", max_fall_speed)
		if fall_distance >= fall_death_height or max_fall_speed >= fall_death_speed:
			_die()
		falling = false   

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not(area is Enemy) and is_dead:
		return

	if area is Koopa and (area as Koopa).in_a_shell:
		(area as Koopa)._on_stomp(global_position)
		return

	var angle = rad_to_deg((position.angle_to_point((area as Enemy).position)))
	if angle > min_stomp_degree and angle < max_stomp_degree:
		(area as Enemy)._die()
		velocity.y = stomp_y_velocity
	else:
		_die()

func _die():
	if is_dead:
		return
	is_dead = true

	velocity = Vector2.ZERO
	set_physics_process(false)

	# Animação de morte
	$AnimatedSprite2D.play("small_death")

	area_2d.set_collision_layer_value(1, false)
	area_2d.set_collision_mask_value(3, false)
	area_2d.set_collision_mask_value(4, false)

	var t := get_tree().create_tween()
	t.tween_property($AnimatedSprite2D, "position:y", $AnimatedSprite2D.position.y - 20, 0.25)
	t.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.45).set_delay(0.05)          
	t.tween_callback(func (): get_tree().reload_current_scene())
