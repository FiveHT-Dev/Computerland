class_name DialogueAgent
extends Node

@export var graph_start_node : DialogueGraphNode
@export var focus_camera : bool

@onready var save_interface : SaveInterface

func _ready():
	save_interface = get_node_or_null("SaveInterface")
	if save_interface == null:
		for c in get_children():
			if c is SaveInterface:
				save_interface = c
				break

func talked_to():
	if save_interface != null:
		var num_times_talked_to = save_interface.get_save_value("num_times_talked_to", 0)
		num_times_talked_to += 1
		save_interface.set_save_value("num_times_talked_to", num_times_talked_to)
