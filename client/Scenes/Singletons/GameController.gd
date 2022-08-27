extends Node

const ENEMY_PLAYER = preload("res://Scenes/Support Scenes/EnemyPlayer.tscn")
const CURRENT_PLAYER =  preload("res://Scenes/Support Scenes/Player.tscn")
const INTERPOLATION_OFFSET = 20 # In milliseconds, default 100

var world_state_buffer = []
var last_world_state = 0
var in_game = 0

func NewGame():
	get_tree().change_scene("res://Scenes/MainScenes/James Level.tscn")
	print("New Game Started")


func SpawnPlayers(players, positions):
	yield(get_tree().current_scene, "tree_exited")
	yield(get_tree(), "idle_frame")
	var new_player
	for i in range(len(players)):
		print(players[i])
		var player_id = players[i]
		var position = positions[i]
		if get_tree().get_network_unique_id() == player_id:
			#new_player = CURRENT_PLAYER.instance()
			#new_player.position = position
			get_tree().get_current_scene().get_node("Player").position = position
			#get_tree().get_current_scene().add_child(new_player, true)
		else:
			if not get_tree().get_current_scene().has_node(str(player_id)):
				new_player = ENEMY_PLAYER.instance()
				new_player.name = str(player_id)
				new_player.position = position
				get_tree().get_current_scene().add_child(new_player, true)

func DespawnPlayers(player_id):
	yield(get_tree().create_timer(0.2), "timeout")
	print(get_tree().get_current_scene().has_node(str(player_id)))
	if get_tree().get_current_scene().has_node(str(player_id)):
		get_tree().get_current_scene().get_node(str(player_id)).queue_free()

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
			
func _physics_process(delta):
	var render_time = Server.client_clock - INTERPOLATION_OFFSET

	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2: # We have a future state, interpolate
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / (float(world_state_buffer[2]["T"]) - float(world_state_buffer[1]["T"]))
			for player in world_state_buffer[1]["Players"].keys():
				if (player == get_tree().get_network_unique_id() 
						|| not world_state_buffer[1]["Players"].has(player)
						|| not world_state_buffer[2]["Players"].has(player)):
					continue
				if get_tree().get_current_scene().has_node(str(player)):
					var old_position = world_state_buffer[1]["Players"][player]["P"]
					var new_position = lerp(world_state_buffer[1]["Players"][player]["P"], 
										world_state_buffer[2]["Players"][player]["P"], interpolation_factor)
					var new_rotation = lerp(world_state_buffer[1]["Players"][player]["R"], 
										world_state_buffer[2]["Players"][player]["R"], interpolation_factor)
					get_tree().get_current_scene().get_node(str(player)).MovePlayer(new_position, old_position, new_rotation)
				else:
					SpawnPlayers([player], [world_state_buffer[2]["Players"][player]["P"]])
		elif render_time > world_state_buffer[1].T: # We have no future state, extrapolate
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"]) - float(world_state_buffer[0]["T"]) -1.0
			for player in world_state_buffer[1]["Players"].keys():
				if (player == get_tree().get_network_unique_id() 
						|| not world_state_buffer[0].has(player)
						|| not world_state_buffer[1].has(player)):
					continue
				if get_tree().get_current_scene().has_node(str(player)):
					var position_delta = (world_state_buffer[1]["Players"][player]["P"] - world_state_buffer[0]["Players"][player]["P"]) 
					var new_position = world_state_buffer[1]["Players"][player]["P"] + (position_delta * extrapolation_factor)
					var rotation_delta = (world_state_buffer[1]["Players"][player]["R"] - world_state_buffer[0]["Players"][player]["R"]) 
					var new_rotation = world_state_buffer[1]["Players"][player]["R"] + (rotation_delta * extrapolation_factor)
					get_tree().get_current_scene().get_node(str(player)).MovePlayer(new_position, world_state_buffer[1]["Players"][player]["P"], new_rotation)
				else:
					SpawnPlayers([player], [world_state_buffer[2]["Players"][player]["P"]])

func PerformShootAction(shoot_action):
	for player in world_state_buffer[1]["Players"].keys():
		if get_tree().get_current_scene().has_node(str(player)):
			get_tree().get_current_scene().get_node(str(player)).ShootGun(shoot_action["R"])
	
