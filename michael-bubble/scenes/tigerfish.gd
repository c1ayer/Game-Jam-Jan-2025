extends CharacterBody2D


@onready var player: Node2D = $"../Player/CharacterBody2D"

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100.0
	move_and_slide()
