class_name DialogueOption
extends Node

enum OptionAction{
	NEXT_NODE,
	CALL_FUNCTION,
	NEXT_NODE_CALL_FUNCTION,
	NONE
}

@export var option_name : String
@export var option_action : OptionAction
@export_category("Call function")
@export var function_name : String
@export var function_owner : Node
@export var function_params : Array
@export_category("Next node")
@export var next_node : DialogueGraphNode
