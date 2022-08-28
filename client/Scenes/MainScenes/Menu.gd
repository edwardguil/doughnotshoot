extends Control

var PLAYER_PATH = preload("res://Scenes/Support Scenes/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_FindGame_pressed():
	Server.JoinQueue()
	$dough.hide()
	$notWord.hide()
	$shoot.hide()
	$VBoxContainer.hide()
	$AnimationPlayer.play("looking")
	$looking.show()
	

func _on_TestGame_pressed():
	get_tree().change_scene("res://Scenes/MainScenes/James Level.tscn")


func SetQueueStatus(new_status):
	if new_status == 1:
		# Show waiting screen
		pass
	elif new_status == 2:
		GameController.NewGame()
