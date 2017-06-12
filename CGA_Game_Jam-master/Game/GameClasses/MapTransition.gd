extends Area2D

export (String) var gotoScene
export (String) var spawnPoint

func bodyEntered(body):
	if body.get_name() == 'PlayerMovementBody':
		get_tree().get_root().get_node("Game").loadScene(gotoScene, spawnPoint)

func _ready():
	connect("body_enter", self, "bodyEntered")