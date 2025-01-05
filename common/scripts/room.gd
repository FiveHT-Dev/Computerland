class_name Room
extends Node3D

@export var hide_player : bool = false
@export var hide_in_game_ui : bool = false

@onready var game : Game = get_parent()


func room_removed():
	pass
