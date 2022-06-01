extends PanelContainer

const FLASH_THRESHOLD	= 0.75
const FLASH_STEP		= 8
const FLASH_MIN			= 127
const FLASH_MAX			= 255
const CLD_NAME			= 0
const CLD_WEIGHT		= 1

var world
onready var bar = $VBoxContainer/MarginContainer/CapacityBar
var forward: bool = true


func _ready():
	world = get_node("/root/World")
	Globals.Inventory = self
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		self.visible = not self.visible
	if self.visible:
		update_weight_bar()
		weight_bar_animation()
		bar_flashing()

func bar_flashing():
	var bar_val = bar.value
	var bar_max = bar.max_value
	
	var btheme = bar.theme.get("ProgressBar/styles/bg")
	var outline_shadow = btheme.get("shadow_color")
	
	if(bar_val / bar_max < FLASH_THRESHOLD):
		outline_shadow.a8 = 0
		btheme.set("shadow_color", outline_shadow)
		return
	elif outline_shadow.a8 == 0:
		forward = true
		outline_shadow.a8 = FLASH_MIN
		btheme.set("shadow_color", outline_shadow)
		
	
	match forward:
		true:
			outline_shadow.a8 += FLASH_STEP
		false:
			outline_shadow.a8 -= FLASH_STEP
			
	clamp(outline_shadow.a8, FLASH_MIN, FLASH_MAX)
	
	match outline_shadow.a8:
		FLASH_MIN:
			forward = true
		FLASH_MAX:
			forward = false
			
	btheme.set("shadow_color", outline_shadow)
	
	
func weight_bar_animation():
	var value = bar.value
	var max_val = bar.max_value
	var btheme = bar.theme
	var bfg = btheme.get("ProgressBar/styles/fg")
	var ratio = value/max_val
	var bar_color = lerp(Color.green, Color.red, ratio)
	bfg.bg_color = bar_color
	pass

func update_weight_bar():
	var player = world.get_node("Player").get_child(0)
	var inv_weight = player.cargo_weight
	var inv_max = player.cargo_max_weight
	bar.max_value = inv_max
	bar.value = inv_weight

func _on_cargo_added(loot, tid):
	var loot_name = GameData.get_tid_as_string(tid)
	var ore_list = $VBoxContainer/ScrollContainer/OreList
	var entry = ore_list.find_node(loot_name, false, false)
	
	if entry == null:
		var new_node = create_inventory_nodes_empty(loot_name)
		entry = new_node
	
	var weight_node = entry.get_child(CLD_WEIGHT)
	var weight = int(weight_node.text)
	weight += loot.y
	weight_node.text = str(weight)

func create_inventory_nodes_empty(node_name):
	var line = HSplitContainer.new()
	var name_lbl = Label.new()
	var weight_lbl = Label.new()
	line.name = node_name
	name_lbl.name = "ore"
	name_lbl.align = Label.ALIGN_LEFT
	name_lbl.text = node_name
	weight_lbl.name = "weight"
	weight_lbl.align = Label.ALIGN_RIGHT
	line.add_child(name_lbl)
	line.add_child(weight_lbl)
	$VBoxContainer/ScrollContainer/OreList.add_child(line)
	return line

func create_inventory_nodes(node_name, weight):
	var new_node = create_inventory_nodes_empty(node_name)
	var weight_node = new_node.get_child(CLD_WEIGHT)
	weight_node.text = str(weight)

func clear_all_inventory_nodes():
	var orelist = $VBoxContainer/ScrollContainer/OreList
	var children = orelist.get_children()
	for child in children:
		orelist.remove_child(child)
		child.free()

func _on_Inventory_visible():
	var player = world.get_node("Player").get_child(0)
	var inv = player.cargo
	update_weight_bar()
	if(self.visible):
		if inv != null:
			for tid in inv:
				var entry = inv.get(tid)
				var entry_name = GameData.get_tid_as_string(tid)
				var entry_weight = entry.weight
				if(entry_weight > 0):
					create_inventory_nodes(entry_name, entry_weight)
	else:
		clear_all_inventory_nodes()


func _on_EjectButton_pressed():
	var player = world.get_node("Player").get_child(0)
	player.eject_cargo(null)
	clear_all_inventory_nodes()
