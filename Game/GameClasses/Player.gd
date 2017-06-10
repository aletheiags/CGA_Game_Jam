extends Node

export(float) var speed = 10

var inBattle = false
var path = []
var onCol = 0
var onRow = 0

func move_units():
	var mvector = Vector2(0,0)
	var units = get_node("Units").get_children()
	if Input.is_action_pressed("movechar_down") == true:
			for u in units:
				u.get_node("UnitBody/Rotater").set_rotd(90)
			mvector+=Vector2(0,1)
	if Input.is_action_pressed("movechar_up") == true:
			mvector+=Vector2(0,-1)
			for u in units:
				u.get_node("UnitBody/Rotater").set_rotd(270)
	if Input.is_action_pressed("movechar_right") == true:
			for u in units:
				u.get_node("UnitBody/Rotater").set_rotd(180)
			mvector+=Vector2(1,0)
	if Input.is_action_pressed("movechar_left") == true:
			for u in units:
				u.get_node("UnitBody/Rotater").set_rotd(0)
			mvector+=Vector2(-1,0)
		
	mvector=mvector.normalized()*speed
	
	get_node("PlayerMovementBody").move(mvector)
	if (get_node("PlayerMovementBody").is_colliding()):
		var n = get_node("PlayerMovementBody").get_collision_normal()
		var motion = n.slide(motion)
		get_node("PlayerMovementBody").move(motion)
	
	get_node("Units").get_child(0).get_node("UnitBody").set_pos(get_node("PlayerMovementBody").get_pos())

func endBattle():
	inBattle = false
	var cam = get_node("PlayerMovementBody/Camera2D")
	var tween = cam.get_node("CameraTween")
	tween.interpolate_property(cam,"transform/pos",cam.get_pos(),Vector2(0,0),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(cam,"zoom",Vector2(0.7,0.7),Vector2(1.5,1.5),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func goIntoBattle(unitPositions,cameraPos):
	inBattle = true
	var cam = get_node("PlayerMovementBody/Camera2D")
	var i = 0
	var tween = cam.get_node("CameraTween")
	tween.interpolate_property(cam,"zoom",Vector2(1.5,1.5),Vector2(0.7,0.7),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(cam,"transform/pos",cam.get_pos(),cameraPos.get_pos(),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#cam.set_zoom(Vector2(1,1))
	for u in get_node("Units").get_children():
		tween.interpolate_property(u.get_node("UnitBody"),'transform/pos',u.get_node("UnitBody").get_pos(),unitPositions[i].get_global_pos(),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		i += 1
	
	tween.start()

func nextLoc(body,somethingElse):
	if path.size()>1:
		path.remove(path.size()-1)
		tweenTo()
	
func tweenTo():
	var bod = get_node("PlayerMovementBody")
	var tween = get_node("MovementTween")
	var dis = bod.get_global_pos().distance_to(path[path.size()-1])
	tween.interpolate_property(bod,"transform/pos",bod.get_global_pos(),path[path.size()-1],dis/(speed*100),Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if not tween.is_connected("tween_complete",self,"nextLoc"):
		tween.connect("tween_complete",self,"nextLoc",[],4)
	
	tween.start()
	
func _fixed_process(delta):
	if not inBattle:
		move_units()
		var units = get_node("Units").get_children()
		for i in range(units.size()):
			get_node("Units").get_child(0).get_node("UnitBody").set_pos(get_node("PlayerMovementBody").get_pos())
			if i != 0:
				var gotoLoc = units[i-1].get_node("UnitBody").get_node("Rotater/FollowerTarget").get_global_pos()
				var mLoc = units[i].get_node("UnitBody").get_pos()
				var p = mLoc.linear_interpolate(gotoLoc, 0.08)
				units[i].get_node("UnitBody").set_pos(p)
	

func _ready():
	set_fixed_process(true)

