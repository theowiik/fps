extends KinematicBody

onready var camera = $Pivot/Camera
onready var holding = $Pivot/ProjectileShooterHolder/ProjectileShooter

var coins = 0
var health = 100
var gravity = 30
var velocity = Vector3()
var jump_speed = 12
var mouse_sensitivy = 0.006
var max_walking_speed = 6
var max_sprinting_speed = 9
var projectile_shooters = []

func _physics_process(delta):
	move(delta)
	holding.run_walking_animation(is_moving())

func _process(delta):
	display_stats()
	if Input.is_action_pressed('shoot'):
		holding.shoot()

func move(delta):
	update_velocity(delta)
	if Input.is_action_pressed('jump') and is_on_floor():
		velocity.y += jump_speed
	if Input.is_action_pressed('crouch'):
		print('crouch')
	velocity = move_and_slide(velocity, Vector3.UP, true)

func get_max_speed():
	if Input.is_action_pressed('sprint'):
		return max_sprinting_speed
	else:
		return max_walking_speed

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivy)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivy)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	if event.is_action_pressed('reload'):
		holding.reload()

func update_velocity(delta):
	var desired_velocity = get_input_vec() * get_max_speed()
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

func take_damage(amount = 1):
	health -= abs(amount)

func is_moving():
	return velocity.length() != 0

func take_coins(amount):
	coins += amount

func display_stats():
	var label = $RichTextLabel
	label.set_text('Health: ' + str(health))
	label.newline()
	label.add_text('Ammo: ' + str(holding.current_ammo) + '/' + str(holding.mag_size))
	label.add_text(' (tot: ' + str(holding.total_ammo) + ')')
	label.newline()
	label.add_text('Coins: ' + str(coins))