extends RigidBody2D

var speed = 1500
var damage = 25
var lifetime = 3

onready var initial_position = global_position

func _ready():
	gravity_scale = 0
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))
	SelfDestruct()
	
func SelfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	if !body.is_in_group("Bullets") or !body.is_in_group("Player"):
		self.hide()
