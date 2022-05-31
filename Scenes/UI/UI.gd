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
	$Vitals/VBoxContainer/HP_bar.max_value = player_obj.MAX_HP
	$Vitals/VBoxContainer/HP_bar.value = player_obj.HP
	$Vitals/VBoxContainer/HP_bar/Label.text = str(player_obj.HP) + " / " + str(player_obj.MAX_HP)

func update_fuel():
	$Vitals/VBoxContainer/Fuel_bar.max_value = player_obj.MAX_FUEL
	$Vitals/VBoxContainer/Fuel_bar.value = player_obj.FUEL
	$Vitals/VBoxContainer/Fuel_bar/Label.text = str(int(player_obj.FUEL)) + " / " + str(player_obj.MAX_FUEL)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_obj = get_parent().get_node("Player").get_child(0)
	update_health()
	update_fuel()
	pass
