extends Area2D

signal post
var inMe = []

func _process(_delta):
	position = get_global_mouse_position()
	if Global.is_grid:
		position.x = position.x - int(position.x) % 10
		position.y = position.y - int(position.y) % 10
	if Input.is_action_just_pressed("left_click") and 1 > len(inMe):
		emit_signal("post")
		var ox = preload("res://scenes/OXYGEN_TANK.tscn").instance()
		ox.position = position
		get_parent().add(ox)
	if 0 < len(inMe):
		$Polygon2D.color = Color(1, 0, 0)
	else:
		$Polygon2D.color = Color(0, 1, 0)


func _on_OXYGEN_TANK_B_body_entered(body):
	inMe.append(body)


func _on_OXYGEN_TANK_B_area_entered(area):
	if area.is_in_group("no_ox"):
		inMe.append(area)


func _on_OXYGEN_TANK_B_area_exited(area):
	if area.is_in_group("no_ox"):
		inMe.remove(inMe.find(area))


func _on_OXYGEN_TANK_B_body_exited(body):
	inMe.remove(inMe.find(body))
