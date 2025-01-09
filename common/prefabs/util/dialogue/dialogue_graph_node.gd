class_name DialogueGraphNode
extends Node

@export_category("Text")
@export var file_path : String
@export var region_delimiter : String
@export_category("Printing")
@export var print_speed : float = 0.1
@export var print_sfx : AudioStreamRandomizer = preload("res://audio/ui/streams/textbox_print_default_sfx.tres")

@onready var advance_connections : Array
@onready var options : Array
@onready var text_lines : PackedStringArray

func _ready():
	for c in get_children():
		if c is DialogueAdvanceConnection:
			advance_connections.append(c)
		elif c is DialogueOption:
			options.append(c)
	read_file()
	

func read_file():
	if FileAccess.file_exists(file_path):
		var file : FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var encountered_delimiter : bool = false
		while true:
			var line : String = file.get_line()
			if line == "":
				break
			
			if line == region_delimiter:
				if encountered_delimiter:
					break
				encountered_delimiter = true
			else:
				if encountered_delimiter:
					text_lines.append(line)
			
	else:
		text_lines = ["The dialogue file does not exist.", "Or the path is mistyped."]

func get_next() -> DialogueGraphNode:
	if advance_connections.is_empty():
		return null
	for connection : DialogueAdvanceConnection in advance_connections:
		if connection.evaluate():
			return connection.next_node
	return null
