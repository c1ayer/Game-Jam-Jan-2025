extends Node2D

var fading = true
var pulsing_texture:TextureRect
func _ready():
	pulsing_texture = $TextureRect2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(fading):
		true:
			if pulsing_texture.modulate.a > 0:
				pulsing_texture.modulate.a -= 0.005
			else:
				fading = false
		false:
			if pulsing_texture.modulate.a < 1:
				pulsing_texture.modulate.a += 0.005
			else:
				fading = true
