extends TextureButton

var ability

func set_ability(_ability):
	ability = _ability
	get_node("abilityTitle").set_text(ability.AbilityName+'.exe')
	print('Im hiding that ability')
	get_node("selected").hide()

func activate_ability():
	get_tree().get_root().get_node("Desktop").activate_ability(ability)
	get_node("selected").show()

func _ready():
	connect("pressed", self,"activate_ability")