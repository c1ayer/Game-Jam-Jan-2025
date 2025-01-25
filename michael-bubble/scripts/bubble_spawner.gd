extends Node2D

@onready var bubble = preload("res://scenes/bubble.tscn")
var MIN_SPAWN_X = 1
var MAX_SPAWN_X = 1000
var MIN_SPAWN_Y = 1
var MAX_SPAWN_Y = 1000
var num_bubbles = 0
var MAX_NUM_BUBBLES = 10

func _on_timer_timeout() -> void:
	if (num_bubbles > MAX_NUM_BUBBLES) :
		pass
	var bub = bubble.instantiate()
	bub.position.x = randf_range(MIN_SPAWN_X, MAX_SPAWN_X)
	bub.position.y = randf_range(MIN_SPAWN_Y, MAX_SPAWN_Y)
	num_bubbles += 1
	print("bubbles = " + str(num_bubbles))
	add_child(bub)


func _on_child_exiting_tree(node: Node) -> void:
	#if Bubble is removed we decrease active bubble count
	num_bubbles -= 1
