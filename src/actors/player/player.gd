extends KinematicBody

onready var camera = $Pivot/Camera

var velocity = Vector3()
var gravity = 6
var jump_speed = 4
var max_walking_speed = 7
var max_sprinting_speed = 4
var mouse_sensitivy = 0.006

func _physics_process(delta):
	move(delta)
	print(velocity.length())

func move(delta):
	update_velocity(delta)
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivy)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivy)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func update_velocity(delta):
	var desired_velocity = get_input_vec() * max_walking_speed
	velocity.x = desired_velocity.x
	velocity.y -= gravity * delta
	velocity.z = desired_velocity.z

func get_input_vec():
	var input_vec = Vector3()

	var camera_z_basis = camera.global_transform.basis.z
	var camera_x_basis = camera.global_transform.basis.x

	if Input.is_action_pressed('move_forward'):
		input_vec -= camera_z_basis
	if Input.is_action_pressed('move_back'):
		input_vec += camera_z_basis
	if Input.is_action_pressed('strafe_left'):
		input_vec -= camera_x_basis
	if Input.is_action_pressed('strafe_right'):
		input_vec += camera_x_basis

	return input_vec.normalized()