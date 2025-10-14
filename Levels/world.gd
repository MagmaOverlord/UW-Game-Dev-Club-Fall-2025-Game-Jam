extends Node3D

@onready var basic_enemy : PackedScene = preload("res://Objects/Enemies/enemy_template.tscn")

var enemies_to_spawn : int = 5
var can_spawn : bool = true;

func _process(delta):
	game_manager()
	
func game_manager() -> void:
	if (can_spawn and enemies_to_spawn > 0):
		$SpawnTimer.start()
		
		var tempEnemy = basic_enemy.instantiate()
		$Path3D.add_child(tempEnemy)
		enemies_to_spawn -= 1
		can_spawn = false

func _on_spawn_timer_timeout():
	can_spawn = true
