extends CharacterBody3D

@export var hp: int = 20
@export var speed: float = 2
@export var damage: int = 1
@export var attack_speed : int = 1
@onready var Path : PathFollow3D = get_parent()
@onready var AnimPlayer : AnimationPlayer = get_node("humanoid/AnimationPlayer")

var state = "moving"

func _ready():
	AnimPlayer.play("ZombiePose")

func _physics_process(delta):
	if state == "moving":
		Path.set_progress(Path.get_progress() + (speed * delta))
		if Path.get_progress_ratio() >= 0.99:
			state = "attacking"
			Path.queue_free()
	elif state == "attacking":
		#do damage as per attack speed
		pass


func take_damage(damage : int) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()
