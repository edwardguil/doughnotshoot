extends Node2D

var BULLET_PATH = preload("res://Scenes/Support Scenes/Bullet1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire(mouse_position):
	var bullet1 = BULLET_PATH.instance()
	bullet1.position = $Sprite1/Exit1.global_position
	bullet1.rotation = get_parent().rotation
	var bullet2 = BULLET_PATH.instance()
	bullet2.position = $Sprite1/Exit1.global_position
	bullet2.rotation = get_parent().rotation + get_parent().rotation * 0.4
	var bullet3 = BULLET_PATH.instance()
	bullet3.position = $Sprite1/Exit1.global_position
	bullet3.rotation = get_parent().rotation - get_parent().rotation * 0.4
	
	get_parent().get_parent().get_parent().add_child(bullet1)
	get_parent().get_parent().get_parent().add_child(bullet2)
	get_parent().get_parent().get_parent().add_child(bullet3)
