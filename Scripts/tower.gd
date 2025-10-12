extends Node3D

#stats
@export var bullets: int = 200
@export var base_shooting_speed: float = 0.5
@export var base_range: float = 30
@export var base_damage: int = 2

@export var companion: Node3D

@onready var circle_indicator = get_child(1)
@onready var game_manager = get_tree().get_first_node_in_group("GameManager")

func _ready():
	circle_indicator.scale *= base_range

func _process(delta):
	pass
