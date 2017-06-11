extends Area2D

func bodyEntered(body):
	if body.get_name() == 'PlayerMovementBody':
		if get_parent().hasEnemy:
			##This is stupid
			get_parent().get_parent().get_parent().get_parent().get_parent().goIntoBattle(get_parent().get_node("UnitPositions").get_children(),get_parent().get_node("EnemyPositions").get_children(),get_parent())
		
func _ready():
	connect("body_enter", self, "bodyEntered")