class_name Trigger
extends Area3D

@export var has_to_interact: bool = false
@export var delete_on_interact : bool = false
@onready var col : CollisionShape3D = $CollisionShape3D

var has_player : bool = false
var player : Player
var can_interact_t : float = 0.5
var can_interact : bool = false
signal player_interacted()
signal player_entered()
signal delete()

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_player_entered():
	pass

func execute_command():
	pass

func _on_player_interacted():
	pass

func _on_player_exited():
	pass

func _process(delta):
	can_interact = can_interact_t < 0.0
	if can_interact:
		if !has_to_interact:
			set_process(false)
			return
		if has_player:
			if Input.is_action_just_pressed("interact"):
				if Manager.game.in_game_ui.check_if_player_can_move():
					_on_player_interacted()
					player_interacted.emit()
					if delete_on_interact:
						delete.emit()
						queue_free()
	else:
		can_interact_t -= delta

#func _try_show_interact(val : bool):
#	if has_to_interact && SceneManager.current_scene.in_game_ui != null:
#		if val && SceneManager.current_scene.in_game_ui.can_player_move:
#			if !SceneManager.current_scene.in_game_ui.triggers_that_have_player.has(get_instance_id()):
#				SceneManager.current_scene.in_game_ui.triggers_that_have_player[get_instance_id()] = self
#		else:
#			if SceneManager.current_scene.in_game_ui.triggers_that_have_player.has(get_instance_id()):
#				SceneManager.current_scene.in_game_ui.triggers_that_have_player.erase(get_instance_id())

func _on_body_entered(body):
	if body is Player && can_interact && body != null:
		if player == null:
			player = body
		has_player = true
		if !has_to_interact:
			if Manager.game.in_game_ui.check_if_player_can_move():
				_on_player_entered()
				player_entered.emit()
				if delete_on_interact:
					delete.emit()
					queue_free()
		else:
			body.add_trigger(self)


func _on_body_exited(body):
	if body is Player && can_interact && body != null:
		_on_player_exited()
		#_try_show_interact(false)
		body.remove_trigger(self)
		has_player = false
