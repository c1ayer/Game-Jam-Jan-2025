extends Area2D

@export var speed = 850  # Speed of the harpoon
@export var max_distance = 1000  # Maximum range of the harpoon
var traveled_distance = 0  # Tracks how far the harpoon has traveled

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

func _on_Area2D_body_entered(body):
	# Handle collision with other objects
	if body.is_in_group("mobs"):  # Adjust this to fit your group names
		body.queue_free()  # Destroy the hit object
	queue_free()  # Destroy the harpoon after impact
