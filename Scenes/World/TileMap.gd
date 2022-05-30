extends TileMap

enum TID {Grass = 0, Dirt = 1, Copper = 2, Stone = 3, Sky = 4}

const OFFSET_Y = 2
const OFFSET_X = 0
const MAP_WIDTH = 32
const MAP_HEIGHT = 30
const TILE_WIDTH = 64
const TILE_HEIGHT = 64
const TILE_DMG_TTL = 0.5

var last_tile_attacked
var last_tile_health
var last_tile_max_health
var last_tile_ttl = 0

var rng = RandomNumberGenerator.new()

signal tile_drilled(pos, drill_power)
signal clear_drill

func _on_TileMap_tile_drilled(pos, drill_power):
	var cell = world_to_map(pos)
	var cell_tid = get_cellv(cell)
	if(cell_tid == TID.Sky):
		return
		
		
	$DMG.position = cell * cell_size
	
	if(cell != last_tile_attacked):
		last_tile_attacked = cell
		last_tile_health = 0
		
		# TODO: read this from gamedata
		last_tile_max_health = cell_tid + 1
		
		$DMG.frame = 0
		$DMG.visible = true
		$DMG.flip_h = Common.randb()
		$DMG.flip_v = Common.randb()
		
	var threshold = float(last_tile_max_health / 6.0)
	last_tile_health += drill_power
	$DMG.frame = int(last_tile_health / threshold)
	if(last_tile_health > last_tile_max_health):
		$DMG.visible = false
		set_cellv(cell, TID.Sky)
		get_parent().get_parent().get_node("Player").get_child(0).emit_signal("block_destroyed", cell_tid)
	last_tile_ttl = TILE_DMG_TTL
	
func clearDmg():
	last_tile_attacked = Vector2(-10,-10)
	$DMG.visible = false
	pass

func generate_map(rng_seed):
	rng.randomize()
	
	for x in range(OFFSET_X, MAP_HEIGHT):
		for y in range(OFFSET_Y, MAP_WIDTH):
			var rand_tid = rng.randi_range(1,3)
			if(rand_tid == TID.Copper):
				set_cell(x, y, rand_tid, Common.randb(), Common.randb(), false)	
			else:
				set_cell(x, y, rand_tid)
			
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map(100)
	pass # Replace with function body.

func _save():
	var cells = get_used_cells()
	var i = 0
	var tiles = {}
	for cell in cells:
		var name = "T" + str(i)
		tiles[name] = {
			"x" : cell.x,
			"y" : cell.y,
			"id": get_cellv(cell)
		}
		i = i+1
		
		
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"map": tiles
	}
	return save_dict
	
func _load(data):
	
	var tiles = data.map
	for tile in tiles:
		var tl_data = tiles[tile]
		set_cell(tl_data.x, tl_data.y, tl_data.id)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(last_tile_ttl > 0):
		last_tile_ttl -= delta
		if(last_tile_ttl <= 0):
			$DMG.visible = false
			last_tile_attacked = Vector2(-10,-10)
			
#	pass
