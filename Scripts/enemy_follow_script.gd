extends PathFollow3D

@export var hp: int = 20;
@export var damage: int = 1;
var gameManager = get_tree().get_root().get_child(0) #gets root node of scene

func _process(delta):
	progress += 12 * delta
	if progress_ratio == 1.0:
		#tell game to remove life from player
		gameManager.playerDamage(damage)
		self.queue_free()
		pass

func enemyDamage(damage):
	hp -= damage
	if hp <= 0:
		self.queue_free()
		
