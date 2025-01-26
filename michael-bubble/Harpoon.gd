extends Area2D

@export var speed = 1200  # Speed of the harpoon
@export var max_distance = 1000  # Maximum range of the harpoon
var traveled_distance = 0  # Tracks how far the harpoon has traveled

# Signal to notify when the harpoon is done (hit an object or exceeds max distance)
signal done

func _ready():
	# Harpoon starts moving forward automatically on spawn
	set_process(true)

func _physics_process(delta):
	# Calculate the forward movement direction based on rotation
	var move_vector = Vector2(cos(rotation), sin(rotation)) * speed * delta
	position += move_vector
	traveled_distance += move_vector.length()

	# Remove the harpoon if it exceeds its maximum range
	if traveled_distance >= max_distance:
		queue_free()
		emit_signal("done")  # Signal that the harpoon is done

func _on_Area2D_body_entered(body):
	# Handle collision with other objects
	if body.is_in_group("fish"): 
		body.queue_free()  # Destroy the hit object
	queue_free()  # Destroy the harpoon after impact
	emit_signal("done")  # Signal that the harpoon is done
