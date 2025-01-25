extends Area2D

# Signal to notify when the harpoon attaches to a valid object
signal attached(hit_body)

@export var speed = 600  # Speed of the harpoon
@export var max_distance = 500  # Maximum range of the harpoon
var direction = Vector2.ZERO  # Direction the harpoon is moving
var traveled_distance = 0  # Tracks how far the harpoon has traveled

func _ready():
	$Timer.start()  # Start the timer for despawning the harpoon after a timeout

func initialize(start_position, direction_vector):
	# Set the initial position and direction of the harpoon
	global_position = start_position
	direction = direction_vector.normalized()

func _process(delta):
	# Move the harpoon in the specified direction
	var move_vector = direction * speed * delta
	position += move_vector
	traveled_distance += move_vector.length()

	# Check if the harpoon has exceeded its maximum range
	if traveled_distance >= max_distance:
		queue_free()  # Remove the harpoon if it exceeds its range

func _on_Area2D_body_entered(body):
	# When the harpoon hits something
	if body.is_in_group("hookable"):  # Check if the object is in the "hookable" group
		speed = 0  # Stop the harpoon's movement
		emit_signal("attached", body)  # Emit the attached signal with the hit object
		queue_free()  # Remove the harpoon after attaching

func _on_Timer_timeout():
	# Remove the harpoon when the timer times out
	queue_free()
