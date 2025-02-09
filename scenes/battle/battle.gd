class_name Battle
extends Node3D

@onready var battle_ui : BattleUI = $battle_ui
@onready var enemies : BattleEnemies = $enemies
@onready var enemy_selector : EnemySelector = $enemy_selector
@onready var battle_camera : BattleCamera = $battle_camera

@onready var selected_enemy : BattleEnemy = null


func _ready():
	enemies.init_enemies(World.Location.SCHOOL, 1)
	enemy_selector.battle_enemies = enemies
	enemy_selector.start_hovering()

func _process(delta):
	pass


func _on_enemy_selector_select(enemy):
	selected_enemy = enemy
	battle_ui.selected_enemy = enemy
