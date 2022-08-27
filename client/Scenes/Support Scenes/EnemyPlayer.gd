extends KinematicBody2D

var SPEED = 300
var velocity = Vector2(0, 0)
var health = 3
var max_health = 3
var kills = 0
var deaths = 0

func MovePlayer(new_position, old_position, mouse_position):
	velocity = new_position - old_position
	set_position(new_position)
	handle_animation(velocity, mouse_position)
	$Weapon.look_at(mouse_position)
	
func ShootGun(mouse_position):
	$Weapon.FireWeaponDontSend(mouse_position)

func handle_animation(velocity, mouse_position) -> void:
	if velocity.x != 0 or velocity.y != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
		
	if mouse_position.x < global_position.x:
		$Sprite.flip_h = true
		$Weapon.FlipSprite(true)
	else:
		$Sprite.flip_h = false
		$Weapon.FlipSprite(false)
	
