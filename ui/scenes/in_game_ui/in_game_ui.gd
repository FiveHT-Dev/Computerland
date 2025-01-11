class_name InGameUI
extends Control

@onready var player_stopping_ui_elements : Array = [
	$main_textbox,
	$main_menu,
	$exit_game_are_you_sure
]

@onready var textboxes : Array = [
	$main_textbox
]

@onready var interact_panel : Control = $interact_panel
@onready var interact_panel_label : Control = $interact_panel/Label
@onready var post_process_below_ui : Control = $post_process_below_ui
@onready var post_process_above_ui : Control = $post_process_above_ui
@onready var open_timer = $main_textbox/open_timer
@onready var transition_circle : ColorRect = $transition_circle
@onready var transition_circle_smat : ShaderMaterial = preload("res://ui/graphics/transition_circle/transition_circle_smat.tres")
@onready var main_menu = $main_menu
@onready var mm_button = $main_menu/VBoxContainer/Button


var player : Player
var post_process_layers : Dictionary = {}
var can_player_move : bool

func _ready():
	interact_panel.self_modulate.a = 0.0
	interact_panel_label.self_modulate.a = 0.0
	interact_panel.scale = Vector2(0.01, 0.01)
	transition_circle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	can_player_move = check_if_player_can_move()
	if player == null:
		player = Manager.game.player
	else:
		show_interact(!player.current_triggers.is_empty() && can_player_move)
	if Input.is_action_just_pressed("escape"):
		main_menu.visible = !main_menu.visible
		if main_menu.visible:
			mm_button.grab_focus()
		else:
			$main_menu/close.play()

func add_post_process_layer(path : String, below_ui : bool):
	if post_process_layers.has(path):
		return
	var post_process_control : Control
	if below_ui:
		post_process_control = post_process_below_ui
	else:
		post_process_control = post_process_above_ui
	post_process_control.add_child(load(path).instantiate())

func t_circ_close() -> bool:
	var r : float = transition_circle_smat.get_shader_parameter("circle_r")
	if r > 0.002:
		transition_circle_smat.set_shader_parameter("circle_r", lerpf(r, 0.001, 0.1))
		return false
	return true

func t_circ_open() -> bool:
	var r : float = transition_circle_smat.get_shader_parameter("circle_r")
	if r < 2.0:
		transition_circle_smat.set_shader_parameter("circle_r", lerpf(r, 2.1, 0.1))
		return false
	return true

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
	if !val:
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




func _on_mm_exit_game_button_up():
	$exit_game_are_you_sure.visible = true
	$main_menu.visible = false
	$exit_game_are_you_sure/VBoxContainer/egays_no.grab_focus()


func _on_egays_yes_button_up():
	get_tree().quit()


func _on_egays_no_button_up():
	$exit_game_are_you_sure.visible = false
	$main_menu/close.play()
