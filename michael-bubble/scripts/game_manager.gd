extends Node2D

@onready var death_screen = preload("res://scenes/death_screen_overlay.tscn")
@onready var dead_diver = preload("res://scenes/death_diver.tscn")

signal oxygen_bar_increase
signal oxygen_bar_decrease

var death_occurred = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bubble_spawner_increase_oxygen() -> void:
	emit_signal("oxygen_bar_increase")
	if randi_range(1,2) == 1:
		$PopSound.play()
	else :
		$PopSound2.play()
	

func _on_oxygen_bar_oxygen_death() -> void:
	if (death_occurred) :
		return
	Engine.time_scale = 0.2
	#var screen = death_screen.instantiate()
	#screen.position = get_viewport().get_camera_2d().get_screen_center_position()
	#screen.connect("button_pressed", _restart_game)
	var DeathDiver = dead_diver.instantiate()
	DeathDiver.global_position = get_viewport().get_camera_2d().get_screen_center_position()
	DeathDiver.connect("button_pressed", _restart_game)
	%Player.queue_free()
	death_occurred = true
	add_child(DeathDiver)
	#add_child(screen)
	
func _restart_game() :
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_fish_spawner_decrease_oxygen_signal() -> void:
	print("decrease oxygen from manager")
	if randi_range(1,2) == 1:
		$BiteSound.play()
	else :
		$BiteSound2.play()
	emit_signal("oxygen_bar_decrease")
	
