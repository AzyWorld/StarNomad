extends Node2D

onready var enemy1 = preload("res://scenes/Enemy1.tscn").instance()
onready var bullet = preload("res://scenes/Bullet.tscn").instance()
var INVobject = load("res://scripts/INVobject.gd")
var x
var y
var XoY = true
var Wave = 1
var WaveEnemies = 4
var loot_after_wave
export var MaxWaveEnemies = 4
export var PlusTime = 0.5
export var PlusMax = 3
var random = RandomNumberGenerator.new()
var loot

var new_loot
var is_need_new_loot

func SpawnPlayer():
	$player.visible = true
	
func SpawnCamera():
	var cam = preload("res://scenes/HUD.tscn").instance()
	add_child(cam)
	get_node("player").set_script(load("res://scripts/Player.gd"))
	get_node("player").set_process(true)
	get_node("player").ConnectAll()
	get_node("player/Camera2D").current = true
	$Capsule.set_script(load("res://scripts/Capsule.gd"))
	$Capsule.set_process(true)
	$Capsule/Health.visible = true

func ChangeCapsuleTexture():
	$Capsule/capsule_craft.scale = Vector2(0.3, 0.3)
	$Capsule/capsule_craft.texture = load("res://sprites/Sprites/capsule/capsule2.png")

func _ready():
	if Global.is_start_animation:
		$StartAnimarion.play("Start")
	else:
		$Capsule/Particles2D.emitting = false
		$Capsule/Particles2D2.emitting = false
		$Capsule/Particles2D3.emitting = false
		$Capsule/Particles2D5.emitting = false
		$Capsule/capsule_craft.scale = Vector2(0.3, 0.3)
		$Capsule/capsule_craft.texture = load("res://sprites/Sprites/capsule/capsule2.png")
		$Capsule.position = Vector2(950, 550)
		$Capsule.rotation_degrees = 0
		SpawnPlayer()
		SpawnCamera()
		$OutWawe_timer.start()
		$InWaveTimer.start()

func _process(_delta):
	if Global.is_cheats:
		if Input.is_action_just_pressed("f3"):
			is_need_new_loot = true
			for i in $HUD.INV:
				if i.Name == "gear":
					i.kolvo += 5
					i.number = len($HUD.INV)
					is_need_new_loot = false
			if is_need_new_loot:
				new_loot = INVobject.new("gear", len($HUD.INV), 5)
				$HUD.INV.append(new_loot)
		if Input.is_action_just_pressed("f4"):
			is_need_new_loot = true
			for i in $HUD.INV:
				if i.Name == "iron":
					i.kolvo += 5
					i.number = len($HUD.INV)
					is_need_new_loot = false
			if is_need_new_loot:
				new_loot = INVobject.new("iron", len($HUD.INV), 5)
				$HUD.INV.append(new_loot)
		if Input.is_action_just_pressed("f5"):
			LootFall(true)
		if Input.is_action_just_pressed("f6"):
			if get_node("player/Camera2D").zoom != Vector2(1, 1):
				get_node("player/Camera2D").zoom = Vector2(1, 1)
			else:
				get_node("player/Camera2D").zoom = Vector2(0.45, 0.45)
	for i in get_children():
		if i.name == "HUD" and !$HUD/Panel.visible:
			Input.set_custom_mouse_cursor(load("res://sprites/icons/Cursors/pricel.png"), Input.CURSOR_CROSS)

