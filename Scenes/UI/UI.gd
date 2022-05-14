extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_obj

# Called when the node enters the scene tree for the first time.
func _ready():
	player_obj = get_parent().get_node("Player").get_child(0)
	pass

func update_health():
	$PanelContainer/VBoxContainer/HP_bar.max_value = player_obj.MAX_HP
	$PanelContainer/VBoxContainer/HP_bar.value = player_obj.HP
	$PanelContainer/VBoxContainer/HP_bar/Label.text = str(player_obj.HP) + " / " + str(player_obj.MAX_HP)

func update_fuel():
	$PanelContainer/VBoxContainer/Fuel_bar.max_value = player_obj.MAX_FUEL
	$PanelContainer/VBoxContainer/Fuel_bar.value = player_obj.FUEL
	$PanelContainer/VBoxContainer/Fuel_bar/Label.text = str(int(player_obj.FUEL)) + " / " + str(player_obj.MAX_FUEL)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_obj = get_parent().get_node("Player").get_child(0)
	update_health()
	update_fuel()
	pass
