extends KinematicBody2D

var SPEED = 600
var velocity = Vector2(0, 0)
var mouse_position = Vector2(0, 0)
var player_state = {}
var health = 3
var max_health = 3
var kills = 0
var deaths = 0

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
		$Weapon.FireWeapon(mouse_position)
		
	DefinePlayerState(mouse_position)
	

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

	else:
		$Frough.flip_h = false
		if $Weapon.scale.y < 0:
			$Weapon.scale.y = -$Weapon.scale.y 
			$Weapon.position.y = 10
			$Weapon.position.x = 54

		
func DefinePlayerState(mouse_position):
	player_state = {"T": OS.get_system_time_msecs(), "P": get_global_position(), "R": mouse_position}
	Server.SendPlayerState(player_state)
	
func gotHit():
	health = health - 1
	if (health <= 0):
		health = max_health
		deaths = deaths + 1
		respawn()
		
func respawn():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(-450, 1500)
	var y = rng.randf_range(-500, 1200)
	position = Vector2(x, y)
	
