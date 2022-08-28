extends Node2D

var BULLET_PATH = preload("res://Scenes/Support Scenes/Weapons/Bullet1.tscn")
var can_fire = true
var fire_rate = 0.75

func _ready():
	$AnimationPlayer.play("idle")
	$AnimationPlayer.playback_speed = 2.0

func fire(mouse_position):
	if can_fire:
		var shoot_action = {"T": Server.client_clock, "P": get_parent().get_parent().get_global_position(), "R": mouse_position}
		Server.SendShootAction(shoot_action)
		can_fire = false
		var bullet1 = BULLET_PATH.instance()
		bullet1.position = $Sprite/Exit1.global_position
		bullet1.rotation = get_parent().rotation
		bullet1.bullet_owner = str(get_tree().get_network_unique_id())
		get_parent().get_parent().get_parent().add_child(bullet1)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

func FireWeaponDontSend(mouse_position, player_id):
	if can_fire:
		can_fire = false
		var bullet1 = BULLET_PATH.instance()
		bullet1.position = $Sprite/Exit1.global_position
		bullet1.rotation = get_parent().rotation
		bullet1.bullet_owner = player_id
		get_parent().get_parent().get_parent().add_child(bullet1)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
