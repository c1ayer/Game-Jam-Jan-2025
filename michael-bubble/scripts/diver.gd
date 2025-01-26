extends CharacterBody2D

@export var speed = 300  # Adjust for balance
@export var rotation_speed = 4  # Adjust for balance
@export var deceleration = 200  # Rate at which the velocity decreases
@export var forward_multiplier = 1.2  # Speed multiplier for moving forward
@export var backward_multiplier = 0.6  # Speed multiplier for moving backward
@export var harpoon_scene: PackedScene  # Drag Harpoon.tscn here
@export var harpoon_offset = 50  # Distance in front of the diver to spawn the harpoon
@export var harpoon_cooldown = .25  # Cooldown time in seconds

var rotation_direction = 0
var can_shoot = true  # Flag to track whether the harpoon can be fired

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
	if not can_shoot or harpoon_scene == null:
		return  # Prevent firing if cooldown is active or scene is missing

	# Instance the harpoon
	var harpoon_instance = harpoon_scene.instantiate()
	if harpoon_instance:
		# Calculate the spawn position for the harpoon, based on the diver's rotation.
		# Spawn the harpoon slightly in front and a little above the diver
		var spawn_offset = Vector2(cos(rotation), sin(rotation)) * harpoon_offset  # Forward offset

		# Combine the forward and upward offsets
		var spawn_position = global_position

		# Set the harpoon's position and rotation
		harpoon_instance.global_position = spawn_position
		harpoon_instance.rotation = rotation  # Match the diver's current rotation
		
		# Add harpoon to the scene tree
		get_tree().root.add_child(harpoon_instance)

		# Disable shooting and start the cooldown
		can_shoot = false
		await get_tree().create_timer(harpoon_cooldown).timeout  # Wait for cooldown duration
		can_shoot = true
	else:
		print("Error: Failed to instance harpoon!")


func _physics_process(delta):
	get_input(delta)
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):  # Bind this action in the Input Map
		shoot_harpoon()
		
		
func _on_water_reflector_body_entered(body):
	if body.has_method('NearPlayer'):
		body.linear_velocity += velocity *.5
