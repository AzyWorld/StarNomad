extends GridContainer

func _process(_delta):
	for i in get_children():
		if i.is_hovered():
			if i.get_node("Sprite").texture == load("res://sprites/icons/Loot/Provod.png"):
				get_parent().get_node("Panel/ITEM_DESCRIPTION").text = "Кусок медного провода, содержит медь и немного резины"
			elif i.get_node("Sprite").texture == load("res://sprites/icons/Loot/iron.png"):
				get_parent().get_node("Panel/ITEM_DESCRIPTION").text = "Обычный кусок пластали, сорванный с вашей капсулы"
