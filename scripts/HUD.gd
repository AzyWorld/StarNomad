extends CanvasLayer

signal hotbar_changed

var slot = 1 #Выбранный слот инвентаря
var indix = 0
var doshiks = 2 #Количество дошиков
var crafts = {"Upgraded oxygen tank":0, "armor":1, "GO_MODULE":2} #индекс каждого крафта
var weapons_crafts = {"AK-47":0, "UZI":1, "PP":2} 
var defend_crafts = {"turret":0, "wall1":1, "wall2":2, "wall3":3, "trap":4}
var base_crafts = {"oxygen":0, "capsule_upgrade":1, "atm_magnit":2}
var r_crafts = {"doshik":0}
var ICON = preload("res://scenes/ICON.tscn").instance()
var IconFC = preload("res://scenes/ICON.tscn").instance()
var HotObj = load("res://scripts/hotbar_item.gd")
var InvObj = load("res://scripts/INVobject.gd")
var icons = {"gear":load("res://sprites/icons/Loot/Provod.png"), "iron":load("res://sprites/icons/Loot/iron.png")}
var h_icons = {"revolv":load("res://sprites/icons/REvolver.png"), "doshik":load("res://sprites/icons/doshik.png"), "turret":load("res://sprites/icons/turret icon.png"), "wall1":load("res://sprites/icons/wall1.png"), "wall2":load("res://sprites/icons/wall2.png"), "wall3":load("res://sprites/icons/wall3.png"), "oxygen_t":load("res://sprites/icons/oxygen_tank.png"), "AK-47":load("res://sprites/icons/Ak-47.png"), "UZI":load("res://sprites/icons/UZI.png"), "PP":load("res://sprites/icons/PP.png"),
"trap":load("res://sprites/Sprites/Furniture and defend/trap/trap1.png"), "atm_magnit":load("res://sprites/icons/magnit.png")}
var selected = 1
var r_selected
var oxygen_tank_b
var turret_b
var magnit_b
var is_new_b
var craft_class = 2

var UpOrDown

var hotbar_bufer

var gearObj
var ironObj

var is_n_new

var gear
var iron

var INV = []
var hotbar = []

var revolv = HotObj.new(true, 0, len(hotbar), "revolv")
var new_obj = HotObj.new(false, 2, 1, "doshik")

func _ready():
	hotbar.append(revolv)
	hotbar.append(new_obj)

func delete_group(group):
	for i in get_parent().get_children():
		if i.is_in_group(group):
			i.queue_free()

func create_wall_b(type):
	is_new_b = true
	for i in get_parent().get_children():
		if i.is_in_group("c"):
			i.type = type
			is_new_b = false
	if is_new_b:
		turret_b = preload("res://scenes/wall_b.tscn").instance()
		turret_b.type = type
		get_parent().add(turret_b)
	if Input.is_action_just_pressed("left_click"):
		hotbar[indix].kolvo -= 1

func weapon_in_hands(_rasbros, _weapon_speed, _reload_speed, _is_pistolet, _max_patrons, _is_queue, _queue_speed, _queue_bullets, _bullet_speed, MyName):
	hotbar[indix].patronsInMe = get_parent().get_node("player").patrons
	get_parent().get_node("player").rasbros = _rasbros
	get_parent().get_node("player").weapon_speed = _weapon_speed
	get_parent().get_node("player").reload_speed = _reload_speed
	get_parent().get_node("player").is_pistolet = _is_pistolet
	get_parent().get_node("player").max_patrons = _max_patrons
	get_parent().get_node("player").queue_speed = _queue_speed
	get_parent().get_node("player").is_queue = _is_queue
	get_parent().get_node("player").queue_bullets = _queue_bullets
	get_parent().get_node("player").bullet_speed = _bullet_speed
	get_parent().get_node("player").Current_weapon = MyName
	
