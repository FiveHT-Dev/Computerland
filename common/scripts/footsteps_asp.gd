class_name FootStepsASP
extends AudioStreamPlayer3D
@export var ray : RayCast3D
## Index 0: GRASS | Index 1 : TILE | Index 2: Dirt | Index 3: Wood
@export var fsa : FootstepsAudio = preload("res://common/resources/footsteps_audio/res_fsa_default.tres")
@export var char_anim : CharacterAnimPlayer
var last_surface : AudioSurface

func _ready():
	if char_anim != null:
		char_anim.play_footstep_sound.connect(on_footstep)
	stream = fsa.default_stream


func on_footstep():
	stop()
	var col = ray.get_collider()
	if col is GridMap:
		stream = get_stream_from_gridmap(col)
	play()

func get_stream_from_gridmap(map : GridMap) -> AudioStreamRandomizer:
	var pos = ray.global_position
	var meshes_data : Array = map.get_meshes()
	for i in meshes_data.size() / 2:
		if meshes_data[i * 2] is Transform3D:
			var t3d : Transform3D = meshes_data[i * 2]
			var grid_pos : Vector3i = Vector3i(map.local_to_map(pos))
			var tile_pos : Vector3i = Vector3i(map.local_to_map(t3d.origin))
			grid_pos.y = -2
			if tile_pos == grid_pos:
				var tile_mesh : ArrayMesh = meshes_data[(i * 2) + 1]
				var mat : Material = tile_mesh.surface_get_material(0)
				var next_pass : Material = mat.next_pass
				if next_pass != null:
					var slices : PackedStringArray = next_pass.resource_path.split("/")
					var mat_name : String = slices[slices.size() - 1].get_slice(".", 0)
					return get_surface_stream(mat_name)
	return fsa.default_stream

func get_surface_stream(mat_name : String) -> AudioStreamRandomizer:
	var index : int = -1
	match mat_name:
		"GRASS":
			index = 0
		"TILE":
			index = 1
		"DIRT":
			index = 2
		"WOOD":
			index = 3
	if index == -1:
		return fsa.default_stream
	elif index < fsa.streams.size():
		return fsa.streams[index]
	else:
		return fsa.default_stream
