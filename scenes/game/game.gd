class_name Game
extends Node3D

const IN_GAME_UI = preload("res://ui/scenes/in_game_ui/in_game_ui.tscn")
const PLAYER = preload("res://common/prefabs/player/player.tscn")
const CAM = preload("res://common/prefabs/cam/cam.tscn")
const CRT_FILTER = preload("res://ui/post_processing/crt_filter/crt_filter.tscn")

@export var override_room : bool
@export var override_room_path : String

var loaded_scenes : LoadedScenes
var current_room : Room
var in_game_ui : InGameUI
var player : Player
var cam : Cam

# initialise game
func _ready():
	Manager.game = self
	loaded_scenes = LoadedScenes.new()
	loaded_scenes.create_data()
	player = PLAYER.instantiate()
	in_game_ui = IN_GAME_UI.instantiate()
	cam = CAM.instantiate()
	if override_room:
		switch_rooms(override_room_path)

# delte current room and load next room using path.
func switch_rooms(path : String):
	if current_room != null:
		current_room.room_removed()
		current_room.queue_free()
	current_room = loaded_scenes.get_loaded_scene(path).instantiate()
	add_child(current_room)
	
	if current_room.hide_in_game_ui:
		hide_in_game_ui()
	else:
		show_in_game_ui()
	
	if current_room.hide_player:
		hide_player()
	else:
		show_player()

func hide_player():
	player.global_position = Vector3.ZERO
	if player.is_inside_tree():
		remove_child(player)
	if cam.is_inside_tree():
		remove_child(cam)

func show_player():
	if !player.is_inside_tree():
		add_child(player)
	if !cam.is_inside_tree():
		add_child(cam)

func hide_in_game_ui():
	if in_game_ui.is_inside_tree():
		remove_child(in_game_ui)

func show_in_game_ui():
	if !in_game_ui.is_inside_tree():
		add_child(in_game_ui)
