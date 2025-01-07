extends Node

var dirs_to_check : PackedStringArray = [
	"user://saves",
	"user://saves/rooms",
	"user://saves/dialogue_agents",
]

func _ready():
	dir_init()

func dir_init():
	for dir : String in dirs_to_check:
		if !DirAccess.dir_exists_absolute(dir):
			DirAccess.make_dir_absolute(dir)
