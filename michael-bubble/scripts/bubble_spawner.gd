extends Node2D

@onready var bubble = preload("res://scenes/bubble.tscn")
var MIN_SPAWN_X = 1
var MAX_SPAWN_X = 1000
var MIN_SPAWN_Y = 1
var MAX_SPAWN_Y = 1000

func _on_timer_timeout() -> void:
	var bub = bubble.instantiate()
	bub.position.x = randf_range(MIN_SPAWN_X, MAX_SPAWN_X)
	bub.position.y = randf_range(MIN_SPAWN_Y, MAX_SPAWN_Y)
	print("bubble spawned")
	add_child(bub)
