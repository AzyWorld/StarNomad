extends Node

var vsync = true
var volume
var is_capsule_health = true
var is_enemy_health = false
var is_cheats = false
var is_numbers = false
var is_not_progressbars = false
var is_not_waves = false
var is_not_particles = false
var is_start_animation = true

var is_errors_on_enemies = false

var config
var save_game
var node_data

var wave = 1
var enemy_kills = 0
var time = 0

var is_grid = true

func _process(_delta):
	save_game = File.new()
	if save_game.file_exists("user://Config.save"):
		save_game.open("user://Config.save", File.READ)
		node_data = parse_json(save_game.get_line())
		save_game.close()
		volume = node_data["volume"]
		is_capsule_health = node_data["is_capsule_health"]
		is_enemy_health = node_data["is_enemy_health"]
		is_cheats = node_data["is_cheats"]
		is_numbers = node_data["is_numbers"]
		is_not_progressbars = node_data["is_not_progressbars"]
		is_not_waves = node_data["is_not_waves"]
		is_not_particles = node_data["is_not_particles"]
		is_start_animation = node_data["is_start_animation"]
	else:
		volume = 0
		is_capsule_health = true
		is_enemy_health = false
		is_cheats = false
		is_numbers = false
		is_not_progressbars = false
		is_not_waves = false
		is_start_animation = true
		is_not_particles = false
		is_start_animation = true
	if Input.is_action_just_pressed("toggle_grid"):
		is_grid = !is_grid
