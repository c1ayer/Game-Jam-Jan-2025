extends Node2D

@onready var death_screen = preload("res://scenes/death_screen_overlay.tscn")

signal oxygen_bar_increase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bubble_spawner_increase_oxygen() -> void:
	emit_signal("oxygen_bar_increase")

func _on_oxygen_bar_oxygen_death() -> void:
	Engine.time_scale = 0.2
	var screen = death_screen.instantiate()
	screen.connect("button_pressed", _restart_game)
	add_child(screen)
	
func _restart_game() :
	get_tree().reload_current_scene()
