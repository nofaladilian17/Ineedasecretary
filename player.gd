



extends CharacterBody3D


@onready var sprite_base: Node3D = $SpriteBase
@onready var sprite: AnimatedSprite3D = $SpriteBase / PlayerSprite
@onready var front: Marker3D = $SpriteBase / PlayerSprite / Front


@onready var camera_base: Node3D = $CameraBase
@onready var spring_arm: SpringArm3D = $CameraBase / SpringArm
@onready var camera: Camera3D = $CameraBase / SpringArm / Camera



@export var current_state: StringName

@export var sens: float = 0.1


func _ready() -> void :

	current_state = &"Idle"

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void :

	if event is InputEventMouseMotion:
		camera_base.rotate_y(deg_to_rad( - event.relative.x * sens))
		spring_arm.rotate_x(deg_to_rad( - event.relative.y * sens))
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-60), deg_to_rad(45))

func _physics_process(delta: float) -> void :




	sprite_rotation()

func sprite_rotation():
	var current_camera = get_viewport().get_camera_3d()
	var current_frame = sprite.get_frame()
	var current_progress = sprite.get_frame_progress()

	var c_fwd = - current_camera.global_transform.basis.z
	c_fwd.y = 0
	c_fwd = c_fwd.normalized()

	var fwd = - front.global_transform.basis.z
	var left = sprite.global_transform.basis.x

	var l_dot = left.dot(c_fwd)
	var f_dot = fwd.dot(c_fwd)

	sprite.flip_h = false




	if f_dot < -0.5:
		sprite.play(current_state + &"B")


	elif f_dot > 0.5:
		sprite.play(current_state + &"F")

	else:
		sprite.flip_h = l_dot > 0


		if abs(f_dot) < 0.15:
			sprite.play(current_state + &"L")


		elif f_dot < 0:
			sprite.play(current_state + &"BL")


		else:
			sprite.play(current_state + &"FL")


	sprite.set_frame_and_progress(current_frame, current_progress)
