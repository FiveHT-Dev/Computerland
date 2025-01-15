class_name AnimatedTransform
extends Node3D

@export var animate : bool = true

var elapsed_time : float
var anim_actions : Array[AnimTransformAction]
# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c is AnimTransformAction:
			anim_actions.append(c)

func _process(delta):
	if animate:
		elapsed_time += delta
		for a in anim_actions:
			a.do_action(delta, elapsed_time, self)
