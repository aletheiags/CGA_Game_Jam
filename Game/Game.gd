extends Node

func loadScene(scenename, spawnpoint):
	var children=get_node("Map").get_children()
	for child in children:
		child.queue_free()
		
	var scene = load("res://"+scenename+".tscn").instance()
	get_node("Map").add_child(scene)
	var sp=scene.get_node(spawnpoint)
	get_node("Player/PlayerMovementBody").set_pos(sp.get_global_pos())
	pass

func _ready():
	loadScene("Maps/OverWorld","StartPoint")