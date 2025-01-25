extends Node2D

signal oxygen_bar_increase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#decrease oxygen
	pass

func _on_bubble_spawner_increase_oxygen() -> void:
	emit_signal("oxygen_bar_increase")
	pass # Replace with function body.
