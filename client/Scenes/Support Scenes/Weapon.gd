extends Node2D

var weapons = ["Gun1", "Gun2"]
var current_weapon = 0

func FireWeapon(mouse_position):
	get_node(weapons[current_weapon]).fire(mouse_position)
	print($Gun1/Sprite1/Exit1.global_position)
	print($Gun2/Sprite2/Exit2.global_position)

func ChangeWeapon():
	get_node(weapons[current_weapon]).hide()
	current_weapon = (current_weapon + 1) % len(weapons)
	get_node(weapons[current_weapon]).show()

func FlipSprite(val):
	if val:
		$Gun1/Sprite1.flip_v = true
		$Gun2/Sprite2.flip_v = true
	else:
		$Gun1/Sprite1.flip_v = false
		$Gun2/Sprite2.flip_v = false
