extends Node2D

@onready var bubble = preload("res://scenes/bubble.tscn")
@onready var screenSize = get_viewport().get_visible_rect().size


var MIN_BUBBLE_SCALE = 0.5
var MAX_BUBBLE_SCALE = 2
var MAX_NUM_BUBBLES = 10

var num_bubbles = 0


signal increase_oxygen

func _on_timer_timeout() -> void:
	if (num_bubbles > MAX_NUM_BUBBLES) :
		return
	var bub = bubble.instantiate()
	bub.position.x = randf_range(0, screenSize.x)
	# Always spawn on bottom half
	bub.position.y = randf_range(screenSize.y/2, screenSize.y)
	bub.scale *= randf_range(MIN_BUBBLE_SCALE, MAX_BUBBLE_SCALE)
	bub.connect("player_popped", _on_player_pop_bubble)
	num_bubbles += 1
	print("bubbles = " + str(num_bubbles))
	add_child(bub)


func _on_child_exiting_tree(node: Node) -> void:
	#if Bubble is removed we decrease active bubble count
	num_bubbles -= 1
	
	
func _on_player_pop_bubble() :
	emit_signal("increase_oxygen")
