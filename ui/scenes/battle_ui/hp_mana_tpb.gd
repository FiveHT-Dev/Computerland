extends TextureProgressBar

@export_category("Slice noise")
@export var slice_noise_over_time : bool = false
@export var change_noise_slice_time : float = 0.2
@export_category("Progress tint")
@export var tint_progress_based_on_value : bool = false
@export var tint_start : Color
@export var tint_end : Color
@onready var t : float
@onready var noise_offset_z : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if slice_noise_over_time:
		if t > 0.0:
			t -= delta
		else:
			t = change_noise_slice_time
			noise_offset_z += 0.5
		var target_offset : Vector3 = Vector3(0.0,0.0,noise_offset_z)
		texture_progress.noise.offset = texture_progress.noise.offset.lerp(target_offset, 0.1)
	if tint_progress_based_on_value:
		tint_progress = tint_start.lerp(tint_end, value / max_value)
		
