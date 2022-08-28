extends RigidBody2D

var speed = 1500
var damage = 25
var lifetime = 3
var bullet_owner = 0

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
	print("HIT: ", body.name)
	print("PLAYERS: ", GameController.player_list)
	print("Bullet Owner", bullet_owner)
	print("Bool", str(bullet_owner) != str(body.name))
	if body.name == "Player":
		if bullet_owner != str(get_tree().get_network_unique_id()):
			get_tree().get_current_scene().get_node("CanvasLayer/Label").updateLabel()
			body.gotHit(bullet_owner)
			self.hide()
	elif body.name in GameController.player_list:
		if bullet_owner != body.name:
			body.gotHit()
			self.hide()
	else:
		self.hide()
