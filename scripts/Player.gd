extends KinematicBody2D

var vel = Vector2()
var speed = 140
var health = 100
var oxygen = 36
var can_shot = true
var can_shot2 = true
var can_shot3 : bool = true
var can_shot4 = true
var can_shot5 = true
var random = RandomNumberGenerator.new()
var can_sprint = false
var is_sprint = false
var stanMe = false
var patrons = 12
var is_oxygen_minus = false

var grabbing_obj
var in_grab_zone = []

var rasbros = 0
var weapon_speed = 0.2
var is_pistolet = true
var reload_speed = 1
var queue_speed = 0.4
var queue_bullets = 3
var current_queue_bullets = 3
var is_queue = false
var bullet_speed = 1500

var shake_power
var shake_time
var is_shake

var Current_weapon = "revolv"

var is_progressBar_working = false
var ProgressBar_time = 1

export var max_patrons = 12
export var max_health = 100
export var max_oxygen = 36

onready var bullet = preload("res://scenes/Bullet.tscn").instance()

func ConnectAll():
	$Oxygen_timer.connect("timeout", self, "on_Oxygen_timer_timeout")
	$Oxygen_timer.start()

func _process(delta):
	if is_shake:
		shake(delta)
	if Current_weapon == "revolv":
		$AnimatedSprite2/Astronaut_arm2.texture = load("res://sprites/Sprites/Astronaut/arm/Astronaut_arm_pistol.png")
	elif Current_weapon == "PP":
		$AnimatedSprite2/Astronaut_arm2.texture = load("res://sprites/Sprites/Astronaut/arm/Astronaut_arm_PP.png")
	elif Current_weapon == "UZI":
		$AnimatedSprite2/Astronaut_arm2.texture = load("res://sprites/Sprites/Astronaut/arm/Astronaut_arm_UZI.png")
	elif Current_weapon == "AK-47":
		$AnimatedSprite2/Astronaut_arm2.texture = load("res://sprites/Sprites/Astronaut/arm/Astronaut_arm_AK.png")
	$AfterShot.wait_time = weapon_speed
	$Reload_time.wait_time = reload_speed
	$queue_time.wait_time = queue_speed
	ProgressBar_working(ProgressBar_time, delta)
	if not get_tree().paused:
		MOVE()
	if not stanMe:
		if is_pistolet:
			if Input.is_action_just_pressed("left_click") and can_shot and patrons > 0 and can_shot2 and can_shot3 and can_shot4 and not get_tree().paused and can_shot5:
				SHOT()
			elif Input.is_action_just_pressed("left_click") and patrons < 1 and not get_tree().paused:
				Audio.play("no_patrons")
		else:
			if Input.is_action_pressed("left_click") and can_shot and patrons > 0 and can_shot2 and can_shot3 and can_shot4 and not get_tree().paused and can_shot5:
				SHOT()
			elif Input.is_action_just_pressed("left_click") and patrons < 1 and not get_tree().paused:
				Audio.play("no_patrons")
	
		if Input.is_action_just_pressed("reload") and can_shot3 and not get_tree().paused:
			RELOAD()
		
	if len(in_grab_zone)>0 or grabbing_obj != null:
		if Input.is_action_pressed("grab"):
			if grabbing_obj == null:
				grabbing_obj = in_grab_zone[0]
			for i in grabbing_obj.get_children():
				if i.is_in_group("coll"):
					i.disabled = true
			if $AnimatedSprite2.flip_h:
				grabbing_obj.position.x = position.x - 40
				grabbing_obj.position.y = position.y - 10
			else:
				grabbing_obj.position.x = position.x + 40
				grabbing_obj.position.y = position.y - 10
		else:
			if grabbing_obj != null:
				if $AnimatedSprite2.flip_h:
					grabbing_obj.position.y = position.y - 10
				else:
					grabbing_obj.position.y = position.y - 10
				for i in grabbing_obj.get_children():
					if i.is_in_group("coll"):
						i.disabled = false
				 grabbing_obj = null
		#get_parent().get_node("CanvasModulate").color.b = float(health) / float(max_health) + 0.1
		#get_parent().get_node("CanvasModulate").color.g = float(health) / float(max_health) + 0.1
	if health <= 0:
		get_tree().change_scene("res://scenes/GAME OVER.tscn")
	if oxygen <= 0:
		health -= 0.2
		get_parent().get_node("Blur").material.set("shader_param/lod", get_parent().get_node("Blur").material.get("shader_param/lod")+0.011)
	else:
		if !get_parent().get_node("HUD/Panel").visible:
			get_parent().get_node("Blur").material.set("shader_param/lod", 0.3)
	$Polygon2D.look_at(get_global_mouse_position())
	$Polygon2D.rotation_degrees += 90
	
	get_parent().get_node("HUD/Health").value = health
	get_parent().get_node("HUD/Oxygen").value = oxygen
	get_parent().get_node("HUD/Patrons").text = str(patrons)
	MoveCam()
	anim()
	
