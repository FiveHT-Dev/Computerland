class_name EnemySelector
extends Node3D

@export var rim_selected_color : Color
@export var pad_selected_color : Color
@export var sphere_selected_color : Color

@export var rim_hovered_color : Color
@export var pad_hovered_color : Color
@export var sphere_hovered_color : Color


@onready var MAT_ES_PAD = preload("res://common/prefabs/battle/mat_es_pad.tres")
@onready var MAT_ES_RIM = preload("res://common/prefabs/battle/mat_es_rim.tres")
@onready var MAT_ES_SPHERE = preload("res://common/prefabs/battle/mat_es_sphere.tres")

@onready var rim : MeshInstance3D = $enemy_selector/rim
@onready var pad : MeshInstance3D = $enemy_selector/pad
@onready var sphere : MeshInstance3D = $enemy_selector/sphere

@onready var state_selecting : bool = false
@onready var state_hovering : bool = false

@onready var battle_enemies : BattleEnemies


var hovered_enemy : BattleEnemy
var hovered_enemy_index : int = -1

var rot_speed_selected : float = 0.2
var rot_speed_hovered : float = 1.0
var rotate_speed : float

var rim_scale_selected : float = 1.4
var rim_scale_hovered : float = 1.0
var rim_scale : float

signal select(enemy : BattleEnemy)


func _unhandled_input(event):
	if battle_enemies != null && state_hovering:
		if Input.is_action_just_pressed("textbox_advance"):
			if hovered_enemy != null && !state_selecting:
				select.emit(hovered_enemy)
				state_selecting = true
		elif Input.is_action_just_pressed("escape"):
			state_selecting = false
			select.emit(null)
		if !state_selecting:
			if Input.is_action_just_pressed("left"):
				hovered_enemy_index += 1
				if hovered_enemy_index > battle_enemies.enemy_array().size() - 1:
					hovered_enemy_index = 0
				hovered_enemy = battle_enemies.enemy_array()[hovered_enemy_index]
			elif Input.is_action_just_pressed("right"):
				hovered_enemy_index -= 1
				if hovered_enemy_index < 0:
					hovered_enemy_index = battle_enemies.enemy_array().size() - 1
				hovered_enemy = battle_enemies.enemy_array()[hovered_enemy_index]

func start_hovering():
	rim_scale = rim_scale_hovered
	rotate_speed = rot_speed_hovered
	MAT_ES_RIM.albedo_color = rim_hovered_color
	MAT_ES_PAD.albedo_color = pad_hovered_color
	MAT_ES_SPHERE.albedo_color = sphere_hovered_color
	state_hovering = true
	hovered_enemy_index = 0
	hovered_enemy = battle_enemies.enemy_array()[hovered_enemy_index]

func stop_hovering():
	state_hovering = false

func _process(delta):
	if hovered_enemy != null && state_hovering:
		visible = true
		var target_pos : Vector3 = Vector3(hovered_enemy.global_position.x,0.0,hovered_enemy.global_position.z)
		global_position = global_position.slerp(target_pos, 0.1)
	else:
		visible = false
		
	if state_selecting:
		rotate_speed = lerpf(rotate_speed, rot_speed_selected, 0.05)
		rim_scale = lerpf(rim_scale,rim_scale_selected,0.05)
		MAT_ES_RIM.albedo_color = MAT_ES_RIM.albedo_color.lerp(rim_selected_color, 0.1)
		MAT_ES_PAD.albedo_color = MAT_ES_PAD.albedo_color.lerp(pad_selected_color, 0.1)
		MAT_ES_SPHERE.albedo_color = MAT_ES_SPHERE.albedo_color.lerp(sphere_selected_color, 0.1)
	else:
		rotate_speed = lerpf(rotate_speed,rot_speed_hovered,0.05)
		rim_scale = lerpf(rim_scale,rim_scale_hovered,0.05)
		MAT_ES_RIM.albedo_color = MAT_ES_RIM.albedo_color.lerp(rim_hovered_color, 0.1)
		MAT_ES_PAD.albedo_color = MAT_ES_PAD.albedo_color.lerp(pad_hovered_color, 0.1)
		MAT_ES_SPHERE.albedo_color = MAT_ES_SPHERE.albedo_color.lerp(sphere_hovered_color, 0.1)
	
	rim.rotate_y(delta * rotate_speed)
	rim.scale = Vector3(rim_scale,rim_scale,rim_scale)
