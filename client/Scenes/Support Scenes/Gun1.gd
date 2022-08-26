extends Node2D

var BULLET_PATH = preload("res://Scenes/Support Scenes/Weapons/Bullet1.tscn")
var can_fire = true
var fire_rate = 0.75

func _ready():
	$AnimationPlayer.play("idle")
	$AnimationPlayer.playback_speed = 2.0

func fire(mouse_position):
	if can_fire:
		can_fire = false
		var bullet1 = BULLET_PATH.instance()
		bullet1.position = $Sprite/Exit1.global_position
		bullet1.rotation = get_parent().rotation
		var bullet2 = BULLET_PATH.instance()
		bullet2.position = $Sprite/Exit2.global_position
		bullet2.rotation = get_parent().rotation
		var bullet3 = BULLET_PATH.instance()
		bullet3.position = $Sprite/Exit3.global_position
		bullet3.rotation = get_parent().rotation
		
		
		$AnimationPlayer.play("fire")
		get_parent().get_parent().get_parent().add_child(bullet1)
		get_parent().get_parent().get_parent().add_child(bullet2)
		get_parent().get_parent().get_parent().add_child(bullet3)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
