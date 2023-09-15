extends Camera2D

var hotbar : Array = []
var INV : Array = []

var ICON = preload("res://scenes/ICON.tscn").instance()

func _ready():
	for i in range(24):
		ICON = preload("res://scenes/ICON.tscn").instance()
		ICON.get_node("Sprite").texture = null
		$HUD/INV.add_child(ICON)
	for i in range(9):
		ICON = preload("res://scenes/ICON.tscn").instance()
		ICON.get_node("Sprite").texture = null
		$HUD/HOTBAR.add_child(ICON)

func _process(_delta):
	$HUD/Oxygen.visible = !Global.is_not_progressbars
	$HUD/Health.visible = !Global.is_not_progressbars
	$HUD/Wave.visible = !Global.is_not_waves
	
	if Input.is_action_just_pressed("INV"):
		for UI in get_tree().get_nodes_in_group("hide"):
			UI.visible = !UI.visible
