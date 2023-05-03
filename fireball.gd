extends RigidBody2D

var timer_vida=1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_vida=timer_vida-delta
	if timer_vida<=0:
		queue_free()
