extends Area2D
var magnit
var can = []
signal post
func _process(_delta):
	position.x = get_global_mouse_position().x
	position.y = get_global_mouse_position().y
	if Global.is_grid:
		position.x = position.x - int(position.x) % 10
		position.y = position.y - int(position.y) % 10
	magnit = preload("res://scenes/Magnit.tscn").instance()
	if Global.is_grid:
		if Input.is_action_just_pressed("reload"):
			rotation_degrees += 45
	else:
		if Input.is_action_pressed("reload"):
			rotation_degrees += 1
	if Input.is_action_just_pressed("left_click") and 1 > len(can):
		magnit.position.x = position.x
		magnit.position.y = position.y
		magnit.rotation_degrees = rotation_degrees
		emit_signal("post")
		get_parent().add(magnit)
		queue_free()
	if 0 < len(can):
		$Polygon2D.color = Color(1, 0, 0)
	else:
		$Polygon2D.color = Color(0, 1, 0)

func _on_MAGNIT_B_area_entered(area):
	if area.is_in_group("without"):
		can.append(area)


func _on_MAGNIT_B_area_exited(area):
	if area.is_in_group("without"):
		can.remove(can.find(area))
