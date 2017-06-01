extends Node

export(float) var speed = 10

func move_units():
	var mvector = Vector2(0,0)
	var units = get_node("Units").get_children()
	if Input.is_action_pressed("movechar_down") == true:
			for u in units:
				u.get_node("Rotater").set_rotd(90)
			mvector+=Vector2(0,1)
	if Input.is_action_pressed("movechar_up") == true:
			mvector+=Vector2(0,-1)
			for u in units:
				u.get_node("Rotater").set_rotd(270)
	if Input.is_action_pressed("movechar_right") == true:
			for u in units:
				u.get_node("Rotater").set_rotd(180)
			mvector+=Vector2(1,0)
	if Input.is_action_pressed("movechar_left") == true:
			for u in units:
				u.get_node("Rotater").set_rotd(0)
			mvector+=Vector2(-1,0)
		
	mvector=mvector.normalized()*speed
	
	get_node("PlayerMovementBody").move(mvector)
	get_node("Units").get_child(0).set_pos(get_node("PlayerMovementBody").get_pos())

func _fixed_process(delta):
	move_units()
	var units = get_node("Units").get_children()
	for i in range(units.size()):
		if i != 0:
			var gotoLoc = units[i-1].get_node("Rotater/FollowerTarget").get_global_pos()
			var mLoc = units[i].get_pos()
			var p = mLoc.linear_interpolate(gotoLoc, 0.08)
			units[i].set_pos(p)

func _ready():
	set_fixed_process(true)

