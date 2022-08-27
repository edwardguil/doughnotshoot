extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()
	

func updateLabel():
	print("updateLabel called")
	var player = get_tree().get_current_scene().get_node("Player")
	var format_string = "Health: %s\nKills: %s\nDeaths: %s\n"
	var health = player.get("health")
	var kills = player.get("kills")
	var deaths = player.get("deaths")
	var actual_string = format_string % [health, kills, deaths]
	text = actual_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
