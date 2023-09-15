extends Area2D

signal loot_me

var type = "porox"

func _on_Iron_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("loot_me", type)
		queue_free()
