extends Node3D

#map generation
@export var map_length : int = 20
@export var map_height : int = 15
@export var min_path_size = 60
@export var max_path_size = 100
@export var min_loops = 3
@export var max_loops = 6
@export var tile_start : PackedScene
@export var tile_straight : PackedScene
@export var tile_corner : PackedScene
@export var tile_crossroads : PackedScene
@export var tile_empty : PackedScene
@export var tile_end : PackedScene

#player info
@export var playerHP: int = 100
@export var gold: int = 500
var companions = []

#game control
var is_round_ongoing: bool = true;
var round: int = 1;
var enemies_to_spawn : int = 5
var can_spawn : bool = true;
@onready var basic_enemy : PackedScene = preload("res://Objects/Enemies/enemy_template.tscn")
@onready var strong_enemy : PackedScene = preload("res://Objects/Enemies/enemy_strong_template.tscn")

## Assumes the path generator has finished, and adds the remaining tiles to fill in the grid.
func _ready():
	_complete_grid()

func _process(delta):
	game_manager()
	
func game_manager() -> void:
	if (is_round_ongoing and can_spawn and enemies_to_spawn > 1):
		$SpawnTimer.start()
		
		var tempEnemy = basic_enemy.instantiate()
		$Path3D.add_child(tempEnemy)
		enemies_to_spawn -= 1
		can_spawn = false
	elif (is_round_ongoing and can_spawn and enemies_to_spawn == 1):
		var tempEnemy = strong_enemy.instantiate()
		$Path3D.add_child(tempEnemy)
		enemies_to_spawn -= 1
		can_spawn = false

func _on_spawn_timer_timeout():
	can_spawn = true

func _add_curve_point(c3d:Curve3D, v3:Vector3) ->bool:
	c3d.add_point(v3)
	return true
	
func _pop_along_grid():
	var c3d:Curve3D = Curve3D.new()
	
	for element in PathGenInstance.get_path_route():
		c3d.add_point(Vector3(element.x, 0, element.y))

	$Path3D.curve = c3d
	

func _complete_grid():
	for x in range(PathGenInstance.path_config.map_length):
		for y in range(PathGenInstance.path_config.map_height):
			if not PathGenInstance.get_path_route().has(Vector2i(x,y)):
				var tile:Node3D = tile_empty.instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
				tile.global_rotation_degrees = Vector3(0, randi_range(0,3)*90, 0)
	
	
	for i in range(PathGenInstance.get_path_route().size()):
		var tile_score:int = PathGenInstance.get_tile_score(i)
		
		var tile:Node3D = tile_empty.instantiate()
		var tile_rotation: Vector3 = Vector3.ZERO
		
		if tile_score == 2:
			tile = tile_end.instantiate()
			tile_rotation = Vector3(0,-90,0)
		elif tile_score == 8:
			tile = tile_start.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 10:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 1 or tile_score == 4 or tile_score == 5:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 6:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 12:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,270,0)
		elif tile_score == 9:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,180,0)
		elif tile_score == 3:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 15:
			tile = tile_crossroads.instantiate()
			tile_rotation = Vector3(0,0,0)
			
		add_child(tile)
		tile.global_position = Vector3(PathGenInstance.get_path_tile(i).x, 0, PathGenInstance.get_path_tile(i).y)
		tile.global_rotation_degrees = tile_rotation
	_pop_along_grid()