func MOVE():  #Функция движения персонажа
	if can_sprint:
		if Input.is_action_pressed("sprint"):
			is_sprint = true
		else:
			is_sprint = false
	if is_sprint:
		speed = 240
		$Oxygen_timer.wait_time = 0.5
	else:
		speed = 140
		$Oxygen_timer.wait_time = 1
	if Input.is_action_pressed("down") and not stanMe:
		vel.y = speed
	elif Input.is_action_pressed("up") and not stanMe:
		vel.y = -speed
	else:
		vel.y = 0
	
	if Input.is_action_pressed("right") and not stanMe:
		vel.x = speed
	elif Input.is_action_pressed("left") and not stanMe:
		vel.x = -speed
	else:
		vel.x = 0
		
	if stanMe:
		vel.x = 0
		vel.y = 0
	vel = move_and_slide(vel)


func SHOT():  #Фунция выстрела
	if !Global.is_not_particles:
		$AnimatedSprite2/Astronaut_arm2/Particles2D.emitting = true
	bullet = preload("res://scenes/Bullet.tscn").instance()
	random.randomize()
	bullet.rotation_degrees = $Polygon2D.rotation_degrees + random.randi_range(0 - rasbros, 0 + rasbros)
	bullet.position = position
	bullet.position += ($AnimatedSprite2/Astronaut_arm2.position + $AnimatedSprite2.position/4) + Vector2(2, 0)
	bullet.speed = bullet_speed
	get_parent().add_child(bullet)
	$AfterShot.start()
	Audio.play("shot")
	patrons -= 1
	if is_queue:
		current_queue_bullets -= 1
		if current_queue_bullets < 1:
			$queue_time.start()
			can_shot5 = false
	can_shot = false
	
func RELOAD(): #Функция перезарядки
	can_shot2 = false
	$Reload_time.start()
	Audio.get_node("reload").play()
	ProgressBar_Move($Reload_time.wait_time)

func ProgressBar_Move(a):
	$Reload_and_uses.value = 0
	$Reload_and_uses.visible = true
	ProgressBar_time = a
	is_progressBar_working = true

func ProgressBar_working(a, b):
	if is_progressBar_working and $Reload_and_uses.value <= 99.999:
		$Reload_and_uses.value += 100/a/(1/b)
	else:
		$Reload_and_uses.visible = false
		is_progressBar_working = false

func _on_AfterShot_timeout():
	can_shot = true

func on_Oxygen_timer_timeout():
	$Oxygen_timer.start()
	oxygen -= 1
	Global.time += 1

func _on_Reload_time_timeout():
	can_shot2 = true
	patrons = max_patrons
	
