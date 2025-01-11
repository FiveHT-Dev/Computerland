class_name RoomGate
extends Trigger

## res://rooms/ + (next_room_path) + .tscn
@export var next_room_path : String
@export var next_room_gate_index : int
@onready var spawn_transform : Node3D = $spawn_transform

func _on_player_entered():
	Manager.game.start_switching_rooms(next_room_path, next_room_gate_index)


func _on_player_interacted():
	Manager.game.start_switching_rooms(next_room_path, next_room_gate_index)
