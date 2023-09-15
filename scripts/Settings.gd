extends Control

var config
var save_game

func ButtonHoverText(button, normal_text):
	if button.is_hovered():
		button.text = ">" + normal_text + "<"
	else:
		button.text = normal_text

func _ready():
	$VolumeBox/volume.value = Global.volume
	$CheckBoxes/capsule_health.pressed = Global.is_capsule_health
	$CheckBoxes/enemies_health.pressed = Global.is_enemy_health
	$CheckBoxes/cheats.pressed = Global.is_cheats                                       #Записываем значения настроек из сохранения, которое в Global
	$CheckBoxes/numbers.pressed = Global.is_numbers
	$CheckBoxes/is_progressbars.pressed = Global.is_not_progressbars
	$CheckBoxes/is_waves.pressed = Global.is_not_waves
	$CheckBoxes/is_particles.pressed = Global.is_not_particles
	$CheckBoxes/StartAnimation.pressed = Global.is_start_animation


func _process(_delta):
	ButtonHoverText($back, "Вернуться")
	Audio.volume = $VolumeBox/volume.value
	Global.is_capsule_health = $CheckBoxes/capsule_health.pressed
	Global.is_enemy_health = $CheckBoxes/enemies_health.pressed
	Global.is_cheats = $CheckBoxes/cheats.pressed                           # Записываем значения настроек в текущей сессии
	Global.is_numbers = $CheckBoxes/numbers.pressed
	Global.is_not_progressbars = $CheckBoxes/is_progressbars.pressed
	Global.is_not_waves = $CheckBoxes/is_waves.pressed
	Global.is_not_particles = $CheckBoxes/is_particles.pressed
	Global.is_start_animation = $CheckBoxes/StartAnimation.pressed

func save():
	config = {
		"volume":$VolumeBox/volume.value,
		"is_capsule_health":$CheckBoxes/capsule_health.pressed,
		"is_enemy_health":$CheckBoxes/enemies_health.pressed,
		"is_cheats":$CheckBoxes/cheats.pressed,
		"is_numbers":$CheckBoxes/numbers.pressed,                                   #Сохраняем в конфиг
		"is_not_progressbars":$CheckBoxes/is_progressbars.pressed,
		"is_not_waves":$CheckBoxes/is_waves.pressed,
		"is_not_particles":$CheckBoxes/is_particles.pressed,
		"is_start_animation":$CheckBoxes/StartAnimation.pressed
	}
	save_game = File.new()
	save_game.open("user://Config.save", File.WRITE)
	save_game.store_line(to_json(config))
	save_game.close()

func _on_back_pressed():
	save()
	get_tree().change_scene("res://scenes/StartScene.tscn")           #Переход в главное меню

