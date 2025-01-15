class_name RoomGate
extends Trigger

## res://rooms/ + (next_room_path) + .tscn
@export var next_room_path : String
@export var next_room_gate_index : int
@onready var spawn_transform : Node3D = $spawn_transform

var spawn_t : float = 1.0
var can_use : bool = false


func _process(delta):
	if spawn_t > 0.0:
		spawn_t -= delta
	else:
		can_use = true
	super(delta)
	

func _on_player_entered():
	Manager.game.start_switching_rooms(next_room_path, next_room_gate_index)


func _on_player_interacted():
	Manager.game.start_switching_rooms(next_room_path, next_room_gate_index)
