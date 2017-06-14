extends Node

var dungeonGame

var activeAbility = null
var attackingEnemy = null

func add_to_output(text):
	var t = get_node("BattleDetails/Output").get_text()
	var newText= t+'\n ...... \n'+text
	get_node("BattleDetails/Output").set_text(newText)

func set_PSU_vaule(unit):
	var meter = get_node("PortaitWindowBorder/"+unit.get_name()+'/PSU')
	meter.set_scale(Vector2(float(unit.psu/unit.maxPSU),1))

func setOnPlayer(unit):
	get_node("TurnWindow").show()
	get_node("TurnWindow/OnTurn").set_text(unit.unitName)
	if not typeof(unit.PrimaryAbility) == 0:
		print(unit.PrimaryAbility)
		print(dungeonGame.get_node("Abilities/"+unit.PrimaryAbility))
		get_node("TurnWindow/Ability1").set_ability(dungeonGame.get_node("Abilities/"+unit.PrimaryAbility))
	

func doVictory():
	get_node("GameWindow").hide()
	get_node("GameWindowBorder").hide()
	get_node("Victory").show()
	get_node("Victory/AnimationPlayer").play("grow")
	

func activate_ability(ability):
	activeAbility = ability
	print(ability, 'Activated')

func setAttackingEnemy(enemy):
	attackingEnemy = enemy
	print('Attacking Enemy Set')

func _ready():
	dungeonGame = get_node("GameWindow/Viewport/Game")
	#get_node("WindowDialog").popup()
	
