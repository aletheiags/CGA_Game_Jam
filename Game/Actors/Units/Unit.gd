extends Node

export(int) var maxPSU
var psu
export(int) var CPU
export(int) var maxRam
var ram

export(String) var PrimaryAbility

export(String) var SecondaryAbility

export(String) var SpecialAbility

var effects = []

var CanBeAttacked = true
var CanAttack = true

func do_ability(attack,enemy):
	if CanAttack:
		var dodged = false
		var reservedUsed = 0
		var attackValue = 0
		var dodgeChance = ((CPU*0.1-enemy.CPU*0.1)/CPU)*100
		if  dodgeChance > 0:
			if randi()%100 > dodgeChance:
				dodged = false
	
		if not dodged:
			if enemy.canBeAttacked:
				attackValue = psu
				enemy.get_hit(attackValue)
				ram = attack.ramUsage
				if ram < 0:
					psu -= ram
					ram = 0
			else:
				dodged = true
		
		return([dodged,attackValue,reservedUsed])
		
func _ready():
	ram = maxRam
	psu = maxPSU