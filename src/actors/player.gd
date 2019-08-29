extends KinematicBody

onready var camera = $Pivot/Camera

var velocity = Vector3()
var gravity = 6
var jump_speed = 4
var max_walking_speed = 80
var max_sprinting_speed = 4

func _process(delta):
	update_velocity(delta)
	move_and_slide(velocity, Vector3.UP)

func update_velocity(delta):
	var desired_velocity = get_input_vec() * max_walking_speed
	velocity.x = desired_velocity.x
	velocity.y -= gravity * delta
	velocity.z = desired_velocity.z

func get_input_vec():
	var input_vec = Vector3(0, velocity.y, 0)

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