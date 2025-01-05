extends Node

var game : Game

func switch_scenes(current : Node, next_path : String):
	current.queue_free()
	var s : PackedScene = load(next_path)
	if s != null:
		get_tree().root.add_child(s.instantiate())
