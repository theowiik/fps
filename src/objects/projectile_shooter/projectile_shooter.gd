extends Spatial

const PROJECTILE = preload('res://src/objects/projectile/Projectile.tscn')
onready var projectile_output_point = $ProjectileShooterMesh/ProjectileOutputPoint

var damage = 1
var mag_size = 30

func _ready():
	pass

func reload():
	pass

func _unhandled_input(event):
	if event.is_action_pressed('shoot'):
		shoot()

func shoot():
	var b = PROJECTILE.instance()
	b.start(Vector3(1, 1, 1))
	pass