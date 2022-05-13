extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("F5"):
		save_game()
	if Input.is_action_just_pressed("F6"):
		load_game()


func save_game():
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Saveable")
	print("Nodes to be saved: '%d'" % save_nodes.size())
	for node in save_nodes:
		if node.filename.empty():
			print("empty")
			continue
		if !node.has_method("_save"):
			print("Node '%s' is missing a save() function, skipped" % node.name)
	
		print("Saving node '%s'" %node.name)
		var node_data = node.call("_save")
		save_file.store_line(to_json(node_data))
	save_file.close()
	
func load_game():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		print ("No save file available")
		return
	
	var save_nodes = get_tree().get_nodes_in_group("Saveable")
	for i in save_nodes:
		i.queue_free()
		
	save_file.open("user://savegame.save", File.READ)
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
			if i == "map":
				new_object.load(node_data[i])
				#load_map(node_data[i])
			
	save_file.close()

func load_map(data):
	for i in data:
		print(i)
