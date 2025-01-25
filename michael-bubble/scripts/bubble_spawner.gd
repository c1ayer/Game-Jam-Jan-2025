extends Node2D

@onready var bubble = preload("res://scenes/bubble.tscn")

func _on_timer_timeout() -> void:
	var bub = bubble.instantiate()
	bub.position = position
	print("bubble spawned")
	add_child(bub)
