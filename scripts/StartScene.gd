extends Node

func ButtonHoverText(button, normal_text):
	if button.is_hovered():
		button.text = ">" + normal_text + "<"
	else:
		button.text = normal_text

func _process(_delta):
	get_tree().paused = false
	if $Play.pressed:
		get_tree().change_scene("res://scenes/Main.tscn")
	elif $settings.pressed:
		get_tree().change_scene("res://scenes/Settings.tscn")
	elif $Help.pressed:
		get_tree().change_scene("res://scenes/help.tscn")
	elif $Quit.pressed:
		get_tree().quit()
	if $VK.pressed:
		OS.shell_open("https://www.vk.com/starnomad_progers")
		
	ButtonHoverText($Quit, "Выход")
	ButtonHoverText($Play, "Играть")
	ButtonHoverText($settings, "Настройки")
	ButtonHoverText($Help, "Помощь")

