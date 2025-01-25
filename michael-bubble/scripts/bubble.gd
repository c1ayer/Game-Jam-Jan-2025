extends Area2D

signal player_popped

func _on_body_entered(body):
	print("pop")
	# TODO: Trigger Oxygen Bump if Body is Player
	emit_signal("player_popped")
	# TODO: Play Animation and Sound
	queue_free()
	
