extends Spatial

var velocity = Vector3()

var speed = 10
var damage = 10

func start(start_pos, direction):
	transform = start_pos
	velocity = direction.normalized() * speed

func _ready():
	print('bullet spawned')

func _physics_process(delta):
	transform.origin += velocity * delta

func _on_Timer_timeout():
	queue_free()

func _on_Projectile_body_entered(body):
	queue_free()

	if body is RigidBody:
		var vec = velocity.normalized() * damage
		body.apply_impulse(vec, vec)