extends StaticBody3D

#stats
@export var max_bullet_count : int = 200
var bullet_count : int = max_bullet_count
@export var base_shooting_speed : float = 2
var shooting_speed : float = base_shooting_speed #time in seconds it takes to shoot
@export var base_range : float = 30
var range : float = base_range
@export var base_damage : int = 2
var damage : int = base_damage
var can_shoot : bool = false
var aim_type : String = "first" #to support switching aim types if I implement it
var companion: Node3D
var temp_companion_access: PackedScene = preload("res://Objects/companion_template.tscn")
var bullet : PackedScene = preload("res://Objects/bullet.tscn")
var current_targets : Array = []
var curr : CharacterBody3D

func _ready():
	$ShotCooldown.wait_time = 1.0 / shooting_speed
	assign_companion(temp_companion_access.instantiate())

func _process(delta):
	if is_instance_valid(curr):
		#add stuff to make the companion models look at the target
		if can_shoot:
			shoot()
			can_shoot = false
			$ShotCooldown.start()

func assign_companion(node : Node3D) -> void:
	companion = node
	can_shoot = true #allows for companion reassignment cheese to increase attack speed
	range = base_range + (base_range * companion.range_mult * 0.1)
	damage = base_damage + (base_damage * companion.damage_mult * 0.1)
	shooting_speed = base_shooting_speed + (base_shooting_speed * companion.shooting_speed_mult * 0.1)
	$ShotCooldown.wait_time = 1.0 / shooting_speed
	print(range)
	print(damage)
	print(shooting_speed)

func choose_target(_current_targets : Array) -> void:
	var temp_array : Array = _current_targets
	var current_target : CharacterBody3D = null
	for i in temp_array:
		if (current_target == null):
			current_target = i
		elif aim_type == "first" and i.get_parent().get_progress() > current_target.get_parent().get_progress():
			current_target = i
	curr = current_target

func shoot() -> void:
	choose_target(current_targets)
	var temp_bullet : CharacterBody3D = bullet.instantiate()
	temp_bullet.target = curr
	temp_bullet.damage = base_damage
	get_node("BulletContainer").add_child(temp_bullet)
	temp_bullet.global_position = $"Tower Mesh/Aim".global_position

func _on_enemy_detector_body_entered(body):
	if body.is_in_group("Enemy"):
		current_targets.append(body)
		choose_target(current_targets)
		

func _on_enemy_detector_body_exited(body):
	if body.is_in_group("Enemy"):
		current_targets.erase(body)
		choose_target(current_targets)


func _on_shot_cooldown_timeout():
	can_shoot = true
	
