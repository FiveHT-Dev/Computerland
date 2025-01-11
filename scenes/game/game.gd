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
var next_room : Room
var next_gate_index : int = -1
var in_game_ui : InGameUI
var player : Player
var cam : Cam
var switching_rooms : bool = false

# initialise game
func _ready():
	Manager.game = self
	loaded_scenes = LoadedScenes.new()
	loaded_scenes.create_data()
	player = PLAYER.instantiate()
	in_game_ui = IN_GAME_UI.instantiate()
	cam = CAM.instantiate()
	if override_room:
		force_load_room(override_room_path, -1)

# delte current room and load next room using path.
func start_switching_rooms(path : String, gate_index : int):
	var room : PackedScene = loaded_scenes.get_loaded_scene("res://scenes/rooms/" + path + ".tscn")
	if room != null:
		next_room = room.instantiate()
	else:
		next_room = loaded_scenes.NULL_ROOM.instantiate()
	next_gate_index = gate_index
	switching_rooms = true

func force_load_room(path : String, gate_index : int):
	if current_room != null:
		current_room.room_removed()
		current_room.queue_free()
	var room : PackedScene = loaded_scenes.get_loaded_scene("res://scenes/rooms/" + path + ".tscn")
	if room != null:
		current_room = room.instantiate()
	else:
		current_room = loaded_scenes.NULL_ROOM.instantiate()
	next_gate_index = gate_index
	add_child(current_room)
	
	if current_room.hide_in_game_ui:
		hide_in_game_ui()
	else:
		show_in_game_ui()
	
	if current_room.hide_player:
		hide_player()
	else:
		show_player()
	
	spawn_player()

func switch_rooms():
	if current_room != null:
		current_room.room_removed()
		current_room.queue_free()
	current_room = next_room
	next_room = null
	add_child(current_room)
	
	if current_room.hide_in_game_ui:
		hide_in_game_ui()
	else:
		show_in_game_ui()
	
	if current_room.hide_player:
		hide_player()
	else:
		show_player()
	spawn_player()

func _process(delta):
	if switching_rooms:
		if in_game_ui.t_circ_close():
			switch_rooms()
			switching_rooms = false
	else:
		in_game_ui.t_circ_open()

func spawn_player():
	var num_gates : int = current_room.gates.get_child_count()
	if next_gate_index < 0 || num_gates == 0 || num_gates <= next_gate_index:
		player.place_at_new_transform(current_room.player_spawn_pos)
	else:
		var gate : RoomGate = current_room.gates.get_child(next_gate_index)
		player.place_at_new_transform(gate.spawn_transform)
	next_room = null

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
