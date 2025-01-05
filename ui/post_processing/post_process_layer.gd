class_name PostProcessLayer
extends CanvasLayer

@onready var texture_rect : ColorRect = $TextureRect

@export var below_ui : bool = true
@export var always_show : bool = false
@export var self_path : String



func _ready():
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
