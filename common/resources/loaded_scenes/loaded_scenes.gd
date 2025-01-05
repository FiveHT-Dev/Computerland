class_name LoadedScenes
extends Resource

const NULL_SCENE = preload("res://scenes/debug/null_scene.tscn")

var data : Dictionary = {}

func create_data():
	var scene_folders : PackedStringArray = DirAccess.get_directories_at("res://scenes/")
	for s_folder : String in scene_folders:
		var dir_path : String = "res://scenes/" + s_folder
		var s_folder_files : PackedStringArray = DirAccess.get_files_at(dir_path)
		for file : String in s_folder_files:
			if file.ends_with(".tscn"):
				var file_path : String = dir_path + "/" +file
				data[file_path] = load(file_path)

func get_loaded_scene(path : String) -> PackedScene:
	var s : PackedScene = null
	if data.has(path):
		s = data[path]
	if s != null:
		return data[path]
	else:
		return NULL_SCENE
