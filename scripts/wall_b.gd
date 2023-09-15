extends Node2D

var wall
var type = 1
var can = []
func _process(_delta):
	position.x = get_global_mouse_position().x
	position.y = get_global_mouse_position().y
	if Global.is_grid:
		position.x = position.x - int(position.x) % 10
		position.y = position.y - int(position.y) % 10
	wall = preload("res://scenes/wall.tscn").instance()
	if type == 1:
		scale.x = 0.5
	elif type == 2:
		scale.x = 1
	else:
		scale.x = 2
	if Global.is_grid:
		if Input.is_action_just_pressed("reload"):
			rotation_degrees += 45
	else:
		if Input.is_action_pressed("reload"):
			rotation_degrees += 1
	if Input.is_action_just_pressed("left_click") and 1 > len(can):
		wall.position.x = position.x
		wall.position.y = position.y
		wall.rotation_degrees = rotation_degrees
		if type == 1:
			wall.health = 20
			wall.scale.x = 0.5
		elif type == 2:
			wall.health = 50
			wall.scale.x = 1
		else:
			wall.health = 85
			wall.scale.x = 2
		get_parent().add(wall)
		queue_free()
	if 0 < len(can):
		$Polygon2D.color = Color(1, 0, 0)
	else:
		$Polygon2D.color = Color(0, 1, 0)


func _on_w_area_entered(area):
	if area.is_in_group("without"):
		can.append(area)


func _on_w_area_exited(area):
	if area.is_in_group("without"):
		can.remove(can.find(area))