func _process(_delta):
	InventoryUpdate()
	selectes_item()
	if !$INV.visible:
		$Oxygen.visible = !Global.is_not_progressbars
		$Health.visible = !Global.is_not_progressbars
		$Wave.visible = !Global.is_not_waves
	$CRAFT/Weapons.visible = craft_class == 1
	$CRAFT/ITEMS.visible = craft_class == 2
	$CRAFT/Defend.visible = craft_class == 3
	$CRAFT/Base.visible = craft_class == 4
	if hotbar[indix].is_weapon:
		$Patrons.text = str(get_parent().get_node("player").patrons)
	else:
		$Patrons.text = str(hotbar[indix].kolvo)
	$item.texture = h_icons[hotbar[indix].MyName]
	if indix > 0:
		$strela2.texture = h_icons[hotbar[indix-1].MyName]
	else:
		$strela2.texture = null
		
	if indix < len(hotbar)-1:
		$strela.texture = h_icons[hotbar[indix+1].MyName]
	else:
		$strela.texture = null
	if hotbar[indix].is_weapon:
		get_parent().get_node("player").can_shot3 = true
		if hotbar[indix].MyName == "AK-47":
			weapon_in_hands(1, 0.05, 2.5, false, 40, true, 0.4, 4, 1000, hotbar[indix].MyName)
		elif hotbar[indix].MyName == "UZI":
			weapon_in_hands(20, 0.1, 0.9, false, 15, false, 0.4, 3, 1000, hotbar[indix].MyName)
		elif hotbar[indix].MyName == "PP":
			weapon_in_hands(5, 0.17, 1.3, false, 15, true, 0.2, 5, 1100, hotbar[indix].MyName)
		elif hotbar[indix].MyName == "revolv":
			weapon_in_hands(0, 0.2, 1, true, 12, false, 0.4, 3, 1500, hotbar[indix].MyName)
	else:
		get_parent().get_node("player").can_shot3 = false
		
	if hotbar[indix].MyName == "doshik":
		if Input.is_action_just_pressed("left_click"):
			if get_parent().get_node("player").health < get_parent().get_node("player").max_health:
				get_parent().get_node("player").health += 5
			else:
				get_parent().get_node("player").health = get_parent().get_node("player").max_health
			hotbar[indix].kolvo -= 1
			doshiks -= 1
	if hotbar[indix].MyName == "turret":
		is_new_b = true
		for i in get_parent().get_children():
			if i.is_in_group("b"):
				is_new_b = false
		if is_new_b:
			turret_b = preload("res://scenes/turret_blueprint.tscn").instance()
			turret_b.connect("post", self, "s_t")
			get_parent().add(turret_b)
	else:
		delete_group("b")
	if hotbar[indix].MyName == "trap":
		is_new_b = true
		for i in get_parent().get_children():
			if i.is_in_group("trap_b"):
				is_new_b = false
		if is_new_b:
			turret_b = preload("res://scenes/trap_b.tscn").instance()
			turret_b.connect("post", self, "s_t")
			get_parent().add(turret_b)
	else:
		delete_group("trap_b")
				
	if hotbar[indix].MyName == "wall1":
		create_wall_b(1)
	elif hotbar[indix].MyName == "wall2":
		create_wall_b(2)
	elif hotbar[indix].MyName == "wall3":
		create_wall_b(3)
	else:
		delete_group("c")
		
	if hotbar[indix].MyName == "oxygen_t":
		delete_group("b")
		delete_group("c")
		is_new_b = true
		for i in get_parent().get_children():
			if i.is_in_group("o_blueprint"):
				is_new_b = false
		if is_new_b:
			oxygen_tank_b = preload("res://scenes/OXYGEN_TANK_B.tscn").instance()
			oxygen_tank_b.connect("post", self, "s_t")
			get_parent().add(oxygen_tank_b)
	else:
		delete_group("o_blueprint")

	if hotbar[indix].MyName == "atm_magnit":
		is_new_b = true
		for i in get_parent().get_children():
			if i.is_in_group("magnit_b"):
				is_new_b = false
		if is_new_b:
			magnit_b = preload("res://scenes/MAGNIT_B.tscn").instance()
			magnit_b.connect("post", self, "s_t")
			get_parent().add(magnit_b)
	else:
		delete_group("magnit_b")

	for i in hotbar:
		if not i.is_weapon:
			if i.kolvo < 1:
				hotbar.remove(hotbar.find(i))
	if indix >= len(hotbar):
		indix = len(hotbar)-1
	for i in INV:
		if i.kolvo < 1:
			INV.remove(INV.find(i))

	if Input.is_action_pressed("ctrl") and Input.is_action_just_released("Inv_down") and 0 < indix:
		hotbar_bufer = hotbar[indix]
		hotbar.remove(hotbar.find(hotbar[indix]))
		hotbar.insert(indix-1, hotbar_bufer)
		indix -= 1
	elif Input.is_action_just_released("Inv_down") and indix > 0: #ВЫБОР СЛОТА
		UpOrDown = "down"
		if hotbar[indix].is_weapon:
			hotbar[indix].patronsInMe = get_parent().get_node("player").patrons
		indix -= 1
		if hotbar[indix].is_weapon:
			get_parent().get_node("player").patrons = hotbar[indix].patronsInMe

	if Input.is_action_pressed("ctrl") and Input.is_action_just_released("Inv_up") and indix < len(hotbar)-1:
		hotbar.insert(indix+2, hotbar[indix])
		hotbar.remove(hotbar.find(hotbar[indix]))
		indix += 1
	elif Input.is_action_just_released("Inv_up") and indix < len(hotbar)-1:
		UpOrDown = "up"
		if hotbar[indix].is_weapon:
			hotbar[indix].patronsInMe = get_parent().get_node("player").patrons
		indix += 1
		if hotbar[indix].is_weapon:
			get_parent().get_node("player").patrons = hotbar[indix].patronsInMe

	if Input.is_action_just_pressed("INV"):
		if $INV.visible:
			$INV.visible = false
			$Panel.visible = false
			for i in get_tree().get_nodes_in_group("hide"):
				i.visible = true
			get_parent().get_node("Blur").material.set("shader_param/lod", get_parent().get_node("Blur").material.get("shader_param/lod")-3.2)
			Input.set_custom_mouse_cursor(load("res://sprites/icons/Cursors/Cursor_normal.png"), Input.CURSOR_ARROW)
		else:
			$INV.visible = true
			$Panel.visible = true
			get_parent().get_node("Blur").material.set("shader_param/lod", get_parent().get_node("Blur").material.get("shader_param/lod")+3.2)
			for i in get_tree().get_nodes_in_group("hide"):
				i.visible = false

