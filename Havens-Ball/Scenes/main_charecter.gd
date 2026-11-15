extends CharacterBody2D

const SPEED = 340.0
const JUMP_VELOCITY = -360.0

# Bounce & Feel Settings
const BOUNCINESS = 0.25      
const MIN_BOUNCE_SPEED = 50.0
const ACCELERATION = 700.0 
const FRICTION = 1000.0   

# Timers for better jump feel
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0


var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position

func respawn() -> void:
	velocity = Vector2.ZERO
	global_position = spawn_position


func _physics_process(delta: float) -> void:
	var fall_speed = velocity.y

	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = 0.12

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = 0.1
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0


	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 1

	#Smooth Ball Movement (accelerate and roll to a stop instead of freezing)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# 7. Move the character
	move_and_slide()

	#Apply Bounce upon landing
	if is_on_floor() and fall_speed > MIN_BOUNCE_SPEED:
		velocity.y = -fall_speed * BOUNCINESS
