extends KinematicBody

# Nodes
onready var camera = $Pivot/Camera
onready var projectile_shooteer_holder = $Pivot/ProjectileShooterHolder

# Stats
var coins = 0
var health = 100
var gravity = 30

# Movement
var velocity = Vector3()
var jump_speed = 12
var mouse_sensitivy = 0.006
var max_walking_speed = 6
var max_sprinting_speed = 9

# Inventory
var projectile_shooters = []
var inventory_size = 5
var selected_inventory_slot = 0

func _init():
	for i in inventory_size:
		projectile_shooters.push_front(null)

func _ready():
	var ps = preload('res://src/objects/projectile_shooter/ProjectileShooter.tscn').instance()
	projectile_shooters[0] = ps
	equip_projectile_shooter(selected_inventory_slot)

func _physics_process(delta):
	move(delta)
	if get_holding() != null:
		get_holding().run_walking_animation(is_moving())

func _process(delta):
	display_stats()
	if Input.is_action_pressed('shoot'):
		if get_holding() != null:
			get_holding().shoot()

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
		if get_holding() != null:
			get_holding().reload()
	if event.is_action_pressed('inv_next'):
		next_inv_slot()
	if event.is_action_pressed('inv_back'):
		back_inv_slot()

func next_inv_slot():
	selected_inventory_slot += 1
	if selected_inventory_slot >= inventory_size:
		selected_inventory_slot = 0
	equip_projectile_shooter(selected_inventory_slot)

func back_inv_slot():
	selected_inventory_slot -= 1
	if selected_inventory_slot < 0:
		selected_inventory_slot = (inventory_size - 1)
	equip_projectile_shooter(selected_inventory_slot)

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

func equip_projectile_shooter(i):
	if projectile_shooters[i] == null:
		print(projectile_shooteer_holder.get_children().size())
		for child in projectile_shooteer_holder.get_children():
			projectile_shooteer_holder.remove_child(child)
	else:
		var x = projectile_shooters[i]
		projectile_shooteer_holder.add_child(x)

func take_damage(amount = 1):
	health -= abs(amount)

func is_moving():
	return velocity.length() != 0

func get_holding():
	return projectile_shooters[selected_inventory_slot]

func take_coins(amount):
	coins += amount

func display_stats():
	var label = $RichTextLabel
	label.set_text('Health: ' + str(health))
	label.newline()
	if get_holding() != null:
		label.add_text('Ammo: ' + str(get_holding().current_ammo) + '/' + str(get_holding().mag_size))
		label.add_text(' (tot: ' + str(get_holding().total_ammo) + ')')
		label.newline()
	label.add_text('Coins: ' + str(coins))
	label.newline()
	label.add_text('Inv size: ' + str(inventory_size))
	label.newline()
	label.add_text('Current inv id: ' + str(selected_inventory_slot))
	label.newline()
	label.add_text('get_current(): ' + str(get_holding()))