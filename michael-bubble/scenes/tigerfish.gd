extends CharacterBody2D


@onready var player: Node2D = $"../Player/CharacterBody2D"

var aggro = false


func _physics_process(delta: float) -> void:
	if aggro == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 200.0
		rotation = direction.angle()
		move_and_slide()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	aggro = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	aggro = false
