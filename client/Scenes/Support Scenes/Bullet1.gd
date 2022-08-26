extends RigidBody2D

var speed = 1000
var damage = 25

onready var initial_position = global_position

func _ready():
	gravity_scale = 0
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))
