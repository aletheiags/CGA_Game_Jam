extends Node

var battleLocation 
var dungon
var enemyList = []

var battlesLeft = 1
#battle
var enemies = []
var order = []
var onUnit = 0
var xpForBattle = 0
var turnDone = false

var unitTurn = 0

var level = 0

var inBattle = false
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
	
	battlesLeft = scene.encounterCount
	print(battlesLeft)
	
func goIntoBattle(unitPositions,enemyPositions,battleArea):
	inBattle = true
	get_tree().get_root().get_node("Desktop/Sounds/Dungeon").stop()
	get_tree().get_root().get_node("Desktop/Sounds/Battle").play()
	battleLocation = battleArea
	var pos = battleArea.get_global_pos()
	
	get_tree().get_root().get_node("Desktop").get_node("PortaitWindowBorder").show()
	get_tree().get_root().get_node("Desktop").get_node("BattleDetails").show()
	
	var newPos = Vector2(160,160)+battleArea.get_pos()
	get_node("Player").goIntoBattle(unitPositions,newPos)
	
	for e in enemyPositions:		
		var eN = enemyList[randi()%enemyList.size()-1]
		print(eN)
		var enemy = get_node("Enemy/"+eN).duplicate(true)
		enemies.append(enemy)
		enemy.set_pos(e.get_global_pos())
		enemy.connect("died",self,"unit_died")
		add_child(enemy)
		enemy.show()
		
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
	battlesLeft -= 1
	if battlesLeft == 0:
		get_tree().get_root().get_node("Desktop").doVictory()
	

func endBattle():
	battleLocation.hasEnemy = false
	get_node("Player").endBattle()
	get_tree().get_root().get_node("Desktop/Sounds/Win").play()
	get_tree().get_root().get_node("Desktop/Sounds/Dungeon").play()
	get_tree().get_root().get_node("Desktop/Sounds/Battle").stop()
	get_tree().get_root().get_node("Desktop").get_node("PortaitWindowBorder").hide()
	get_tree().get_root().get_node("Desktop").get_node("BattleDetails").hide()
	get_tree().get_root().get_node("Desktop").get_node("TurnWindow").hide()
	inBattle = false
	
func _fixed_process(delta):
	if inBattle:
		if not typeof(get_tree().get_root().get_node("Desktop").activeAbility) == 0 && not typeof(get_tree().get_root().get_node("Desktop").attackingEnemy) == 0:
			setNextPlayerUnit()
	#if Input.is_action_pressed("ui_cancel"):
		#if get_node("Player").inBattle:
		#	endBattle()			

	#if Input.is_action_pressed("ui_accept"):
	#	if turnDone && enemies.size() > 0:
	#		nextTurn()

	
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
	#while onUnit < get_node("Player/Units").get_children().size():
	#	setNextPlayerUnit()

	setEnemyUnits()
	
	setOnPlayer()
	#doBattle()
	

func setOnPlayer():
	get_tree().get_root().get_node("Desktop").setOnPlayer(get_node("Player/Units").get_children()[onUnit])

func doBattle():
	unitTurn = 0
	order[unitTurn].doActiveAbility()
	#for o in order:
	#	o.doActiveAbility()
	
	#onUnit = 0
	#turnDone = true
	
func nextUnitsTurnToAttack():
	unitTurn += 1
	if unitTurn < order.size() && enemies.size() > 0:
		order[unitTurn].doActiveAbility()
	
	else:
		onUnit = 0
		turnDone = true

func setNextPlayerUnit():
	var unit = get_node("Player/Units").get_children()[onUnit]
	unit.onTurn.useAbility = get_tree().get_root().get_node("Desktop").activeAbility
	unit.onTurn.on = get_tree().get_root().get_node("Desktop").attackingEnemy
	onUnit += 1
	get_tree().get_root().get_node("Desktop").activeAbility = null
	get_tree().get_root().get_node("Desktop").attackingEnemy = null
	
	if onUnit >= get_node("Player/Units").get_children().size():
		doBattle()
	
	else:
		setOnPlayer()

func setEnemyUnits():
	var p = get_node("Player/Units").get_children()
	for e in enemies:
		#this should be radomized.. ?
		e.onTurn.useAbility =get_node("Abilities/Strike")
		var u = p[randi()%p.size()-1]
		print(u)
		if typeof(u) != 0:
			e.onTurn.on = weakref(u)


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
	