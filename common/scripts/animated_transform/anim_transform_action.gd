class_name AnimTransformAction
extends Node

@onready var e_t_offset : float = randf_range(0.0, 1000.0)

func _ready():
	set_process(false)

func do_action(delta : float, elapsed_time : float, t : Node3D):
	_on_do_action(delta, elapsed_time + e_t_offset, t)

func _on_do_action(delta : float, elapsed_time : float, t : Node3D):
	pass
