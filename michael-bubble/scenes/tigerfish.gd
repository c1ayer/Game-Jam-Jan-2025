extends CharacterBody2D


@onready var player: Node2D = $"../../../Player/PlayerBody"

signal hurt_player

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


func _on_kill_player_zone_body_entered(body: Node2D) -> void:
	if "PlayerBody" in body.name:
		print("bite")
		emit_signal("hurt_player")
	


func _on_harpoon_kill_zone_area_entered(area: Area2D) -> void:
	queue_free()
	area.queue_free()
