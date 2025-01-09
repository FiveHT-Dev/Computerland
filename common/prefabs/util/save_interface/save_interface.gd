class_name SaveInterface
extends Node

@export var path : String

var path_prefix : String = "user://saves/"
var path_suffix : String = ".save"
var save_dict : Dictionary = {}

func _ready():
	load_data()

func load_data():
	if FileAccess.file_exists(path_prefix + path + path_suffix):
		var file = FileAccess.open(path_prefix + path + path_suffix, FileAccess.READ)
		var data = file.get_var()
		file.close()
		if data is Dictionary:
			save_dict = data
		else:
			printerr("Save data is not a dictionary.")
	else:
		print("Save file path does not exist.")

func initialise_dict(reference_dict : Dictionary):
	if save_dict.is_empty():
		save_dict = Dictionary(reference_dict)

func save_data():
	var file = FileAccess.open(path_prefix + path + path_suffix, FileAccess.WRITE)
	file.store_var(save_dict)
	file.close()

func get_save_value(val_name : String, default) -> Variant:
	if save_dict.has(val_name):
		return save_dict[val_name]
	else:
		save_dict[val_name] = default
		return save_dict[val_name]

func set_save_value(val_name : String, data):
	save_dict[val_name] = data

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		save_data()
