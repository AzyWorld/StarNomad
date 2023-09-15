extends Node

var volume = 0

func _process(_delta):
	get_node("explosion").volume_db += 10
	get_node("shot").volume_db += 30
	for i in get_children():
		i.volume_db = volume
	get_node("shot").volume_db -= 30
	get_node("explosion").volume_db -= 10


func play(audio):
	get_node(audio).play()
