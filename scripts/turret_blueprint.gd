extends Node2D
var tur
var can = []
signal post
func _process(_delta):
	position.x = get_global_mouse_position().x
	position.y = get_global_mouse_position().y
	if Global.is_grid:
		position.x = position.x - int(position.x) % 10
		position.y = position.y - int(position.y) % 10
	if Input.is_action_just_pressed("left_click") and len(can)<1:
		tur = preload("res://scenes/Turret.tscn").instance()
		tur.position.x = position.x
		tur.position.y = position.y
		get_parent().add(tur)
		emit_signal("post")
		queue_free()
	if 0 < len(can):
		$Polygon2D.color = Color(1, 0, 0)
		$Polygon2D2.color = Color(1, 0, 0)
		$Polygon2D3.color = Color(1, 0, 0)
		$Polygon2D4.color = Color(1, 0, 0)
		$Polygon2D5.color = Color(1, 0, 0)
	else:
		$Polygon2D.color = Color(0, 1, 0)
		$Polygon2D2.color = Color(0, 1, 0)
		$Polygon2D3.color = Color(0, 1, 0)
		$Polygon2D4.color = Color(0, 1, 0)
		$Polygon2D5.color = Color(0, 1, 0)


func _on_without_tur_area_entered(area):
	if area.is_in_group("without") or area.is_in_group("without1"):
		can.append(area)


func _on_without_tur_area_exited(area):
	if area.is_in_group("without") or area.is_in_group("without1"):
		can.remove(can.find(area))
