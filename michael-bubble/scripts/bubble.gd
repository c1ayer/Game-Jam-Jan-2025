extends Area2D

@onready var gameManager = $GameManager

func _on_body_entered(body):
	print("pop")
	# TODO: Trigger Oxygen Bump if Body is Player
	# TODO: Play Animation and Sound
	queue_free()
	
