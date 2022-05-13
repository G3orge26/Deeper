extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 5
const MAXFALLSPEED = 300
const MAXSPEED = 80
const JUMPFORCE = 200
const ACCEL = 10

var ani_fsm
var ani_cur

var gamemap
var motion = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	ani_fsm = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true
	ani_fsm.start("Idle")
	gamemap = get_parent().get_node("Tilemap")
	pass # Replace with function body.

func arms_aim():
		$Arms.look_at(get_global_mouse_position())
		$Arms2.look_at(get_global_mouse_position())

func flip_sprites(direction):
	if direction < 0:
		$Sprite.flip_h = true
		$Arms.flip_v = true
		$Arms.position.x = 5
		$Arms2.flip_v = true
		$Arms2.position.x = -10
		$Sprite/Exhaust_Smoke.position.x = 33
		$Sprite/Exhaust_SmokeHeavy.position.x = 33
	else:
		$Sprite.flip_h = false
		$Arms.flip_v = false
		$Arms.position.x = -5
		$Arms2.flip_v = false
		$Arms2.position.x = 10
		$Sprite/Exhaust_Smoke.position.x = -33
		$Sprite/Exhaust_SmokeHeavy.position.x = -33
		
func handle_input():
	
	var direction = sign(get_global_mouse_position().x - global_position.x)
	
	flip_sprites(direction)
	
	# Limit motion.x between -maxspeed and maxspeed
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	if Input.is_action_pressed("right"):
		motion.x += ACCEL
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
	else:
		# automatic slowing down
		motion.x = lerp(motion.x, 0, 0.2)
	
	if Input.is_action_pressed("Lclick"):
		ani_fsm.travel("Drill")
		pass
	elif Input.is_action_just_released("Lclick"):
		ani_fsm.travel("Idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			motion.y = -JUMPFORCE

func handle_gravity():
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED	

func handle_animation():
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
	
	handle_gravity()
	handle_input()
	arms_aim()
	handle_animation()
	motion = move_and_slide(motion, UP)

func _on_AnimationArms_animation_changed(new_name):
	ani_cur = new_name
	#print("current animation: " + new_name + "\n")
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.get_class() == "TileMap":
		var cell = body.world_to_map($Arms2/Area2D/CollisionShape2D.global_position)
		var cell_id = body.get_cellv(cell)
		body.set_cellv(cell, 3)
		
	pass # Replace with function body.

func _save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict

func _load():
	pass
