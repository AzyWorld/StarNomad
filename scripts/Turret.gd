extends StaticBody2D

export var health = 15
var in_vis = []
var target
var can_shot = true
var patrons = 6
var bullet
var is_obj_to_me

func _process(_delta):
	if target == null:
		if len(in_vis)>0:
			is_obj_to_me = false
			for i in in_vis:
				if not i.is_in_group("turret_target"):
					target = i
					is_obj_to_me = true
			if not is_obj_to_me:
				target = in_vis[0]
	if target != null:
		$Head.look_at(target.position)
		$Head.rotation_degrees += 90
			
		if can_shot and patrons > 0:
			bullet = preload("res://scenes/Bullet.tscn").instance()
			bullet.rotation_degrees = $Head.rotation_degrees
			add_child(bullet)
			$shot_time.start()
			can_shot = false
		elif patrons < 1:
			$reload.start()
		#elif not can_shot:
			#if target.is_in_group("turret_target") and target != null:
				#target.remove_from_group("turret_target")
				#target = null
	if health <= 0:
		queue_free()

func _on_shot_time_timeout():
	can_shot = true


func _on_reload_timeout():
	patrons = 6


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemies"):
		if target == null:
			target = body
		in_vis.append(body)


func _on_Visible_zone_body_exited(body):
	if body == target:
		#if target.is_in_group("turret_target"):
			#target.remove_from_group("turret_target")
		target = null
	in_vis.remove(in_vis.find_last(body))
