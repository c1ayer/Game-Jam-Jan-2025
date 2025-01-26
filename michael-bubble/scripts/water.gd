extends RigidBody2D
@export var waterNumber = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info and collision_info.get_normal().length() == 1:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())*.5 #not sure how much energy lost in bounce
		
func NearPlayer():
	pass
