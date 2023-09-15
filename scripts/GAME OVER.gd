extends Control


func _ready():
	$Label2.text = "ВЫ ПЕРЕЖИЛИ " + str(Global.wave) + " ВОЛН,\nУбили " + str(Global.enemy_kills) + " врагов,\nПрожито " + str(Global.time) + " секунд." 


func _on_restart_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_to_menu_pressed():
	get_tree().change_scene("res://scenes/StartScene.tscn")
