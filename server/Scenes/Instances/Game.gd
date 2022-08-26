extends Node2D


var PLAYER = preload("res://Scenes/Instances/Player.tscn")
var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func AddPlayer(player):
	var player_cont = PLAYER.instance()
	player_cont.name = str(player)
	add_child(player_cont)
	players.append(player)
	print(players)
