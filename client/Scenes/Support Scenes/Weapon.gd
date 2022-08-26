extends Node2D

var weapons = ["Gun1"]
var current_weapon = 0

func FireWeapon(mouse_position):
	get_node(weapons[current_weapon]).fire(mouse_position)

func FlipSprite(val):
	if val:
		$Gun1/Sprite.flip_v = true
		$Gun2/Sprite.flip_v = true
	else:
		$Gun1/Sprite.flip_v = false
		$Gun2/Sprite.flip_v = false
