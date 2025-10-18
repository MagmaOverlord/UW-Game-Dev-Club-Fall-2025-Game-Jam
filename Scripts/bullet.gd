extends CharacterBody3D

var target : CharacterBody3D
@export var speed : int = 20
var damage : int

func _physics_process(delta):
	#current issue: if the tower is too high fire rate, can shoot more bullets at an enemy
	#that is already going to die
	if is_instance_valid(target):
		velocity = global_position.direction_to(target.global_position) * speed
		look_at(target.global_position)
		
		move_and_slide()
	else:
		queue_free()


func _on_collision_body_entered(body):
	if body.name.match(target.name): #need to test
		body.take_damage(damage)
		queue_free()
