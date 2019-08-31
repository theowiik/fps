extends Area

var value = 1

func _on_Coin_body_entered(body):
	if body.has_method('take_coins'):
		body.take_coins(value)

	$AudioStreamPlayer3D.play()
	hide()

func hide():
	$Hitbox.queue_free()
	$"coinGold(Clone)".queue_free()

func _on_AudioStreamPlayer3D_finished():
	queue_free()