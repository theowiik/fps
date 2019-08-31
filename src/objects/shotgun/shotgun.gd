extends 'res://src/objects/projectile_shooter/projectile_shooter.gd'

func _init():
	damage = 10
	mag_size = 8
	total_ammo = 32
	sec_between_shots = 0.9

func _shoot():
	var start_pos = projectile_output_point.global_transform
	var direction = start_pos.basis.y
	append_projectile(null, direction)