func InventoryUpdate():
	for i in $INV.get_children():
		i.queue_free()
	for i in INV:
		ICON = preload("res://scenes/ICON.tscn").instance()
		ICON.get_node("Sprite").texture = icons[i.Name]
		ICON.get_node("Number").text = str(i.kolvo)
		$INV.add_child(ICON)

func craft_recipe(IronKolvo, ProvodKolvo, descr):
	for i in $CRAFT/For_craft.get_children():
		i.queue_free()
	if ProvodKolvo > 0:
		ProvodKolvo = str(ProvodKolvo)
		IconFC = preload("res://scenes/ICON.tscn").instance()
		IconFC.get_node("Sprite").texture = icons["gear"]
		IconFC.get_node("Number").text = ProvodKolvo
		get_node("CRAFT/For_craft").add_child(IconFC)
	if IronKolvo > 0:
		IronKolvo = str(IronKolvo)
		IconFC = preload("res://scenes/ICON.tscn").instance()
		IconFC.get_node("Sprite").texture = icons["iron"]
		IconFC.get_node("Number").text = IronKolvo
		get_node("CRAFT/For_craft").add_child(IconFC)
	$CRAFT/DESCR.text = descr
	
func _on_ITEMS_item_selected(index):
	if craft_class == 2:
		selected = index


func _on_ITEMS_R_item_selected(index):
	r_selected = index
	if index == 0:
		$CRAFT/DESCR.text = "Аптечка, востанавливает 5 жизней(у вас 100).\nБыла разработана земными учеными, \nи ваша капсула может синтезировать такие \nпочти бесконечно(при наличии энергии)"


func _on_craft_r_button_pressed():
	if r_selected == r_crafts["doshik"]:
		is_n_new = true
		for i in hotbar:
			if i.MyName == "doshik":
				is_n_new = false
				if i.kolvo < 6:
					i.kolvo += 2
				else:
					i.kolvo = 6
				doshiks = i.kolvo
		if is_n_new:
			new_obj = HotObj.new(false, 2, len(hotbar), "doshik")
			hotbar.append(new_obj)
			doshiks = 2

func craft_in_hotbar(provod_kolvo, iron_kolvo, Item_name, is_w):
	gear = null
	iron = null
	gearObj = null
	ironObj = null
	for i in INV:
		if i.Name == "gear":
			gear = i.kolvo
			gearObj = i
		elif gear == null:
			gear = 0
		if i.Name == "iron":
			iron = i.kolvo
			ironObj = i
		elif iron == null:
			iron = 0
					
	if 0 < len(INV) and gear >= provod_kolvo and iron >= iron_kolvo:
		if gear > 0:
			gearObj.kolvo -= provod_kolvo
		if iron > 0:
			ironObj.kolvo -= iron_kolvo
		is_n_new = true
		for i in hotbar:
			if i.MyName == Item_name:
				is_n_new = false
				i.kolvo += 1
		if is_n_new:
			new_obj = HotObj.new(is_w, 1, len(hotbar), Item_name)
			hotbar.append(new_obj)
	else:
		$CRAFT/DESCR/D_Anim.play("little")

