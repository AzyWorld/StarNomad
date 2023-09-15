extends Node

var Name
var kolvo
var is_weapon = false
var texture = null
var stack = 50
var rasbros
var weapon_speed
var reload_speed
var is_pistolet
var max_patrons
var is_queue
var queue_speed
var queue_bullets
var bullet_speed

func _init(_name, _kolvo, _rasbros, _weapon_speed, _reload_speed, _is_pistolet, _max_patrons, _is_queue, _queue_speed, _queue_bullets, _bullet_speed):
	Name = _name
	kolvo = _kolvo
