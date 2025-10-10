extends Node3D

@export var playerHP: int = 100

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
