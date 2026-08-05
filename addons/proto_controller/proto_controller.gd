




extends CharacterBody3D


@export var can_move: bool = true

@export var has_gravity: bool = true

@export var can_jump: bool = false

@export var can_sprint: bool = false

@export var can_freefly: bool = false

@export_group("Speeds")

@export var look_speed: float = 0.005

@export var base_speed: float = 7.0

@export var jump_velocity: float = 4.5

@export var sprint_speed: float = 10.0

@export var freefly_speed: float = 25.0

@export_group("Input Actions")

@export var input_left: String = "a"

@export var input_right: String = "d"

@export var input_forward: String = "w"

@export var input_back: String = "s"

@export var input_jump: String = "ui_accept"

@export var input_sprint: String = "sprint"



var mouse_captured: bool = false
var look_rotation: Vector2
var move_speed: float = 0.0
var freeflying: bool = false


@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider
@onready var steps: AudioStreamPlayer3D = $Steps
@onready var camera_3d: Camera3D = $Head / SpringArm3D / Camera3D


var target_look_rotation: = Vector2.ZERO
var current_look_rotation: = Vector2.ZERO
@export var look_smooth: = 20.0
@onready var player_model: Node3D = $player_model
@onready var animation_player: AnimationPlayer = $player_model / AnimationPlayer
var is_talking = false
@onready var side_menu: Node3D = $SideMenu


@onready var joystick_camera: VirtualJoystick = $"MobileLayer/Virtual JoyCamera"
@export var mobile_look_speed: float = 3.0


func _ready() -> void :
	hide_head()

	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	capture_mouse()
	Global.player_node = self



func _unhandled_input(event: InputEvent) -> void :
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		if not Global.is_on_2d:
			capture_mouse()

	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()


	if mouse_captured and can_move and event is InputEventMouseMotion:
		rotate_look(event.relative)









func _physics_process(delta: float) -> void :
	current_look_rotation = current_look_rotation.lerp(target_look_rotation, look_smooth * delta)

	transform.basis = Basis()
	rotate_y(current_look_rotation.y)

	head.transform.basis = Basis()
	head.rotate_x(current_look_rotation.x)

	if joystick_camera:

		var joy_input = joystick_camera.output

		if joy_input.length() > 0.05:

			target_look_rotation.y -= joy_input.x * mobile_look_speed * delta
			target_look_rotation.x -= joy_input.y * mobile_look_speed * delta

			target_look_rotation.x = clamp(
				target_look_rotation.x, 
				deg_to_rad(-85), 
				deg_to_rad(85)
			)

	if can_freefly and freeflying:
		var input_dir: = Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion: = (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		is_moving = input_dir.length() > 0.1
		move_and_collide(motion)
		return


	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta


	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity


	if can_sprint and Input.is_action_pressed(input_sprint):
		move_speed = sprint_speed
	else:
		move_speed = base_speed


	if can_move:
		var input_dir: = Input.get_vector(input_left, input_right, input_forward, input_back)


		is_moving = input_dir.length() > 0.1


		if is_moving:
			update_direction(input_dir)

		var move_dir: = (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if is_moving:
			steps_sound(true)
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			steps_sound(false)
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)


	else:
		$Steps.stop()
		is_moving = false
		velocity.x = 0
		velocity.y = 0
		velocity.z = 0


	move_and_slide()
	update_animation()





func rotate_look(rot_input: Vector2):
	target_look_rotation.x -= rot_input.y * look_speed
	target_look_rotation.x = clamp(target_look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	target_look_rotation.y -= rot_input.x * look_speed


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false




func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false




func steps_sound(value):
	pass









var is_moving: = false
var last_direction: = "back"


















func update_direction(input_dir: Vector2):
	if abs(input_dir.y) > abs(input_dir.x):
		if input_dir.y < 0:
			last_direction = "back"
		else:
			last_direction = "front"
	else:
		if input_dir.x < 0:
			last_direction = "left"
		else:
			last_direction = "right"

func update_animation():
	if is_moving:

		animation_player.play("WALK")
	else:

		if !is_talking:
			animation_player.play("IDLE")
	check_model_position(last_direction)






func check_model_position(direction):
	if direction == "front":
		player_model.rotation.y = 0
	elif direction == "back":
		player_model.rotation.y = 179
	elif direction == "right":
		player_model.rotation.y = 89
	elif direction == "left":
		player_model.rotation.y = -89


func play_step_sound():
	Global.play_sound(self, load(Global.get_random_music_path(Global.steps_sounds)), 0.3)

func hide_head():

	var skeleton = $player_model / Armature / Skeleton3D

	for i in skeleton.get_bone_count():
		var name = skeleton.get_bone_name(i)

		if "head" in name.to_lower():
			skeleton.set_bone_pose_scale(i, Vector3.ZERO)
