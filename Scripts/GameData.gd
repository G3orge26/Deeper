extends Node

# Dictionary read from json containing information 
# about various blocks in the game
var BlockData = {}

# Array [tid]: blockName, populated after json is read
var BlockName = []

func _ready():
	load_block_data()
	retrieve_names()
	pass # Replace with function body.

func retrieve_names():
	for tid in BlockData:
		var entry = BlockData.get(str(tid))
		BlockName.push_back(entry.name)
	pass

func load_block_data():
	var block_data_file = File.new()
	if not block_data_file.file_exists("res://Data/BlockData.json"):
		print ("No Block data file available")
		return
	block_data_file.open("res://Data/BlockData.json", File.READ)
	var block_data_json = JSON.parse(block_data_file.get_as_text())
	if block_data_json.error != OK:
		print("DATA ERROR")
	block_data_file.close()
	BlockData = block_data_json.result
	JSON.print(BlockData, "...")

func get_tid_hp(tid):
	if BlockData.has(str(tid)):
		var block = BlockData[str(tid)]
		if block.has("hp"):
			return block["hp"]

func get_tid_as_string(tid):
	return BlockName[int(tid)]

func get_loot(tid):
	if BlockData.has(str(tid)):
		var block = BlockData[str(tid)]
		if block.has("yield_min") and block.has("yield_max"):
			var loot_min = block["yield_min"]
			var loot_max = block["yield_max"]
			var loot = Common.randi_range(loot_min, loot_max)
			var loot_weight = block["weight"]
			return Vector2(loot, loot_weight)
		else:
			return Vector2(0, 0)
