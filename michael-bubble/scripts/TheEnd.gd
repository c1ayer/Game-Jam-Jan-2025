extends Control
var start_scene:PackedScene
var bkg:TextureRect
var text1:TextureRect
var text2:TextureRect
var timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	start_scene = preload("res://scenes/title_screen.tscn")
	text1 = $text1
	text2 = $text2
	timer = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var timeouts = 0
func _on_timer_timeout():
	match(timeouts):
		0:
			timer.wait_time = 7
			timeouts += 1
			text1.visible = true
			
		1:
			timeouts += 1
			text2.visible = true
		2:
			get_tree().change_scene_to_packed(start_scene)
