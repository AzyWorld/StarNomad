extends Control

func ButtonHoverText(button, normal_text):
	if button.is_hovered():
		button.text = ">" + normal_text + "<"
	else:
		button.text = normal_text

func _process(_delta):
	if $back.pressed or Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://scenes/StartScene.tscn")
	ButtonHoverText($back, "вернуться")

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/StartScene.tscn")
