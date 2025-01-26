extends Node2D

@onready var tiger_fish = preload("res://scenes/tigerfish.tscn")

signal decrease_oxygen_signal

func _ready() -> void:
	print("hi")
	_spawn_fish(1064, -241)
	_spawn_fish(1812, 307)
	_spawn_fish(2233, -441)
	_spawn_fish(2350, -705)
	_spawn_fish(3101, -705)
	_spawn_fish(3101, -1319)
	_spawn_fish(2358, -1319)
	_spawn_fish(5247, -1804)
	_spawn_fish(1675, -462)
	_spawn_fish(189, -1376)
	_spawn_fish(-615, 327)
	
func _spawn_fish(x, y):
	var fish = tiger_fish.instantiate()
	fish.position.x = x
	fish.position.y = y
	fish.connect("hurt_player", _decrease_oxygen)
	add_child(fish)
	
func _decrease_oxygen() :
	print("decreased")
	emit_signal("decrease_oxygen_signal")
