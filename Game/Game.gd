extends Node

var battleLocation 

func loadScene(scenename, spawnpoint):
	var children=get_node("Map").get_children()
	for child in children:
		child.queue_free()
		
	var scene = load("res://"+scenename+".tscn").instance()
	get_node("Map").add_child(scene)
	var sp=scene.get_node(spawnpoint)
	get_node("Player/PlayerMovementBody").set_pos(sp.get_global_pos())
	pass

func goIntoBattle(unitPositions,enemyPositions,cameraPos,battleArea):
	battleLocation = battleArea
	get_node("Player").goIntoBattle(unitPositions,cameraPos)
	#enemies and stuff here
	
func endBattle():
	battleLocation.hasEnemy = false
	get_node("Player").endBattle()

func _fixed_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if get_node("Player").inBattle:
			endBattle()			

func _ready():
	set_fixed_process(true)
	#loadScene("Maps/OverWorld","StartPoint")
	loadScene("Maps/Dungeon","StartPoint")