extends Node2D

export(NodePath) var player_path
onready var player = get_node(player_path) as Node2D

var is_ahead = true

func _physics_process(delta):
	if not player:
		return

	if Input.is_action_just_pressed("swap") and not player.dead and not player.is_swapping:
		swap_with_player()
		return

	if not player.is_swapping:
		if is_ahead:
			global_position.x = player.global_position.x + 1000
			global_position.y = player.global_position.y
		else:
			global_position.x = player.global_position.x - 1000
			global_position.y = player.global_position.y

func swap_with_player():
	is_ahead = not is_ahead
	player.is_swapping = true
	
	var old_object_pos = global_position
	var old_player_pos = player.global_position
	
	player.global_position = old_object_pos
	global_position = old_player_pos
	
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	if is_instance_valid(player):
		player.is_swapping = false
		player.check_rain_after_swap()
