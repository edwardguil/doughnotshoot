extends Node2D

var weapons = ["Gun1", "Gun2"]
var current_weapon = 0

func FireWeapon(mouse_position):
	var current_weapon_node = get_node(weapons[current_weapon])
	current_weapon_node.fire(mouse_position)

func FireWeaponDontSend(mouse_position):
	var current_weapon_node = get_node(weapons[current_weapon])
	current_weapon_node.FireWeaponDontSend(mouse_position)
	
func ChangeWeapon():
	get_node(weapons[current_weapon]).hide()
	current_weapon = (current_weapon + 1) % len(weapons)
	get_node(weapons[current_weapon]).show()

func IdleWeapon():
	pass

func FlipSprite(val):
	if val:
		$Gun1/Sprite.flip_v = true
		$Gun2/Sprite.flip_v = true
	else:
		$Gun1/Sprite.flip_v = false
		$Gun2/Sprite.flip_v = false
