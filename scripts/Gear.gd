extends Area2D

signal loot_me

var type = "gear"
var pos = Vector2()
var is_start = false
var looted

var TypeTextures = {"iron":load("res://sprites/icons/Loot/iron.png"), "gear":load("res://sprites/icons/Loot/Provod.png")}

func _ready():
	$Sprite.texture = TypeTextures[type]
	if is_start:
		position.x = -50
		position.y = -50
		start()
		monitorable = false
func start():
	$Tween.interpolate_property(self, "position", Vector2(pos.x -2000, pos.y-2000), pos, 5,  Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$Tween.start()
func start2():
	$Tween.interpolate_property(self, "scale", Vector2(0.1, 0.1), Vector2(1, 1), 1,  Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
func _process(_delta):
	if looted != null:
		position -= (position - looted.position).normalized()*3
		if position.x <= looted.position.x+3 and position.x >= looted.position.x-3 and position.y <= looted.position.y+3 and position.y >= looted.position.y-3:
			emit_signal("loot_me", type)
			queue_free()

func _on_Gear_body_entered(body):
	if body.is_in_group("player"):
		looted = body

func _on_Timer_timeout():
	queue_free()



func _on_Tween_tween_completed(object, key):
	monitorable = true
