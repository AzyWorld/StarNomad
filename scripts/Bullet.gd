extends KinematicBody2D

var vel = Vector2()
var speed = 1500

func _physics_process(_delta):
	$Particles2D.emitting = !Global.is_not_particles
	vel = Vector2(0, -speed).rotated(rotation) #Типа идет в сторону взгляда
	vel = move_and_slide(vel)


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
		queue_free()
		Global.enemy_kills += 1


func _on_Timer_timeout():
	queue_free()


#func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()
