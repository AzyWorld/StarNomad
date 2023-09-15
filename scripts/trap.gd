extends Area2D



func _on_anim_timer_timeout():
	queue_free()


func _on_trap_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
		$AnimatedSprite.play("trap")
		$anim_timer.start()
