extends CharacterBody2D

@export var speed = 300  # Adjust for balance
@export var rotation_speed = 3  # Adjust for balance
@export var deceleration = 200  # Rate at which the velocity decreases
@export var forward_multiplier = 1.2  # Speed multiplier for moving forward
@export var backward_multiplier = 0.6  # Speed multiplier for moving backward
@export var harpoon_scene: PackedScene  # Harpoon.tscn here

var rotation_direction = 0
var harpoon_instance = null  # Store a reference to the harpoon

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
	if harpoon_instance == null:  # Only allow one harpoon at a time
		# Ensure the harpoon scene is assigned
		if harpoon_scene == null:
			print("Error: Harpoon scene is not assigned!")
			return
		
		# Instance the harpoon scene and add it to the scene tree
		harpoon_instance = harpoon_scene.instantiate()
		if harpoon_instance:
			# Set the position and direction of the harpoon based on the diver's current position and direction
			harpoon_instance.initialize(global_position, transform.x)  # Initialize the harpoon with the correct position and direction
			get_tree().root.add_child(harpoon_instance)  # Add it to the scene tree
		else:
			print("Error: Failed to instance harpoon scene!")

func _physics_process(delta):
	get_input(delta)
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):  # Bind this action in the Input Map
		shoot_harpoon()
