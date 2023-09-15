extends Node

var is_weapon = false
var kolvo = 0
var number = 0
var MyName
var patronsInMe

func _init(is_w, kol, num, _name):
	patronsInMe = 10
	is_weapon = is_w
	kolvo = kol
	number = num
	MyName = _name
