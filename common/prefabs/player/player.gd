class_name Player
extends CharacterBody3D




@onready var cam_follow_transforms : Array = [
	$cam_follow_transform_0,
	$cam_follow_transform_1,
	$cam_follow_transform_2
]
@onready var character : Node3D = $char_pivot/player_char
@onready var current_cam_follow_transform : Node3D = $cam_follow_transform_0

var current_triggers : Dictionary = {}

var char_angle : float = 0.0
var input_dir : Vector2
var moving : bool
var speed : float
var walk_speed : float = 5.0
var run_speed : float = 9.0
var running : bool
var cft_index : int = 0
var cft_increment = 1


func _process(delta):
	if !Manager.game.in_game_ui.can_player_move:
		speed = 0
		running = false
		moving = false
	else:
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		moving = velocity.length() > 0.1
		if Input.is_action_pressed("run"):
			running = true
			speed = run_speed
		else:
			running = false
			speed = walk_speed
	
	if Input.is_action_just_pressed("change_cam_view"):
		cft_index += cft_increment
		if cft_index > cam_follow_transforms.size() - 1:
			cft_increment = -1
			cft_index = cam_follow_transforms.size() - 2
		elif cft_index < 0:
			cft_index = 1
			cft_increment = 1
		current_cam_follow_transform = cam_follow_transforms[cft_index]

func add_trigger(t : Trigger):
	var id = t.get_instance_id()
	if !current_triggers.has(id):
		current_triggers[id] = t

func remove_trigger(t : Trigger):
	var id = t.get_instance_id()
	if current_triggers.has(id):
		current_triggers.erase(id)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character.basis = character.basis.slerp(Basis(Quaternion.from_euler(Vector3(0.0, char_angle, 0.0))), 0.2)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		char_angle = Vector2(direction.x, -direction.z).angle()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
