extends Panel

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		if visible:
			get_tree().paused = false
			visible = false
		else:
			get_tree().paused = true
			visible = true


func _on_resume_pressed():
	visible = false
	get_tree().paused = false


func _on_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/StartScene.tscn")


func _on_save_and_quit_pressed():
	#get_tree().change_scene("res://scenes/StartScene.tscn")
	pass
