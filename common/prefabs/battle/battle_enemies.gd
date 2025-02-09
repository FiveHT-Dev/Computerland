class_name BattleEnemies
extends Node3D

@onready var enemy_prefabs : Dictionary = {
	"bt_enemy_debug" : preload("res://common/prefabs/battle/enemies/bt_enemy_debug.tscn")
}

@onready var enemies : Dictionary = {}
@onready var enemy_slots : Array[Node3D]


func init_enemies(encounter_location : World.Location, encounter_readiness : int):
	for c in get_children():
		if str(c.name).begins_with("enemy_slot"):
			enemy_slots.append(c)
	
	var num_enemies : int = randi_range(1, enemy_slots.size())
	
	for i in num_enemies:
		var enemy : BattleEnemy = add_enemy("bt_enemy_debug")
		if enemy != null:
			enemy_slots[i].add_child(enemy)

func enemy_array() -> Array:
	return enemies.values()

func add_enemy(enemy_prefab_name : String) -> BattleEnemy:
	if enemy_prefabs.has(enemy_prefab_name):
		var enemy : BattleEnemy = enemy_prefabs[enemy_prefab_name].instantiate()
		enemies[enemy.get_instance_id()] = enemy
		return enemy
	return null

func remove_enemy(instance_id : int):
	if enemies.has(instance_id):
		var enemy : BattleEnemy = enemies[instance_id]
		enemies.erase(instance_id)
		enemy.queue_free()
