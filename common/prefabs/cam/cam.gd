class_name Cam
extends CharacterBody3D

@onready var camera : Camera3D = $Camera3D

var follow_transform : Node3D
var player : Player
var cam_speed : float

func _ready():
	player = Manager.game.player
	follow_transform = player.current_cam_follow_transform

func _process(delta):
	follow_transform = player.current_cam_follow_transform

func _physics_process(delta):
	if follow_transform != null:
		cam_speed = player.speed
		global_basis = global_basis.slerp(follow_transform.global_basis, 0.2)
		var dist : float = clampf(global_position.distance_to(follow_transform.global_position), 0.0, 1.0)
		velocity = velocity.lerp(player.velocity + (global_position.direction_to(follow_transform.global_position) * cam_speed * dist), 0.2)
		move_and_slide()
