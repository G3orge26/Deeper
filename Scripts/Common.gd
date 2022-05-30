extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	pass # Replace with function body.


# Return a random Boolean
func randb():
	match randi() % 2:
		0: return false
		1: return true

func randi_range(min_val: int, max_val: int) -> int:
	return (randi() % max_val) + min_val
