extends Control

# Constants can be updated to variable
var MAX_OXYGEN = 100
var OXYGEN_DEPLETE_RATE = 20
var OXYGEN_INCREASE_RATE = 20
# Variables
var current_oxygen = MAX_OXYGEN
@onready var oxygen_bar = %TextureProgressBar

signal oxygen_death

func _on_timer_timeout() -> void:
	current_oxygen -= OXYGEN_DEPLETE_RATE
	if (current_oxygen <= 0) :
		emit_signal("oxygen_death")
	oxygen_bar.value = current_oxygen
	print("Oxygen is " + str(current_oxygen))


func _on_game_manager_oxygen_bar_increase() -> void:
	current_oxygen += OXYGEN_INCREASE_RATE
	if (current_oxygen > MAX_OXYGEN) :
		current_oxygen = MAX_OXYGEN
	oxygen_bar.value = current_oxygen
	print("Oxygen is " + str(current_oxygen))
