extends PathFollow3D

@export var hp: int = 20;
@export var speed: int = 2;
@export var damage: int = 1;
@onready var gameManager = get_tree().get_first_node_in_group("GameManager") #gets root node of scene

func _process(delta):
	progress += speed * delta
	if progress_ratio == 1.0:
		gameManager.playerDamage(damage)
		self.queue_free()
		pass

func enemyDamage(damage):
	hp -= damage
	if hp <= 0:
		self.queue_free()
		
