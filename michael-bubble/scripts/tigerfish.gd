extends Area2D

const SPEED = 100
var direction = 1
@onready var timer: Timer = $Timer



	
func _on_body_entered(body: Node2D) -> void:
	print("Test!")
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta
