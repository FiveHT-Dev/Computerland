class_name IGUMButton
extends Button
@export var play_pressed_sound : bool
@onready var hover_player : AudioStreamPlayer = AudioStreamPlayer.new()
@onready var pressed_player : AudioStreamPlayer = AudioStreamPlayer.new()
var previous_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	focus_entered.connect(_on_hover)
	keep_pressed_outside = true
	add_child(hover_player)
	add_child(pressed_player)
	hover_player.stream = preload("res://audio/ui/sfx/igum_button_hover.ogg")
	hover_player.bus = AudioServer.get_bus_name(1)
	pressed_player.stream = preload("res://audio/ui/sfx/igum_button_pressed.ogg")
	pressed_player.bus = AudioServer.get_bus_name(1)

func _on_hover():
	hover_player.play()

func _on_button_down():
	previous_pos = position
	position += Vector2(2.0, 2.0)

func _on_button_up():
	position = previous_pos
	if play_pressed_sound:
		pressed_player.play()
