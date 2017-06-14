extends Node2D

export(int) var tileHeight = 100
export(int) var tileWidth = 100 
export(int) var dungeonSize = 16
export(int) var encounters = 10
export(int) var TotalUniqueSections = 5

export(Array) var posibleEnemies = []

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
	
	var start = load("res://Maps/Sections/Start.tscn").instance()
	get_node("Navigation").add_child(start)
	start.row = 0
	start.col = 0
	grid['0-0'] = start
	
	while i < dungeonSize:

		var possible = get_possible()
		#pick the possible exit
		if possible.size() > 0:
			var fromExit = possible[randi()%possible.size()-1]

			var entranceTo = switch_enter_exit(fromExit)
	
			var options = sideOpenList[entranceTo]

			var tile = baseTiles[options[randi()%options.size()-1]].instance()
			
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
	
	var extents = {
		"West":0,
		"East":0,
		"North":0,
		"South":0
	}
	
	var possEncounter = []
	
	for g in grid:
		possEncounter.append(g)
		if grid[g].col > extents.East:
			extents.East = grid[g].col
		if grid[g].col < extents.West:
			extents.West = grid[g].col
		if grid[g].row < extents.North:
			extents.North = grid[g].row
		if grid[g].row > extents.South:
			extents.South = grid[g].row
		
	

	extents.East += 1
	extents.West -= 1
	extents.North -= 1
	extents.South += 1
	print(extents)
	var c = extents.West
	var r
	var blackout = load("res://Maps/Sections/blockedOff.tscn")
	while c <= extents.East:
		var r = extents.North
		while r <= extents.South:
			if not grid.has(str(c)+'-'+str(r)):
				var tile = blackout.instance()
				get_node("Navigation").add_child(tile)
				tile.row = r
				tile.col = c
				tile.set_pos(Vector2(c*tileWidth,r*tileHeight))
			
			r += 1
		c += 1
	
	i = 0
	while i < encounters:
		if possEncounter.size() > 0:
			var loci = possEncounter[randi()%possEncounter.size()-1]
		
			grid[loci].hasEnemy = true
		
			possEncounter.erase(loci)
		
		i += 1
		
func setup():
	var i = 1	
	while i <= 5:
		var t = load("res://Maps/Sections/Section"+str(i)+".tscn")
		var tile = t.instance()
		for side in sideOpenList:
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
	var checking = str(tile.col)+'-'+str(tile.row+1)

	if grid.has(checking):
		blocked.append("South")
		
	checking = str(tile.col)+'-'+str(tile.row-1)

	if grid.has(checking):
		blocked.append("North")
	
	checking = str(tile.col-1)+'-'+str(tile.row)

	if grid.has(checking):
		blocked.append("West")
	
	checking = str(tile.col+1)+'-'+str(tile.row)

	if grid.has(checking):
		blocked.append("East")
		
	for side in openSides:
		if tile["open"+side] && blocked.find(side) == -1:
			openSides[side] = true
		else:
			openSides[side] = false

