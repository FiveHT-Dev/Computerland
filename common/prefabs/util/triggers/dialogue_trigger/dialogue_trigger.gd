extends Trigger

@export var textbox_to_open_index : int
@onready var dialogue_agent : DialogueAgent = $dialogue_agent
@onready var cam_focus_point : Node3D = $cam_focus_point

func _on_player_entered():
	open_dialogue()

func _on_player_interacted():
	open_dialogue()

func open_dialogue():
	if dialogue_agent.graph_start_node != null:
		dialogue_agent.talked_to()
		Manager.game.in_game_ui.open_textbox(dialogue_agent.graph_start_node, textbox_to_open_index)
		if dialogue_agent.focus_camera:
			Manager.game.cam.add_override_focus(cam_focus_point)
