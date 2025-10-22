extends Node3D

#map generation
@export var map_length:int = 16
@export var map_height:int = 9
var path : Path3D

#player info
@export var playerHP: int = 100
@export var gold: int = 500
var companions = []

#game control
var is_round_ongoing: bool = false;
var round: int = 1;

func _ready():
	var pg = PathGenerator.new(map_length, map_height)
	path = get_node("Path3D");
	print_debug(pg.generate_path())

func _process(delta):
	#should include stuff like spawning & tracking enemies, end of round check, call to companion select, tracking of companions had, UI management, just a lot of stuff
	pass

func playerDamage(damage):
	print_debug("Took damage!")
	playerHP -= damage
	print_debug(playerHP)
	if playerHP <= 0:
		#game over screen
		print_debug("Game over!")
