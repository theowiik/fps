extends Area

var direction = Vector3()

var speed = 100
var damage = 100

func start(start_pos, direction = null):
	transform = start_pos
	if !direction: direction = start_pos.basis.y
	self.direction = direction.normalized()

func _physics_process(delta):
	transform.origin += direction * speed * delta

func _on_Timer_timeout():
	queue_free()

func _on_Projectile_body_entered(body):
	queue_free()

	if body is RigidBody:
		var vec = direction.normalized() * damage
		body.apply_impulse(vec, vec)