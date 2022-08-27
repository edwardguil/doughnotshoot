extends KinematicBody2D

var SPEED = 600
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
		$anim.play("wobbledown")
	else:
		$anim.stop()
		
	if mouse_position.x < global_position.x:
		$Frough.flip_h = true
		if $Weapon.scale.y > 0:
			$Weapon.scale.y = -$Weapon.scale.y
			$Weapon.position.x = -50
			$Weapon.position.y = 20
		$Weapon.FlipSprite(true)
	else:
		$Frough.flip_h = false
		if $Weapon.scale.y < 0:
			$Weapon.scale.y = -$Weapon.scale.y  
			$Weapon.position.y = 10
			$Weapon.position.x = 54
		$Weapon.FlipSprite(false)
