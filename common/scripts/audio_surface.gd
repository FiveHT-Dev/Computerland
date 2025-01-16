class_name AudioSurface
extends StaticBody3D

enum SurfaceType{
	GRASS,
	TILE,
	DIRT,
	WOOD,
	NONE
}

@export var surface_type : SurfaceType


func _ready():
	print("aaa")
