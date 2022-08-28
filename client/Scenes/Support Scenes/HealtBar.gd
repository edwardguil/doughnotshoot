extends Node2D

var current = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func reduce_health():
	if current == 3:
		current = current - 1
		$Health3Anim.play("empty")
	elif current == 2:
		current = current - 1
		$Health2Anim.play("empty")
	elif current == 1:
		current = current - 1
		$Health2Anim.play("empty")

func set_health(val):
	if val == 3:
		current = 3
		$Health3Anim.play("full")
		$Health2Anim.play("full")
		$Health2Anim.play("full")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
