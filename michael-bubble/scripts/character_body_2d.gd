extends CharacterBody2D

@export var speed = 300  #play around with speed for balance
@export var rotation_speed = 3  #play around with rotation speed for balance
@export var deceleration = 200  # Rate at which the velocity decreases
@export var forward_multiplier = 1.2  # Speed multiplier for moving forward
@export var backward_multiplier = 0.6  # Speed multiplier for moving backward

var rotation_direction = 0

func get_input(delta):
	rotation_direction = Input.get_axis("move_left", "move_right")
	var input_direction = Input.get_axis("move_down", "move_up")
	
	if input_direction != 0:
		# Apply a multiplier for forward or backward movement
		if input_direction > 0:
			velocity = transform.x * input_direction * speed * forward_multiplier
		else:
			velocity = transform.x * input_direction * speed * backward_multiplier
	else:
		# Decelerate if no input is given
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

func _physics_process(delta):
	get_input(delta)
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
