extends Node2D

export(int) var tileHeight = 100
export(int) var tileWidth = 100 
var grid = {}
var baseTiles = []
var openSides = {
	"North":true,
	"South":true,
	"West":true,
	"East":true
}
var sideOpenList = {
	"North":[],
	"South":[],
	"East":[],
	"West":[]
}

var blocked = []

var cameFrom = "none"


func _ready():
	setup()
	build_dungeon()
	 

func build_dungeon():
	var i = 0
	var curPos = Vector2(0,0)
	while i < 10:
		var possible = get_possible()
		var fromExit = possible[randi()%possible.size()-1]
		var options = sideOpenList[switch_enter_exit(fromExit)]
		var tile = baseTiles[options[randi()%options.size()-1]].instance()
		
		if i > 0:
			if fromExit == "North":
				curPos = curPos-Vector2(0,tileHeight)
			elif fromExit == "South":
				curPos = curPos+Vector2(0,tileHeight)
			elif fromExit == "West":
				curPos = curPos-Vector2(tileWidth,0)
			elif fromExit == "East":
				curPos = curPos+Vector2(tileWidth,0)
			tile.set_pos(curPos)
		
		get_node("Navigation").add_child(tile)

		tile.row = floor(curPos.y/tileHeight)
		tile.col = floor(curPos.x/tileWidth)
		
		grid[str(tile.col)+'-'+str(tile.row)] = tile
		
		get_open_sides(tile)
		i += 1
	print(grid)
	
func setup():
	var i = 1	
	while i <= 5:
		var t = load("res://Maps/Sections/Section"+str(i)+".tscn")
		var tile = t.instance()
		for side in openSides:
			if tile["open"+side]:
				sideOpenList[side].append(i-1)#this gives the index
		baseTiles.append(t)
		i+= 1
	randomize()

func get_possible():
	var p = []
	for o in openSides:
		if openSides[o]:
			p.append(o)
	return p

func switch_enter_exit(exit):
	var entrance = "none"
	if exit == "North":
		entrance = "South"
	elif exit == "South":
		entrance = "North"
	elif exit == "West":
		entrance = "East"
	elif exit == "East":
		entrance = "West"
	return entrance
	
func get_open_sides(tile):
	blocked = []
	if grid.has(str(tile.row-1)+'-'+str(tile.col)):
		blocked.append("North")
	if grid.has(str(tile.row+1)+'-'+str(tile.col)):
		blocked.append("South")
	if grid.has(str(tile.row)+'-'+str(tile.col+1)):
		blocked.append("East")
	if grid.has(str(tile.row)+'-'+str(tile.col-1)):
		blocked.append("West")
	print(blocked)
	print("******SIDES*****")
	for side in openSides:
		if tile["open"+side] && blocked.find(side) == -1:
			print(side+' true')
			openSides[side] = true
		else:
			print(side+' false')
			openSides[side] = false

	print(openSides)