func _on_InWaveTimer_timeout():
	if WaveEnemies > 0:
		loot_after_wave = true
		random.randomize()
		if random.randi_range(1, 20) > 4:
			enemy1 = preload("res://scenes/Enemy1.tscn").instance()
			enemy1.connect("loot", self, "loot1")
			WaveEnemies -= 1
		else:
			if Wave > 5:
				enemy1 = preload("res://scenes/Kamikadze.tscn").instance()
				WaveEnemies -= 1
		random.randomize()
		XoY = random.randi_range(1, 2)
		if XoY == 1:
			XoY = true
		else:
			XoY = false
		if XoY:
			random.randomize()
			x = random.randi_range(-200, 2420)
			random.randomize()
			y = random.randi_range(-200, 1280)
			if x > 0 or x < 1920:
				while y > 0 and y < 1080:
					random.randomize()
					y = random.randi_range(-200, 1280)
		else:
			random.randomize()
			x = random.randi_range(-200, 2420)
			random.randomize()
			y = random.randi_range(-200, 1280)
			if y > 0 or y < 1080:
				while x > 0 and x < 1920:
					random.randomize()
					x = random.randi_range(-200, 2420)
		if is_instance_valid(enemy1):
			enemy1.position.x = x
			enemy1.position.y = y
			add(enemy1)
	elif loot_after_wave:
		LootFall(false)
	$InWaveTimer.start()

func _on_OutWawe_timer_timeout():
	Global.wave = Wave
	MaxWaveEnemies += PlusMax
	WaveEnemies = MaxWaveEnemies
	Wave += 1
	$HUD/Wave.text = 'Волна: ' + str(Wave)
	$OutWawe_timer.wait_time += PlusTime
	$OutWawe_timer.start()

func loot1(position):
	loot = preload("res://scenes/Loot.tscn").instance()
	random.randomize()
	if random.randi_range(1, 100) < 25:
		loot.type = "gear"
	else:
		loot.type = "iron"
	loot.position = position
	loot.connect("loot_me", self, "plus_loot")
	add(loot)

func LootFall(IsPass):
	for magnit in get_tree().get_nodes_in_group("magnit"):
		if magnit == get_tree().get_nodes_in_group("magnit")[0] and loot_after_wave and  1 > len(get_tree().get_nodes_in_group("enemies")):
			loot = preload("res://scenes/Loot.tscn").instance()
			random.randomize()
			if random.randi_range(1, 100) < 50:
				loot.type = "gear"
			else:
				loot.type = "iron"
			loot.pos.y = magnit.position.y
			loot.pos.x = magnit.position.x
			loot.connect("loot_me", self, "plus_loot")
			loot.is_start = true
			add(loot)
		elif loot_after_wave and 1 > len(get_tree().get_nodes_in_group("enemies")):
			loot = preload("res://scenes/Loot.tscn").instance()
			random.randomize()
			if random.randi_range(1, 1000) < 300 and random.randi_range(1, 1000) > 149:
				loot.type = "gear"
			elif random.randi_range(1, 1000) < 150:
				loot.type = "iron"
			loot.pos.y = magnit.position.y
			loot.pos.x = magnit.position.x
			loot.connect("loot_me", self, "plus_loot")
			loot.is_start = true
			add(loot)
	if (1 > len(get_tree().get_nodes_in_group("enemies")) and 1 > len(get_tree().get_nodes_in_group("magnit"))) or IsPass:
		loot = preload("res://scenes/Loot.tscn").instance()
		random.randomize()
		if random.randi_range(1, 100) < 50:
			loot.type = "gear"
		else:
			loot.type = "iron"
		random.randomize()
		loot.pos.y = random.randi_range(30, 1000)
		random.randomize()
		loot.pos.x = random.randi_range(30, 1890)
		loot.connect("loot_me", self, "plus_loot")
		loot.is_start = true
		add(loot)
	if 1 > len(get_tree().get_nodes_in_group("enemies")):
		loot_after_wave = false

func plus_loot(type):
	is_need_new_loot = true
	for i in $HUD.INV:
		if i.Name == type:
			i.kolvo += 1
			is_need_new_loot = false
	if is_need_new_loot:
		new_loot = INVobject.new(type, len($HUD.INV), 1)
		$HUD.INV.append(new_loot)

func add(child):
	random.randomize()
	child.name += str(random.randi_range(1, 1000000))
	get_node(".").call_deferred("add_child", child)


func _on_StartAnimarion_animation_finished(_anim_name):
	$OutWawe_timer.start()
	$InWaveTimer.start()
