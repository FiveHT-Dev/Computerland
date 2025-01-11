class_name Cam
extends CharacterBody3D

@onready var camera : Camera3D = $Camera3D

var follow_transform : Node3D
var player : Player
var cam_speed : float

var follow_player : bool = true

var follow_object : Node3D
var override_focus_object : Node3D

func _ready():
	player = Manager.game.player
	follow_transform = player.current_cam_follow_transform

func change_follow_type(type : CamFollowArea.FollowType, object : Node3D):
	if type == CamFollowArea.FollowType.PLAYER:
		follow_player = true
	elif type == CamFollowArea.FollowType.OBJECT:
		follow_player = false
		follow_object = object
	else:
		follow_player = false
		follow_object = null

func _process(delta):
	if override_focus_object != null:
		follow_transform = override_focus_object
	else:
		if follow_player:
			follow_transform = player.current_cam_follow_transform
			cam_speed = player.speed
		else:
			follow_transform = follow_object
			cam_speed = 5.0

func add_override_focus(focus : Node3D):
	override_focus_object = focus

func force_to_follow_transform():
	if follow_transform == null:
		follow_transform = player.current_cam_follow_transform
	global_position = follow_transform.global_position
	global_basis = follow_transform.global_basis

func remove_override_focus():
	override_focus_object = null

func _physics_process(delta):
	if follow_transform != null:
		global_basis = global_basis.slerp(follow_transform.global_basis, 0.2)
		var dist : float = clampf(global_position.distance_to(follow_transform.global_position), 0.0, 1.0)
		velocity = velocity.lerp(player.velocity + (global_position.direction_to(follow_transform.global_position) * cam_speed * dist), 0.2)
		move_and_slide()
