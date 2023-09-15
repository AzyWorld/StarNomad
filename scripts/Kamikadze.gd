extends KinematicBody2D

onready var target = get_parent().get_node("player")
var is_stop = true
var is_player = false
var distance_x
var distance_y
var speedX
var speedY
var behavior
var in_visible = []
var random = RandomNumberGenerator.new()
var targetSelect
var MyUron = 40

func _ready():
	random.randomize()
	targetSelect = random.randi_range(1, 100)
	$AnimationPlayer.play("spawn 2")
	if targetSelect > 55:
		target = get_parent().get_node("Capsule")
		behavior = get_parent().get_node("Capsule")
	elif targetSelect > 5:
		target = get_parent().get_node("player")
		behavior = get_parent().get_node("player")
	else:
		random.randomize()
		target = get_tree().get_nodes_in_group("target")[len(get_tree().get_nodes_in_group("target"))-1]
		behavior = get_tree().get_nodes_in_group("target")[len(get_tree().get_nodes_in_group("target"))-1]

func _process(_delta):
	if behavior == null:
		random.randomize()
		target = get_tree().get_nodes_in_group("target")[len(get_tree().get_nodes_in_group("target"))-1]
		behavior = get_tree().get_nodes_in_group("target")[len(get_tree().get_nodes_in_group("target"))-1]
	if is_instance_valid(target):
		distance_x = target.position.x - position.x
		distance_y = target.position.y - position.y
		if distance_x <= 0:
			distance_x -= distance_x * 2
		if distance_y <= 0:
			distance_y -= distance_y * 2
	
		if distance_x > distance_y:
			if distance_y > 0:
				speedY = distance_y / distance_x
			else:
				speedY = 0
			speedX = 1
		elif distance_x < distance_y:
			if distance_x > 0:
				speedX = distance_x / distance_y
			else:
				speedX = 0
			speedY = 1
		else:
			speedX = 1
			speedY = 1
	
		if target.position.x < position.x and is_stop:
			position.x -= speedX
		elif target.position.x > position.x and is_stop:
			position.x += speedX
		
		if target.position.y < position.y and is_stop:
			position.y -= speedY
		elif target.position.y > position.y and is_stop:
			position.y += speedY
		
		$visible_zone.look_at(target.position)
		$visible_zone.rotation_degrees += 90
	else:
		if len(in_visible)>0:
			for i in in_visible:
				if i.is_in_group("prioritet"):
					target = i
					break
				else:
					target = in_visible[len(in_visible)-1]
					is_stop = true
					is_player = false
		else:
			target = behavior
			is_stop = true
			is_player = false
	anim()


func _on_Chill_zone_body_entered(body):
	if body == target:
		is_stop = false
		is_player = true
		$Kick_timer.start()
		if not Global.is_not_particles:
			$Particle_timer.start()


func _on_Chill_zone_body_exited(body):
	if body == target:
		is_player = false


func _on_Kick_timer_timeout():
	if is_player:
		target.health -= MyUron
	queue_free()

func _on_visible_zone_body_entered(body):
	if body.is_in_group("target"):
		in_visible.append(body)
		target = body


func _on_visible_zone_body_exited(body):
	if body.is_in_group("target"):
		in_visible.remove(in_visible.find(body))

func anim():
	if ((speedX != 0 or speedY != 0) and is_stop) and !($AnimationPlayer.current_animation == "spawn 2"):
		$AnimationPlayer.play("run")
	elif (not is_stop) or ($AnimationPlayer.current_animation == "spawn 2"):
		pass
	else:
		$AnimationPlayer.stop()


func _on_Particle_timer_timeout():
	$Particles2D.emitting = true
