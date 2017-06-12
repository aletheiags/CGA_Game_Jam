extends "../Units/Unit.gd"

export(int) var givesXP

var unitType = 'enemy'

func checkClicked(viewport,event,ix):
	if event.type == 3 && event.pressed == 1:
		print(event)

func onReady():
	get_node("ClickArea").connect("input_event",self,"checkClicked")
	get_node("PSU").set_text(str(psu))