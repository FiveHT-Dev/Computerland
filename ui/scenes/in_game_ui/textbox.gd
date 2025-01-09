class_name Textbox
extends Control
@onready var text_buffer : RichTextLabel = $text_buffer
@onready var char_print_timer : Timer = $char_print_timer
@onready var option_buttons : Array = [
	$option_0,
	$option_1,
	$option_2,
	$option_3
]
@onready var text_print_player : AudioStreamPlayer = $text_print_player
@onready var open_player : AudioStreamPlayer = $open_player
@onready var close_player : AudioStreamPlayer = $close_player
@onready var open_timer : Timer = $open_timer
@onready var start_pos = position


var current_dialogue_graph_node : DialogueGraphNode
var char_index : int = 0
var line_index : int = 0
var waiting_for_input : bool = false
var displaying_options : bool = false
var option_nodes : Array = []

func open(dialogue_graph_start_node : DialogueGraphNode):
	if current_dialogue_graph_node == null:
		current_dialogue_graph_node = dialogue_graph_start_node
		reset()
		visible = true
		open_player.play()
		open_timer.start()
	

func _unhandled_input(event):
	if displaying_options:
		pass
	else:
		if waiting_for_input:
			if Input.is_action_just_pressed("textbox_advance"):
				line_index += 1
				if line_index >= current_dialogue_graph_node.text_lines.size():
					if current_dialogue_graph_node.options.is_empty():
						current_dialogue_graph_node = current_dialogue_graph_node.get_next()
						if current_dialogue_graph_node == null:
							close()
						else:
							start_printing_graph_node()
					else:
						display_options()
				else:
					print_next_line()
		else:
			if Input.is_action_just_pressed("textbox_advance"):
				display_whole_line()

func _process(delta):
	if visible:
		self_modulate.a = lerpf(self_modulate.a, 1.0, 0.1)
		position = position.lerp(start_pos, 0.1)
	else:
		self_modulate.a = 0.0
		position = Vector2(start_pos.x * 1.5, start_pos.y)

func display_whole_line():
	if current_dialogue_graph_node != null:
		char_index = current_dialogue_graph_node.text_lines[line_index].length() - 1
		text_buffer.clear()
		text_buffer.add_text(current_dialogue_graph_node.text_lines[line_index])
		waiting_for_input = true

func start_printing_graph_node():
	reset()
	text_print_player.stream = current_dialogue_graph_node.print_sfx
	char_print_timer.wait_time = current_dialogue_graph_node.print_speed
	char_print_timer.start()

func clear_options():
	option_nodes.clear()
	for button : Button in option_buttons:
		button.visible = false
		button.text = ""

func display_options():
	text_buffer.clear()
	clear_options()
	var i : int = 0
	for option : DialogueOption in current_dialogue_graph_node.options:
		var option_button : Button = option_buttons[i]
		option_button.visible = true
		option_button.text = option.option_name
		option_nodes.append(option)
		i += 1
		if i > 3:
			break

func call_option(index : int):
	var option_node : DialogueOption = option_nodes[index]
	if option_node.option_action == option_node.OptionAction.NEXT_NODE:
		current_dialogue_graph_node = option_node.next_node
		start_printing_graph_node()
	elif option_node.option_action == option_node.OptionAction.CALL_FUNCTION:
		if option_node.function_owner != null && option_node.function_owner.has_method(option_node.function_name):
			option_node.function_owner.call(option_node.function_name, option_node.function_params)
	elif option_node.option_action == option_node.OptionAction.NEXT_NODE_CALL_FUNCTION:
		if option_node.function_owner != null && option_node.function_owner.has_method(option_node.function_name):
			option_node.function_owner.call(option_node.function_name, option_node.function_params)
		current_dialogue_graph_node = option_node.next_node
		start_printing_graph_node()
	else:
		close()

func close():
	reset()
	close_player.play()
	current_dialogue_graph_node = null
	visible = false
	Manager.game.cam.remove_override_focus()

func reset():
	clear_options()
	text_buffer.clear()
	char_index = 0
	line_index = 0
	waiting_for_input = false
	displaying_options = false

func print_next_line():
	char_index = 0
	waiting_for_input = false
	text_buffer.clear()
	char_print_timer.start()

func _on_char_print_timer_timeout():
	if !waiting_for_input:
		text_print_player.play()
		var line : String = current_dialogue_graph_node.text_lines[line_index]
		var character : String = line[char_index]
		text_buffer.add_text(character)
		if character in [".", ",", "?", "!"]:
			char_print_timer.wait_time = current_dialogue_graph_node.print_speed * 1.5
		elif character == " ":
			char_print_timer.wait_time = current_dialogue_graph_node.print_speed * 1.25
		else:
			char_print_timer.wait_time = current_dialogue_graph_node.print_speed
		char_index += 1
		if char_index >= line.length():
			waiting_for_input = true
			return
		char_print_timer.start()


func _on_option_0_button_up():
	call_option(0)


func _on_option_1_button_up():
	call_option(1)


func _on_option_2_button_up():
	call_option(2)


func _on_option_3_button_up():
	call_option(3)


func _on_open_timer_timeout():
	start_printing_graph_node()
