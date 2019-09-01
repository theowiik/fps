extends 'res://src/objects/projectile_shooter/projectile_shooter.gd'

var bullets_per_shot = 5
var bullet_spread = 0.5
var rand = RandomNumberGenerator.new()

func _init():
	damage = 10
	mag_size = 8
	total_ammo = 32
	sec_between_shots = 0.9

func _shoot():
	var start_pos = projectile_output_point.global_transform
	var direction = start_pos.basis.y
	var forward = direction

	for i in bullets_per_shot:
		var rotation = rand.randi_range(0, 360)
		var transformed_vec = Vector3(direction.x, direction.y + bullet_spread, direction.z)
		transformed_vec = transformed_vec.rotated(forward.normalized(), rotation)
		append_projectile(null, transformed_vec)