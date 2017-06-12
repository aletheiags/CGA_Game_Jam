extends Node

var battleLocation 
var dungon
var enemyList = []

#battle
var enemies = []
var order = []
var onUnit = 0
var xpForBattle = 0
var turnDone = false

func loadScene(scenename, spawnpoint):
	var children=get_node("Map").get_children()
	for child in children:
		child.queue_free()
		
	var scene = load("res://"+scenename+".tscn").instance()
	get_node("Map").add_child(scene)
	var sp=scene.get_node(spawnpoint)
	get_node("Player/PlayerMovementBody").set_pos(sp.get_global_pos())
	dungon = scene
	enemyList = []
	for e in dungon.posibleEnemies:
		enemyList.append(e)
	
	for c in get_node("Player/Units").get_children():
		c.connect("died",self,"unit_died")
	
func goIntoBattle(unitPositions,enemyPositions,battleArea):
	get_tree().get_root().get_node("Desktop/Sounds/Dungeon").stop()
	get_tree().get_root().get_node("Desktop/Sounds/Battle").play()
	battleLocation = battleArea
	get_node("Player").goIntoBattle(unitPositions)
	
	for e in enemyPositions:		
		var eN = enemyList[randi()%enemyList.size()-1]
		var enemy = get_node("Enemy/"+eN).duplicate(true)
		enemies.append(enemy)
		enemy.set_pos(e.get_global_pos())
		enemy.connect("died",self,"unit_died")
		add_child(enemy)
		
	startBattle()


func unit_died(unit):
	order.erase(unit)
	if unit.unitType == 'enemy':
		unit.queue_free()
		xpForBattle += unit.givesXP
		enemies.erase(unit)
		if enemies.size() <= 0:
			battleWon()

func battleWon():
	print('I won the battle')
	get_node("Player").XP += xpForBattle
	endBattle()
	

func endBattle():
	battleLocation.hasEnemy = false
	get_node("Player").endBattle()
	get_tree().get_root().get_node("Desktop/Sounds/Win").play()
	get_tree().get_root().get_node("Desktop/Sounds/Dungeon").play()
	get_tree().get_root().get_node("Desktop/Sounds/Battle").stop()
	
func _fixed_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if get_node("Player").inBattle:
			endBattle()			

	if Input.is_action_pressed("ui_accept"):
		if turnDone && enemies.size() > 0:
			nextTurn()
		
func _ready():
	set_fixed_process(true)
	#loadScene("Maps/OverWorld","StartPoint")
	loadScene("Maps/Dungeon","StartPoint")
	get_tree().get_root().get_node("Desktop/Sounds/Dungeon").play()

#These are all battle function
func startBattle():
	xpForBattle = 0
	order = set_order()
	nextTurn()
	
	pass
	
func nextTurn():
	turnDone = false
	onUnit = 0
	while onUnit < get_node("Player/Units").get_children().size():
		setNextPlayerUnit()

	setEnemyUnits()
	
	doBattle()
	

func doBattle():
	for o in order:
		o.doActiveAbility()
	
	turnDone = true


		

func setNextPlayerUnit():
	var unit = get_node("Player/Units").get_children()[onUnit]
	unit.onTurn.useAbility = get_node("Abilities/Strike")
	unit.onTurn.on = enemies[0]
	onUnit += 1

func setEnemyUnits():
	var p = get_node("Player/Units").get_children()
	for e in enemies:
		#this should be radomized.. ?
		e.onTurn.useAbility =get_node("Abilities/Strike")
		e.onTurn.on = p[randi()%p.size()]


func sort_units(units):
	var newOrder = []
	var i = 100
	while i > 0:
		for u in units:
			if u.CPU == i:
				newOrder.append(u)
		i -= 1
	
	return newOrder

func set_order():
	var sortItems = []
	for e in enemies:
		sortItems.append(e)

	for c in get_node("Player/Units").get_children():
		sortItems.append(c)
	
	return sort_units(sortItems)
	