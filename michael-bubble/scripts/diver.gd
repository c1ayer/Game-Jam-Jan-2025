extends CharacterBody2D

@export var speed = 300  # Adjust for balance
@export var rotation_speed = 3  # Adjust for balance
@export var deceleration = 200  # Rate at which the velocity decreases
@export var forward_multiplier = 1.2  # Speed multiplier for moving forward
@export var backward_multiplier = 0.6  # Speed multiplier for moving backward
@export var harpoon_scene: PackedScene  # Drag Harpoon.tscn here
@export var harpoon_offset = 50  # Distance in front of the diver to spawn the harpoon

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

func shoot_harpoon():
	if harpoon_scene == null:
		print("Error: Harpoon scene is not assigned!")
		return

	# Instance the harpoon
	var harpoon_instance = harpoon_scene.instantiate()
	if harpoon_instance:
		# Spawn the harpoon slightly in front of the diver
		var spawn_offset = Vector2(cos(rotation), sin(rotation)) * harpoon_offset
		harpoon_instance.global_position = global_position + spawn_offset
		harpoon_instance.rotation = rotation  # Match the diver's current rotation
		get_tree().root.add_child(harpoon_instance)  # Add harpoon to the scene tree
	else:
		print("Error: Failed to instance harpoon!")

func _physics_process(delta):
	get_input(delta)
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):  # Bind this action in the Input Map
		shoot_harpoon()
