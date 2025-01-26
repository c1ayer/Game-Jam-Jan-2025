extends Node2D
var end_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	end_scene = preload("res://scenes/Game.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	get_tree().change_scene_to_packed(end_scene)
