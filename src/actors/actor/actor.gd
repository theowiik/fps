extends KinematicBody

# Stats
var coins = 0
var health = 100

# Movement
var gravity = 30
var velocity = Vector3()
var jump_speed = 12
var mouse_sensitivy = 0.006
var max_walking_speed = 6
var max_sprinting_speed = 9

func take_coins(amount):
	coins += amount

func take_damage(amount = 1):
	health -= abs(amount)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3.UP, true)