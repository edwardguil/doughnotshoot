extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")


func _button_pressed():
	print("a")
	get_tree().get_current_scene().get_node("Player").respawn()
