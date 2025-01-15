class_name LoadedScenes
extends Resource

const NULL_SCENE = preload("res://scenes/debug/null_scene.tscn")
const NULL_ROOM = preload("res://scenes/rooms/debug/null_room.tscn")
var data : Dictionary = {}
var current_path : String = "res://scenes/"

func create_data():
	var scene_folders : PackedStringArray = DirAccess.get_directories_at("res://scenes/")
	var all_files : PackedStringArray = []
	get_all_files("res://scenes/", ".tscn", all_files)
	
	for f in all_files:
		data[f] = load(f)
		

static func get_all_files(path: String, file_ext := "", files : PackedStringArray = []) -> PackedStringArray:
	var dir : = DirAccess.open(path)
	if file_ext.begins_with("."): # get rid of starting dot if we used, for example ".tscn" instead of "tscn"
		file_ext = file_ext.substr(1,file_ext.length()-1)
	
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()

		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				# recursion
				files = get_all_files(dir.get_current_dir() +"/"+ file_name, file_ext, files)
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				
				files.append(dir.get_current_dir() +"/"+ file_name)

			file_name = dir.get_next()
	else:
		print("[get_all_files()] An error occurred when trying to access %s." % path)
	return files


#func create_data():
#	var scene_folders : PackedStringArray = DirAccess.get_directories_at("res://scenes/")
#	for s_folder : String in scene_folders:
#		var dir_path : String = "res://scenes/" + s_folder
#		var s_folder_files : PackedStringArray = DirAccess.get_files_at(dir_path)
#		for file : String in s_folder_files:
#			if file.ends_with(".tscn"):
#				var file_path : String = dir_path + "/" +file
#				data[file_path] = load(file_path)
#	var room_folders : PackedStringArray = DirAccess.get_directories_at("res://scenes/rooms")
#	for r_folder : String in room_folders:
#		var dir_path : String = "res://scenes/rooms/" + r_folder
#		var r_folder_files : PackedStringArray = DirAccess.get_files_at(dir_path)
#		for file : String in r_folder_files:
#			if file.ends_with(".tscn"):
#				var file_path : String = dir_path + "/" +file
#				data[file_path] = load(file_path)

func get_loaded_scene(path : String) -> PackedScene:
	var s : PackedScene = null
	if data.has(path):
		s = data[path]
	if s != null:
		return data[path]
	else:
		return NULL_SCENE