func _on_Craft_btn_pressed():
	if craft_class == 1:
		if selected == weapons_crafts["AK-47"]:
			craft_in_hotbar(3, 8, "AK-47", true)
		if selected == weapons_crafts["UZI"]:
			craft_in_hotbar(3, 8, "UZI", true)
		if selected == weapons_crafts["PP"]:
			craft_in_hotbar(3, 8, "PP", true)
	if craft_class == 2:
		if selected == crafts["Upgraded oxygen tank"]:
			Crafting_item([InvObj.new("iron", 0, 3), InvObj.new("gear", 0, 1)], "UpgradeOxygenTank")
		if selected == crafts["armor"]:
			Crafting_item([InvObj.new("iron", 0, 4)], "UpgradeArmor")
		elif selected == crafts["GO_MODULE"]:
			Crafting_item([InvObj.new("iron", 0, 2), InvObj.new("gear", 0, 2)], "UnlockSprint")
	elif craft_class == 3:
		if selected == defend_crafts["turret"]:
			craft_in_hotbar(3, 3, "turret", false)
		elif selected == defend_crafts["wall1"]:
			craft_in_hotbar(0, 1, "wall1", false)
		elif selected == defend_crafts["wall2"]:
			craft_in_hotbar(0, 3, "wall2", false)
		elif selected == defend_crafts["wall3"]:
			craft_in_hotbar(0, 5, "wall3", false)
		elif selected == defend_crafts["trap"]:
			craft_in_hotbar(0, 1, "trap", false)
	elif craft_class == 4:
		if selected == base_crafts["oxygen"]:
			craft_in_hotbar(0, 2, "oxygen_t", false)
		if selected == base_crafts["atm_magnit"]:
			craft_in_hotbar(3, 1, "atm_magnit", false)
		if selected == base_crafts["capsule_upgrade"]:
			Crafting_item([InvObj.new("iron", 0, 4), InvObj.new("gear", 0, 1)], "RepairCapsule")

func UpgradeOxygenTank():
	get_parent().get_node("player").max_oxygen = 60
	get_node("Oxygen").max_value = get_parent().get_node("player").max_oxygen
	get_parent().get_node("player").oxygen = get_parent().get_node("player").max_oxygen

func UpgradeArmor():
	get_parent().get_node("player").max_health = 150
	get_node("Health").max_value = get_parent().get_node("player").max_health
	get_parent().get_node("player").health = get_parent().get_node("player").max_health 

func RepairCapsule():
	get_parent().get_node("Capsule/Smoke").emitting = false
	get_parent().get_node("Capsule").health += 10
	get_parent().get_node("Capsule").OxygenReloadTime = 0.5
	
func UnlockSprint():
	get_parent().get_node("player").can_sprint = true

func _on_resume_pressed():
	get_tree().paused = false
	$Pause.visible = false


func _on_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/StartScene.tscn")


func _on_save_and_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/StartScene.tscn")

func s_t():
	hotbar[indix].kolvo -= 1


func _on_weapon_pressed():
	craft_class = 1


func _on_artefacts_pressed():
	craft_class = 2


func _on_defend_pressed():
	craft_class = 3


func _on_base_pressed():
	craft_class = 4


func _on_Weapons_item_selected(index):
	if craft_class == 1:
		selected = index


func _on_Defend_item_selected(index):
	if craft_class == 3:
		selected = index


func _on_Base_item_selected(index):
	if craft_class == 4:
		selected = index

func Crafting_item(Crafting_reses, Func):
	var ResourceTypeCount = len(Crafting_reses)
	for i in Crafting_reses:
		for m in INV:
			if m.Name == i.Name:
				if m.kolvo >= i.kolvo:
					ResourceTypeCount -= 1
	if ResourceTypeCount == 0:
		for i in Crafting_reses:
			for m in INV:
				if m.Name == i.Name:
					m.kolvo -= i.kolvo
		call(Func)

