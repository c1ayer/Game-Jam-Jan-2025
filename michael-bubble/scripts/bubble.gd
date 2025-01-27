extends RigidBody2D

signal player_popped

func _process(delta: float) -> void:
	if position.y < -5000:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("pop")
	emit_signal("player_popped")
	# TODO: Play Animation and Sound
	queue_free()
