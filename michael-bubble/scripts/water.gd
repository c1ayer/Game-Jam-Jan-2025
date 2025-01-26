extends RigidBody2D
@export var waterNumber = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	var collision_info = move_and_collide(linear_velocity * delta)
	#if collision_info and collision_info.get_collider().is_class('StaticBody2D') and randf()>.98:
		#var direction = collision_info.get_collider().get_child(0).shape.normal
		#if direction.y == 0:
			#position = position + direction*1000
			#linear_velocity = Vector2(0,0)
		#if direction.x == 0:
			#position = position + direction*500
			#linear_velocity = Vector2(0,0)
	if collision_info and collision_info.get_normal().length() == 1:
			linear_velocity = linear_velocity.bounce(collision_info.get_normal())*.5 #not sure how much energy lost in bounce
	#if linear_velocity.length()>100:
		#linear_velocity = linear_velocity*.5
		
func NearPlayer():
	pass
