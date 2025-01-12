class_name CamFollowArea
extends Area3D

enum FollowType{
	PLAYER,
	OBJECT,
	NONE
}

@export var follow_type : FollowType
@export var follow_object : Node3D

func _on_body_entered(body):
	if body is Player:
		Manager.game.cam.change_follow_type(follow_type, follow_object)


func _on_body_exited(body):
	if body is Player:
		Manager.game.cam.change_follow_type(FollowType.PLAYER, null)
