extends MeshInstance

const PROJECTILE = preload('res://src/objects/projectile/Projectile.tscn')
onready var projectile_output_point = $ProjectileOutputPoint
onready var timer = $Timer
onready var animation_player = $AnimationPlayer

var damage = 1
var mag_size = 30
var can_shoot = true
var total_ammo = 99999
var current_ammo = 0
var sec_between_shots = 0.2

func _init():
	current_ammo = mag_size

func shoot():
	if !can_shoot or current_ammo <= 0:
		return
	current_ammo -= 1
	can_shoot = false
	timer.start(sec_between_shots)
	_shoot()

func _shoot():
	append_projectile()

func append_projectile(start_pos = null, direction = null):
	if start_pos == null:
		start_pos = projectile_output_point.global_transform

	var b = PROJECTILE.instance()
	b.start(start_pos, direction)
	get_parent().get_parent().get_parent().get_parent().add_child(b)

func _on_Timer_timeout():
	can_shoot = true

# Will also remove the ammo that is currently in the "mag".
# As if you "throw it away".
func reload():
	var n_removed = 0
	n_removed = total_ammo if total_ammo < mag_size else mag_size
	current_ammo = n_removed
	total_ammo -= n_removed

func run_walking_animation(on):
	if on:
		animation_player.play('walking')
	else:
		animation_player.stop()

func _on_Area_body_entered(body):
	print(body)
	if body.has_method('take_weapon'):
		body.take_weapon(self)