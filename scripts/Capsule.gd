extends StaticBody2D

var is_player = false
var health = 150
var is_uron = 0
var OxygenReloadTime = 1

func _ready():
	$Health.visible = true

func _on_OxygenArea_body_entered(body):
	if body.is_in_group("player"):
		is_player = true

func _process(_delta):
	$REload_oxygen.wait_time = OxygenReloadTime
	$Health.visible = Global.is_capsule_health
	if health > 150:
		health = 150
	if is_player:
		if Input.is_action_just_pressed("use"):
			get_parent().get_node("player").stanMe = true
			get_parent().get_node("player").ProgressBar_Move($REload_oxygen.wait_time)
			$REload_oxygen.start()
		if (Input.is_action_just_pressed("INV") or get_parent().get_node("HUD/INV").visible) and not get_parent().get_node("HUD/CRAFT").visible:
			get_parent().get_node("HUD/CRAFT").visible = true
			$AnimationPlayer.play("crafting")
		elif Input.is_action_just_pressed("INV") and get_parent().get_node("HUD/CRAFT").visible:
			get_parent().get_node("HUD/CRAFT").visible = false
			$AnimationPlayer.play_backwards("crafting")

	else:
		if get_parent().get_node("HUD/CRAFT").visible:
			if get_parent().get_node("HUD/INV").visible:
				$AnimationPlayer.play_backwards("crafting")
			get_parent().get_node("HUD/CRAFT").visible = false


	if get_parent().get_node("HUD/INV").visible:
		get_parent().get_node("player").can_shot4 = false
	else:
		get_parent().get_node("player").can_shot4 = true
	$Health.value = 150 - health
	if health <= 0:
		Audio.play("explosion")
		get_parent().get_node("player").StartShake(2, 1)
		queue_free()

func _on_REloadoxygen_timeout():
	get_parent().get_node("player").oxygen = get_parent().get_node("player").max_oxygen
	get_parent().get_node("player").stanMe = false

func _on_OxygenArea_body_exited(body):
	if body.is_in_group("player"):
		is_player = false
