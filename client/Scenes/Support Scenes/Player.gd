extends KinematicBody2D

var SPEED = 300
var velocity = Vector2(0, 0)
var mouse_position = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity = Vector2(x_input, y_input).normalized()
	mouse_position = get_global_mouse_position()
	handle_animation(velocity, mouse_position)
	$Weapon.look_at(mouse_position)
	move_and_slide(velocity * SPEED)
	
	if Input.is_action_just_pressed("change_weapon"):
		$Weapon.ChangeWeapon()
	if Input.is_action_just_pressed("fire"):
		print("Player position", global_position)
		$Weapon.FireWeapon(mouse_position)


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
