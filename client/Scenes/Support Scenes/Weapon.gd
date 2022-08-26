extends Node2D

var weapons = ["Gun1"]
var current_weapon = 0

func FireWeapon(mouse_position):
	get_node(weapons[current_weapon]).fire(mouse_position)
