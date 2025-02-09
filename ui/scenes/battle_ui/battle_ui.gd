class_name BattleUI
extends Control

@onready var mouse_filter_ignore_nodes : Array[Control] = [
	$minigames,
	$player_stats,
	$enemy_stats
]

var selected_enemy : BattleEnemy
@onready var enemy_stats_panel : Panel = $enemy_stats/enemy_stats_panel
@onready var enemy_name : RichTextLabel = $enemy_stats/enemy_stats_panel/enemy_name
@onready var enemy_health_tpb : TextureProgressBar = $enemy_stats/enemy_stats_panel/health_tpb
@onready var enemy_mana_tpb : TextureProgressBar = $enemy_stats/enemy_stats_panel/mana_tpb
@onready var enemy_defense_tpb : TextureProgressBar = $enemy_stats/enemy_stats_panel/defense_tpb


# Called when the node enters the scene tree for the first time.
func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for c : Control in mouse_filter_ignore_nodes:
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_enemy != null:
		if !enemy_stats_panel.visible:
			enemy_stats_panel.visible = true
			enemy_name.clear()
			enemy_name.add_text(selected_enemy.enemy_name)
			enemy_health_tpb.max_value = selected_enemy.stats.hp_max
			enemy_health_tpb.value = selected_enemy.stats.hp_curr
			enemy_mana_tpb.max_value = selected_enemy.stats.mn_max
			enemy_mana_tpb.value = selected_enemy.stats.mn_curr
			enemy_defense_tpb.max_value = selected_enemy.stats.df_max
			enemy_defense_tpb.value = selected_enemy.stats.df_curr
	else:
		enemy_stats_panel.visible = false
