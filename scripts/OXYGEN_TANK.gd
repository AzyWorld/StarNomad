extends Area2D

var is_player = false
var ican = 2

func _process(_delta):
	if is_player:
		if Input.is_action_just_pressed("use"):
			get_parent().get_node("player").stanMe = true
			$stan_timer.start()
	if ican < 1:
		queue_free()

func _on_OXYGEN_TANK_body_entered(body):
	if body.is_in_group("player"):
		is_player = true


func _on_OXYGEN_TANK_body_exited(body):
	if body.is_in_group("player"):
		is_player = false


func _on_stan_timer_timeout():
	get_parent().get_node("player").stanMe = false
	get_parent().get_node("player").oxygen = get_parent().get_node("player").max_oxygen
	ican -= 1
