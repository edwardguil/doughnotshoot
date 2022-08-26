extends KinematicBody2D

var SPEED = 300
var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity = Vector2(x_input, y_input).normalized()
	handle_input(velocity)
	move_and_slide(velocity * SPEED)
	


func handle_input(velocity) -> void:
	if velocity.x < 0:
		$AnimationPlayer.play("walk")
		$Sprite.flip_h = true
	elif velocity.x > 0:
		$AnimationPlayer.play("walk")
		$Sprite.flip_h = false
	elif velocity.y != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
