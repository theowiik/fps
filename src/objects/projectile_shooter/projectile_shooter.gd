extends MeshInstance

const PROJECTILE = preload('res://src/objects/projectile/Projectile.tscn')
onready var projectile_output_point = $ProjectileOutputPoint
onready var timer = $Timer
onready var animation_player = $AnimationPlayer

var damage = 1
var mag_size = 30
var total_ammo = 99999
var current_ammo = 0
var can_shoot = true
var sec_between_shots = 0.2

func shoot():
	if !can_shoot:
		return

	current_ammo -= 1
	can_shoot = false
	timer.start(sec_between_shots)

	var b = PROJECTILE.instance()
	b.start(projectile_output_point.global_transform)
	get_parent().get_parent().get_parent().get_parent().add_child(b)

func _on_Timer_timeout():
	can_shoot = true

func run_walking_animation(on):
	if on:
		animation_player.play('walking')
	else:
		animation_player.stop()