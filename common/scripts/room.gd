class_name Room
extends Node3D

@export var hide_player : bool = false
@export var hide_in_game_ui : bool = false
@export var post_process_list : PostProcessList

@onready var game : Game = get_parent()
@onready var gates : Node = $utilities/gates
@onready var player_spawn_pos = $utilities/player_spawn_pos


func room_removed():
	pass
