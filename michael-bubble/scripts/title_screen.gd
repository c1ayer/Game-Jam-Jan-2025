extends Node2D

#sound fx from https://pixabay.com/sound-effects/brittany-island-seacost-23077/
			 # https://pixabay.com/sound-effects/waves-18067/
			 # https://pixabay.com/sound-effects/underwater-waves-5983/

var game_scene:PackedScene

var btn:TextureButton
var fade:ColorRect

var wave:TextureRect
var start_pos:Vector2

const recede:Vector2 = Vector2(-1200, 2200)

var is_recede = true
var is_fade_out = false

# Called when the node enters the scene tree for the first time.
func _ready():
	btn = $Control/btn
	fade = $Control/fade2blue
	wave = $Control/wave
	start_pos = wave.position
	game_scene = preload("res://scenes/Game.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(is_recede):
		true:
			if wave.position.x > recede.x:
				wave.position += Vector2(-5, 4) * (80 + abs(wave.position.distance_to(start_pos))) / 400
			else:
				is_recede = false
		false:
			if wave.position.x < start_pos.x:
				wave.position -= Vector2(-5, 4) * (80 + abs(wave.position.distance_to(start_pos))) / 400
			else:
				is_recede = true
	if is_fade_out:
		if fade.color.a < 1.5:
			fade.color.a += 0.01
			print(fade.modulate.a)
		else:
			get_tree().change_scene_to_packed(game_scene)


func _on_btn_pressed():
	is_fade_out = true
