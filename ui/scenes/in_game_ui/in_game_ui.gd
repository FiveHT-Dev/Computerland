class_name InGameUI
extends Control

@onready var player_stopping_ui_elements : Array = [
	$main_textbox
]

@onready var textboxes : Array = [
	$main_textbox
]

@onready var interact_panel : Control = $interact_panel
@onready var interact_panel_label : Control = $interact_panel/Label
@onready var post_process_below_ui : Control = $post_process_below_ui
@onready var post_process_above_ui : Control = $post_process_above_ui


var player : Player
var post_process_layers : Dictionary = {}
var can_player_move : bool

func _ready():
	interact_panel.self_modulate.a = 0.0
	interact_panel_label.self_modulate.a = 0.0
	interact_panel.scale = Vector2(0.01, 0.01)

func _process(delta):
	if player == null:
		player = Manager.game.player
	else:
		show_interact(player.current_triggers.is_empty())
	can_player_move = check_if_player_can_move()

func add_post_process_layer(path : String, below_ui : bool):
	if post_process_layers.has(path):
		return
	var post_process_control : Control
	if below_ui:
		post_process_control = post_process_below_ui
	else:
		post_process_control = post_process_above_ui
	post_process_control.add_child(load(path).instantiate())

func reload_post_process_layers(list : PostProcessList):
	var paths_list : Array = Array(list.paths)
	for path in post_process_layers.keys():
		if !paths_list.has(path) && !post_process_layers[path].always_show:
			post_process_layers[path].queue_free()
			post_process_layers.erase(path)
		else:
			paths_list.erase(path)
	for path in paths_list:
		var layer : PostProcessLayer = load(path).instantiate()
		if layer.below_ui:
			post_process_below_ui.add_child(layer)
		else:
			post_process_above_ui.add_child(layer)

func open_textbox(dialogue_graph_start_node : DialogueGraphNode, textbox_to_open_index : int):
	textboxes[textbox_to_open_index].open(dialogue_graph_start_node)

func show_interact(val : bool):
	if val:
		interact_panel.self_modulate.a = lerpf(interact_panel.self_modulate.a, 0.0, 0.1)
		interact_panel_label.self_modulate.a = lerpf(interact_panel.self_modulate.a, 0.0, 0.1)
		interact_panel.scale = interact_panel.scale.lerp(Vector2(0.01, 0.01), 0.1)
	else:
		interact_panel.self_modulate.a = lerpf(interact_panel.self_modulate.a, 1.0, 0.1)
		interact_panel_label.self_modulate.a = lerpf(interact_panel.self_modulate.a, 1.0, 0.1)
		interact_panel.scale = interact_panel.scale.lerp(Vector2(1.0, 1.0), 0.1)

func check_if_player_can_move() -> bool:
	for i in player_stopping_ui_elements:
		if i.visible:
			return false
	return true
