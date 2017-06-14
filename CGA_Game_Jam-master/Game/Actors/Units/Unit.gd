extends Node

export(String) var unitName
export(int) var maxPSU
export(int) var CPU
export(int) var maxRam
export(int) var baseAttackPercentage = 40

var ram
var psu

 
var onTurn ={
	"useAbility":null,
	"on":null
}
export(String) var PrimaryAbility

export(String) var SecondaryAbility

export(String) var SpecialAbility

var effects = []

var CanBeAttacked = true
var CanAttack = true

signal died

func doActiveAbility():
	do_ability(onTurn.useAbility,onTurn.on)

func do_ability(attack,enemy):
	if CanAttack:
		var dodged = false
		var reservedUsed = 0
		var attackValue = 0
		var roll = 0
		var dodgeChance = ((CPU*0.1-enemy.CPU*0.1)/CPU)*100
		if  dodgeChance > 0:
			roll = randi()%100
			if roll < dodgeChance:
				dodged = true

				
		if not dodged:
			if enemy.CanBeAttacked:
				var mod = 40+psu #this is the base
				if roll > mod:
					mod = roll #this is true of roll is higher than base
				attackValue = ceil(float(psu*attack.Power*float(float(mod)/100)))
				enemy.get_hit(attackValue, self)
				ram = attack.RamUsage
				if ram < 0:
					psu -= ram
					ram = 0
			else:
				dodged = true
		
		if not dodged:
			print('Attacking')
			get_node("AnimationPlayer").play("Attack")
			get_node("AnimationPlayer").connect("finished",self,"attackDone",[],4)
		
		else:
			get_tree().get_root().get_node("Desktop").dungeonGame.nextUnitsTurnToAttack()
		#return([dodged,attackValue,reservedUsed])

func attackDone():
	print('attack is done')
	get_tree().get_root().get_node("Desktop").dungeonGame.nextUnitsTurnToAttack()

func get_hit(attackValue,attacker):
	get_tree().get_root().get_node("Desktop").add_to_output(get_name()+' was hit for '+str(attackValue)+' By '+attacker.get_name())
	get_node("AnimationPlayer").play("getHit")
	psu -= attackValue
	if psu <= 0:
		die()
	else:
		if self.unitType == 'enemy':
			get_node("PSU").set_text(str(psu))
		else:
			get_node("UnitBody/PSU").set_text(str(psu))
			get_tree().get_root().get_node("Desktop").set_PSU_vaule(self)

func die():
	get_tree().get_root().get_node("Desktop").add_to_output(get_name()+' died')
	emit_signal("died",self)

##this is meant to be overwridden
func onReady():
	pass

func _ready():
	ram = maxRam
	psu = maxPSU
	call("onReady")