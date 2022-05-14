extends TileMap

enum TID {Grass = 0, Dirt = 1, Stone = 2, Sky = 3}

const OFFSET_Y = 2
const OFFSET_X = 0
const MAP_WIDTH = 32
const MAP_HEIGHT = 30

var rng = RandomNumberGenerator.new()

func generate_map(rng_seed):
	rng.randomize()
	
	for x in range(OFFSET_X, MAP_HEIGHT):
		for y in range(OFFSET_Y, MAP_WIDTH):
			set_cell(x, y, rng.randi_range(1,2))
			


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map(100)
	pass # Replace with function body.

func _save():
	var cells = get_used_cells()
	var i = 0
	var tiles = {}
	for cell in cells:
		var name = "Tile" + str(i)
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
#func _process(delta):
#	pass
