extends KinematicBody2D

var speed = 1800
var velocity = Vector2()

var rain_blocks_count = 0
var dead = false
var vin = false
var is_swapping = false

func _ready():
	$RainDetector.connect("area_entered", self, "_on_rain_entered")
	$RainDetector.connect("area_exited", self, "_on_rain_exited")

func get_input():
	velocity.x = 0
	if not dead and not vin:
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		velocity.x *= speed

func _physics_process(delta):
	velocity.y += 30
	
	get_input()
	
	if not dead and not vin:
		if is_on_floor() and Input.is_action_just_pressed('ui_up'):
			velocity.y = -800
			
		if position.y < -100:
			die()
			
		if position.x >= 15000:
			vin = true
			$CanvasLayer/Label.text = "you win!"
			$CanvasLayer/Button.visible = true
			
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_rain_entered(area):
	if not dead and not vin and not is_swapping:
		if area.is_in_group("rain"):
			if rain_blocks_count == 0:
				print("on")
			rain_blocks_count += 1

func _on_rain_exited(area):
	if not dead and not vin and not is_swapping:
		if area.is_in_group("rain"):
			rain_blocks_count -= 1
			if rain_blocks_count <= 0:
				rain_blocks_count = 0
				die()

func die():
	if not dead and not vin:
		print("die")
		dead = true
		$CanvasLayer/Label.text = "You died"
		$CanvasLayer/Button.visible = true

func check_rain_after_swap():
	rain_blocks_count = 0
	for area in $RainDetector.get_overlapping_areas():
		if area.is_in_group("rain"):
			rain_blocks_count += 1
			
	if rain_blocks_count == 0:
		die()

func _on_Button_pressed():
	dead = false
	vin = false
	is_swapping = true
	velocity = Vector2.ZERO
	position = Vector2(0, 200)
	$CanvasLayer/Label.text = ""
	$CanvasLayer/Button.visible = false
	
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	is_swapping = false
	check_rain_after_swap()
