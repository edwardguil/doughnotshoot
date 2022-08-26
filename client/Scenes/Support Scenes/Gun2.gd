extends Node2D

var BULLET_PATH = preload("res://Scenes/Support Scenes/Weapons/Bullet2.tscn")
var can_fire = true
var fire_rate = 0.2
var timing = false

func _ready():
	$AnimationPlayer.play("idle")
	$AnimationPlayer.playback_speed = 1.5

func fire(mouse_position):
	if can_fire:
		can_fire = false
		var bullet1 = BULLET_PATH.instance()
		bullet1.position = $Sprite/Exit1.global_position
		bullet1.rotation = get_parent().rotation
		$AnimationPlayer.play("fire")
		yield(get_tree().create_timer($AnimationPlayer.playback_speed * 0.2), "timeout")
		delayedBullet(bullet1)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

func delayedBullet(bullet):
	bullet.position = $Sprite/Exit1.global_position
	get_parent().get_parent().get_parent().add_child(bullet)
	
