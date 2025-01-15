class_name CamFollowArea
extends Area3D

enum FollowType{
	PLAYER,
	OBJECT,
	NONE
}

@export var follow_type : FollowType
@export var follow_object : Node3D
@export var teleport_on_enter : bool = false

func _on_body_entered(body):
	if body is Player:
		Manager.game.cam.change_follow_type(follow_type, follow_object)
		if teleport_on_enter && follow_object != null:
			Manager.game.cam.force_to_transform(follow_object)


func _on_body_exited(body):
	if body is Player:
		Manager.game.cam.change_follow_type(FollowType.PLAYER, null)
