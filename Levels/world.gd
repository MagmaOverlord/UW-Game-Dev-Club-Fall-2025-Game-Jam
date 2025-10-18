extends Node3D

#map generation
@export var map_length : int = 20
@export var map_height : int = 15
@export var tile_start : PackedScene
@export var tile_straight : PackedScene
@export var tile_corner : PackedScene
@export var tile_empty : PackedScene
@export var tile_end : PackedScene
var _pg : PathGenerator

#player info
@export var playerHP: int = 100
@export var gold: int = 500
var companions = []

#game control
var is_round_ongoing: bool = false;
var round: int = 1;
var enemies_to_spawn : int = 5
var can_spawn : bool = true;
@onready var basic_enemy : PackedScene = preload("res://Objects/Enemies/enemy_template.tscn")

func _ready():
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()

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

func _display_path():
	var _path : Array[Vector2i] = _pg.generate_path()
	while _path.size() < 35:
		_path = _pg.generate_path()
	
	#    1
	#  8   2
	#    4
	for element in _path:
		#get and use score to determine type of tile & its rotation
		var tile_score : int = _pg.get_tile_score(element)
		print(tile_score)
		var tile : Node3D = tile_empty.instantiate()
		var tile_rotation : Vector3 = Vector3.ZERO
		if tile_score == 2:
			tile = tile_start.instantiate()
			tile_rotation = Vector3.ZERO
		elif tile_score == 8:
			tile = tile_end.instantiate()
			tile_rotation = Vector3.ZERO
		elif tile_score == 10:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0, 90, 0)
		elif tile_score == 5:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3.ZERO
		elif tile_score == 12:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0, -90, 0)
		elif tile_score == 6:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3.ZERO
		elif tile_score == 9:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0, 180, 0)
		elif tile_score == 3:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0, 90, 0)
		add_child(tile)
		tile.global_position = Vector3(element.x, 0, element.y)
		tile.global_rotation_degrees = tile_rotation

func _complete_grid():
	for x in range(map_length):
		for y in range(map_height):
			if not _pg.get_path().has(Vector2i(x, y)):
				var tile : Node3D = tile_empty.instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
