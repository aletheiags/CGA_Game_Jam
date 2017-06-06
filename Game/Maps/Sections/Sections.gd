extends Area2D

export(bool) var openNorth = false
export(bool) var openWest = false
export(bool) var openEast =false
export(bool) var openSouth = false
export(bool) var hasEnemy = false
export(int) var row = 0
export(int) var col = 0

##The issue is that this section is not nessessarly the one that the units are in. By doing this we need to determine which one is clicked in
func clickEvent(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT && event.pressed:

		var player = get_tree().get_root().get_node("Desktop").dungeonGame.get_node("Player")
		
		var path = get_parent().get_simple_path(player.get_node("PlayerMovementBody").get_global_pos(),get_global_mouse_pos())
		
		#If the path is bigger than 0 then it is in the same block We are good to go
		if path.size() == 0:#this means it is not connected
			var fromPos = Vector2(0,0)
			var toPos = Vector2(0,0)
			if col > player.onCol:#its to the right so I need the west
				toPos = get_node("WestExit").get_global_pos()
				for child in get_parent().get_children():					
					if child.col == player.onCol && child.row == player.onRow:
						fromPos = child.get_node("EastExit").get_global_pos()
			elif col < player.onCol:#its to the left
				toPos = get_node("EastExit").get_global_pos()
				for child in get_parent().get_children():					
					if child.col == player.onCol && child.row == player.onRow:
						fromPos = child.get_node("WestExit").get_global_pos()
			elif row < player.onRow:#its to the the top
				toPos = get_node("SouthExit").get_global_pos()
				for child in get_parent().get_children():					
					if child.col == player.onCol && child.row == player.onRow:
						fromPos = child.get_node("NorthExit").get_global_pos()
			elif row > player.onRow:#its to the bottom
				toPos = get_node("NorthExit").get_global_pos()
				for child in get_parent().get_children():					
					if child.col == player.onCol && child.row == player.onRow:
						fromPos = child.get_node("SouthExit").get_global_pos()

			if toPos != Vector2(0,0) && fromPos != Vector2(0,0):
			
				path = get_parent().get_simple_path(player.get_node("PlayerMovementBody").get_global_pos(),fromPos)

				var pa = get_parent().get_simple_path(toPos,get_global_mouse_pos())
				pa.invert()
				for p in pa:
					path.append(p)
			
				print(player.onCol)
				print(path)
				
		path.invert()#invert it
		if path.size() > 1:
			path.remove(path.size()-1) #remove the path the player is already on
			player.path = path
			player.tweenTo()
		else:
			player.path = []


func bodyEntered(body):
	if body.get_name() == "PlayerMovementBody":
		body.get_parent().onCol = col
		body.get_parent().onRow = row

func bodyExited(body):
	if body.get_name() == "PlayerMovementBody":
		if body.get_parent().onCol != col && body.get_parent().onRow != row:
			body.get_parent().onCol = -1
			body.get_parent().onRow = -1
	
func _ready():
	connect("input_event",self,"clickEvent")
	connect("body_enter",self,"bodyEntered")
	connect("body_enter",self,"bodyExited")