func anim():
	if vel.x < 0:
		$Polygon2D/hand.flip_h = true
		$Polygon2D/Particles2D.position.x = 17
		
	elif vel.x > 0:
		$Polygon2D/hand.flip_h = false
		$Polygon2D/Particles2D.position.x = -8
		
	if $Polygon2D.rotation_degrees <= 0:
		$Polygon2D.rotation_degrees = 359
	if $Polygon2D.rotation_degrees >= 360:
		$Polygon2D.rotation_degrees = 1
	
	if ($Polygon2D.rotation_degrees > 315 or $Polygon2D.rotation_degrees < 45) and (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("up_run")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = -5
		$AnimatedSprite2/Astronaut_arm2.z_index = -5
	elif ($Polygon2D.rotation_degrees > 45 and $Polygon2D.rotation_degrees < 90) and (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left2_run")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = -5
		$AnimatedSprite2/Astronaut_arm2.z_index = -5
	elif ($Polygon2D.rotation_degrees > 90 and $Polygon2D.rotation_degrees < 135) and (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left1_run")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = 5
		$AnimatedSprite2/Astronaut_arm2.z_index = 5
	elif ($Polygon2D.rotation_degrees > 135 and $Polygon2D.rotation_degrees < 225) and (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("down_run")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = 5
		$AnimatedSprite2/Astronaut_arm2.z_index = 5
	elif ($Polygon2D.rotation_degrees > 225 and $Polygon2D.rotation_degrees < 270) and (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left1_run")
		$AnimatedSprite2.flip_h = true
		$AnimatedSprite2/Astronaut_arm.z_index = 5
		$AnimatedSprite2/Astronaut_arm2.z_index = 5
	elif ($Polygon2D.rotation_degrees > 270 and $Polygon2D.rotation_degrees < 315) and (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left2_run")
		$AnimatedSprite2.flip_h = true
		$AnimatedSprite2/Astronaut_arm.z_index = -5
		$AnimatedSprite2/Astronaut_arm2.z_index = -5
	
	if ($Polygon2D.rotation_degrees > 45 and $Polygon2D.rotation_degrees < 90) and not (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left2_idle")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = -5
		$AnimatedSprite2/Astronaut_arm2.z_index = -5
	elif ($Polygon2D.rotation_degrees > 90 and $Polygon2D.rotation_degrees < 135) and not (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left1_idle")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = 5
		$AnimatedSprite2/Astronaut_arm2.z_index = 5
	elif ($Polygon2D.rotation_degrees > 135 and $Polygon2D.rotation_degrees < 225) and not (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("down_idle")
		$AnimatedSprite2.flip_h = false
		$AnimatedSprite2/Astronaut_arm.z_index = 5
		$AnimatedSprite2/Astronaut_arm2.z_index = 5
	elif ($Polygon2D.rotation_degrees > 225 and $Polygon2D.rotation_degrees < 270) and not (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left1_idle")
		$AnimatedSprite2.flip_h = true
		$AnimatedSprite2/Astronaut_arm.z_index = 5
		$AnimatedSprite2/Astronaut_arm2.z_index = 5
	elif ($Polygon2D.rotation_degrees > 270 and $Polygon2D.rotation_degrees < 315) and not (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("left2_idle")
		$AnimatedSprite2.flip_h = true
		$AnimatedSprite2/Astronaut_arm.z_index = -5
		$AnimatedSprite2/Astronaut_arm2.z_index = -5
	elif ($Polygon2D.rotation_degrees > 315 or $Polygon2D.rotation_degrees < 45) and not (vel.x != 0 or vel.y != 0):
		$AnimatedSprite2.play("up_idle")
		$AnimatedSprite2.flip_h = true
		$AnimatedSprite2/Astronaut_arm.z_index = -5
		$AnimatedSprite2/Astronaut_arm2.z_index = -5
		
	if not $AnimatedSprite2.flip_h:
		$AnimatedSprite2/Astronaut_arm.position = Vector2(-7, 8)
		$AnimatedSprite2/Astronaut_arm2.position = Vector2(8, 8)
		$AnimatedSprite2/Astronaut_arm2.flip_v = false
		$AnimatedSprite2/Astronaut_arm2/Particles2D.position = Vector2(6, -1.95)
	else:
		$AnimatedSprite2/Astronaut_arm2.position = Vector2(-7, 8)
		$AnimatedSprite2/Astronaut_arm.position = Vector2(8, 8)
		$AnimatedSprite2/Astronaut_arm2.flip_v = true
		$AnimatedSprite2/Astronaut_arm2/Particles2D.position = Vector2(6, 1.95)
	$AnimatedSprite2/Astronaut_arm2.look_at(get_global_mouse_position())

func MoveCam():
	if not is_shake:
		$Camera2D.offset_h = (get_viewport().get_mouse_position().x/OS.get_screen_size().x-0.5)*0.8
		$Camera2D.offset_v = (get_viewport().get_mouse_position().y/OS.get_screen_size().y-0.5)*0.8

func StartShake(ShakePower, ShakeTime):
	shake_power = ShakePower
	shake_time = ShakeTime
	is_shake = true

func shake(delta):
	if shake_time>0:
		$Camera2D.offset += Vector2(random.randf_range(-1.0, 1.0), random.randf_range(-1.0, 1.0)) * shake_power
		shake_time -= delta
	else:
		is_shake = false

func _on_grab_zone_body_entered(body):
	if body.is_in_group("grab"):
		in_grab_zone.append(body)

func _on_grab_zone_body_exited(body):
	if body.is_in_group("grab"):
		in_grab_zone.remove(in_grab_zone.find(body))

func _on_queue_time_timeout():
	current_queue_bullets = queue_bullets
	can_shot5 = true
