extends StaticBody2D

var health = 20

func _process(_delta):
	if health < 0:
		queue_free()


