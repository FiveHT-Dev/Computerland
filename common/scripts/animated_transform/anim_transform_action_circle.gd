class_name AnimTransformActionCircle
extends AnimTransformAction
@export var radius : float
@export var speed : float

func _on_do_action(delta : float, elapsed_time : float, t : Node3D):
	t.position.x += sin(elapsed_time * speed) * radius
	t.position.z += cos(elapsed_time * speed) * radius
