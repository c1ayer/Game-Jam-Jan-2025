extends Node2D

@onready var tiger_fish = preload("res://scenes/tigerfish.tscn")

signal decrease_oxygen_signal

func _ready() -> void:
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
	_spawn_fish(4000, -1130)
	_spawn_fish(4010, -1110)
	_spawn_fish(4020, -1120)
	_spawn_fish(4030, -1100)
	_spawn_fish(-1197, -1022)
	_spawn_fish(-2226, -892)
	_spawn_fish(-2045, -1254)
	_spawn_fish(-2232, -1498)
	_spawn_fish(-1883, -1771)
	_spawn_fish(-2115, -1920)
	_spawn_fish(1496, -1963)
	_spawn_fish(138, -1754)
	_spawn_fish(3917, -2642)
	_spawn_fish(-643, 441)
	_spawn_fish(1546, -843) 

	
func _spawn_fish(x, y):
	var fish = tiger_fish.instantiate()
	fish.position.x = x
	fish.position.y = y
	fish.connect("hurt_player", _decrease_oxygen)
	add_child(fish)
	
func _decrease_oxygen() :
	print("decreased")
	emit_signal("decrease_oxygen_signal")
