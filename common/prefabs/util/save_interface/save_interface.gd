class_name SaveInterface
extends Node

@export var path : String

var save_dict : Dictionary = {}

func _ready():
	load_data()

func load_data():
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		if data is Dictionary:
			save_dict = data
		else:
			printerr("Save data is not a dictionary.")
	else:
		printerr("Save file path does not exist.")

func save_data():
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(save_dict)
	file.close()

func get_save_value(val_name : String):
	if save_dict.has(val_name):
		return save_dict[val_name]
	return null

func set_save_value(val_name : String, data):
	save_dict[val_name] = data

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		save_data()
