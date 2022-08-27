extends RigidBody2D

var speed = 1500
var damage = 25
var lifetime = 1.5

onready var initial_position = global_position

func _ready():
	gravity_scale = 0
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))
	connect("body_entered", self, "_on_character_body_entered")
	SelfDestruct()
	
func SelfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()

func _on_character_body_entered(body):
	print("hit something")
	print(body)
	print(body.name)
	if body.name == "Player":
		print("hit player")
		body.gotHit()
		get_tree().get_current_scene().get_node("CanvasLayer/Label").updateLabel()
		self.hide()
	else:
		self.hide()
