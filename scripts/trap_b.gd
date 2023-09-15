extends Area2D

var inMe = []
signal post

func _process(_delta):
	position = get_global_mouse_position()
	if Global.is_grid:
		position.x = position.x - int(position.x) % 10
		position.y = position.y - int(position.y) % 10
	if Input.is_action_just_pressed("left_click") and 1 > len(inMe):
		var trap = preload("res://scenes/trap.tscn").instance()
		trap.position = position
		emit_signal("post")
		get_parent().add(trap)
	if 0 < len(inMe):
		$Polygon2D.color = Color(1, 0, 0)
		$Polygon2D2.color = Color(1, 0, 0)
		$Polygon2D3.color = Color(1, 0, 0)
	else:
		$Polygon2D.color = Color(0, 1, 0)
		$Polygon2D2.color = Color(0, 1, 0)
		$Polygon2D3.color = Color(0, 1, 0)

func _on_trap_b_body_entered(body):
	inMe.append(body)

func _on_trap_b_body_exited(body):
	inMe.remove(inMe.find(body))
