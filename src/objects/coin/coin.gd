extends Area

var value = 1

func _on_Coin_body_entered(body):
	queue_free()
	if body.has_method('take_coins'):
		body.take_coins(value)