func selectes_item():
	if craft_class == 1:
		if selected > $CRAFT/Weapons.get_item_count()-1:
			selected = $CRAFT/Weapons.get_item_count()-1
		if selected == weapons_crafts["AK-47"]:
			craft_recipe(8, 3, "Автомат Калашникова. \nПользовался большой популярностью на Земле в 20-21 века \nдо третьей мировой войны. ")
		elif selected == weapons_crafts["UZI"]:
			craft_recipe(8, 3, "УЗИ")
		elif selected == weapons_crafts["PP"]:
			craft_recipe(8, 3, "Большая точность и меньшая скорострельность чем у Узи.")
		$CRAFT/Weapons.select(selected)
	elif craft_class == 2:
		if selected > $CRAFT/ITEMS.get_item_count()-1:
			selected = $CRAFT/ITEMS.get_item_count()-1
		if selected == crafts["Upgraded oxygen tank"]:
			craft_recipe(3, 1, "Кислородный баллон, но улучшенный. \nПозволяет дышать 72 секунды. Требует небольшое кол-во \nпластали и резины(для трубок), имеет обычную конструкцию, \nно из-за химического состава стали более легок и прочен.")
		elif selected == crafts["armor"]:
			craft_recipe(4, 0, "Усиливает уязвимые части скафандра. \nТак как пластали используется немного, \nтяжелее идти не становится. ")
		elif selected == crafts["GO_MODULE"]:
			craft_recipe(0, 2, "Облегчает некоторые элементы вашего скафандра\nчто позволяет вам иногда ускорятся(Shift)")
		if selected == crafts["Upgraded oxygen tank"]:
			craft_recipe(3, 1, "Кислородный баллон, но улучшенный. \nПозволяет дышать 72 секунды. Требует небольшое кол-во \nпластали и резины(для трубок), имеет обычную конструкцию, \nно из-за химического состава стали более легок и прочен.")
		elif selected == crafts["armor"]:
			craft_recipe(4, 0, "Усиливает уязвимые части скафандра. \nТак как пластали используется немного, \nтяжелее идти не становится. ")
		elif selected == crafts["GO_MODULE"]:
			craft_recipe(0, 2, "Облегчает некоторые элементы вашего скафандра\nчто позволяет вам иногда ускорятся(Shift)")
		else:
			for i in $CRAFT/For_craft.get_children():
				i.queue_free()
		$CRAFT/ITEMS.select(selected)
	elif craft_class == 3:
		if selected > $CRAFT/Defend.get_item_count()-1:
			selected = $CRAFT/Defend.get_item_count()-1
		if selected == defend_crafts["turret"]:
			craft_recipe(3, 3, "Обычная турель. Первая в своем роде. \nИмеет простой исскуственный интелект, связь с собратьями, \nи некоторые функции. \nБыла разработана транс-государством \"Вортобс\". ")
		elif selected == defend_crafts["wall1"]:
			craft_recipe(1, 0, "Обычный забор, позволяет ненадолго сдержать натиск врагов")
		elif selected == defend_crafts["wall2"]:
			craft_recipe(3, 0, "Баррикада, может многое выстоять")
		elif selected == defend_crafts["wall3"]:
			craft_recipe(5, 0, "ЦЕЛАЯ ЖЕЛЕЗНАЯ СТЕНА")
		elif selected == defend_crafts["trap"]:
			craft_recipe(1, 0, "Конструкция для убийства врагов\nКогда какой-либо враг наступает на ловушку,\nактивируются шипы, и ловушка ломается,\n а враг умирает")
		$CRAFT/Defend.select(selected)
	elif craft_class == 4:
		if selected > $CRAFT/Base.get_item_count()-1:
			selected = $CRAFT/Base.get_item_count()-1
		if selected == base_crafts["oxygen"]:
			craft_recipe(2, 0, "Баллон с кислородом внутри. \nТакими пользуются чтобы хранить газы")
		elif selected == base_crafts["capsule_upgrade"]:
			craft_recipe(4, 1, "Восстанавливает 10 жизней капсуле. \nЕдиноразово восстанавливает систему пожаротушения\n и уменьшает время перезарядки кислорода")
		elif selected == base_crafts["atm_magnit"]:
			craft_recipe(1, 3, "Атмосферный магнит. Может притягивать какие либо объекты, который сгорают в атмосфере.")
		$CRAFT/Base.select(selected)


func _on_Camera_hotbar_changed():
	if hotbar[indix].patronsInMe != null:
		get_parent().get_node("player").patrons = hotbar[indix].patronsInMe
