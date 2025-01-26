extends RigidBody2D

signal player_popped

func _on_area_2d_area_entered(_area: Area2D) -> void:
	print("pop")
	# TODO: Trigger Oxygen Bump if Body is Player
	emit_signal("player_popped")
	# TODO: Play Animation and Sound
	queue_free()
