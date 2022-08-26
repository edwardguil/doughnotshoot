extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_FindGame_pressed():
	Server.JoinQueue()


func _on_TestGame_pressed():
	get_tree().change_scene("res://Scenes/MainScenes/Level.tscn")

func SetQueueStatus(new_status):
	if new_status == 1:
		# Show waiting screen
		pass
	elif new_status == 2:
		GameController.NewGame()
