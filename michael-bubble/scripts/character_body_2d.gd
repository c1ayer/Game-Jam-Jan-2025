extends CharacterBody2D

@export var speed = 300  # Adjust for balance
@export var rotation_speed = 3  # Adjust for balance
@export var deceleration = 200  # Rate at which the velocity decreases
@export var forward_multiplier = 1.2  # Speed multiplier for moving forward
@export var backward_multiplier = 0.6  # Speed multiplier for moving backward
@export var harpoon_scene: PackedScene  # Drag your Harpoon.tscn here

var rotation_direction = 0
var harpoon_instance = null  # Store a reference to the harpoon
var is_pulling = false
var pull_target_position = Vector2.ZERO  # Target position for pulling

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
		harpoon_instance = harpoon_scene.instance()
		if harpoon_instance:
			harpoon_instance.initialize(global_position, transform.x)  # Set its position and direction
			get_tree().root.add_child(harpoon_instance)  # Add to the root of the scene tree
			harpoon_instance.connect("attached", self, "_on_harpoon_attached")
		else:
			print("Error: Failed to instance harpoon scene!")

func _on_harpoon_attached(hit_body):
	is_pulling = true
	pull_target_position = hit_body.global_position  # Set the target position
	harpoon_instance = null  # Reset the harpoon instance reference

func _physics_process(delta):
	if is_pulling:
		# Pull the diver toward the target position
		var pull_vector = (pull_target_position - global_position).normalized()
		velocity = pull_vector * speed

		if global_position.distance_to(pull_target_position) < 10:  # Stop pulling when close enough
			is_pulling = false
			velocity = Vector2.ZERO  # Stop movement
	else:
		get_input(delta)
		rotation += rotation_direction * rotation_speed * delta
		move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):  # Bind this action in the Input Map
		shoot_harpoon()
