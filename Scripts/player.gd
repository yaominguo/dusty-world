extends CharacterBody2D

signal health_updated
signal stamina_updated
signal ammo_pickups_updated
signal health_pickups_updated
signal stamina_pickups_updated

@export var speed = 50

var new_direaction = Vector2(0, 1)
var animation
var is_attacking = false

var health = 100
var max_health = 100
var regen_health = 1
var stamina = 100
var max_stamina = 100
var regen_stamina = 5

enum Pickups {AMMO, STAMINA, HEALTH}
var ammo_pickup = 0
var health_pickup = 0
var stamina_pickup = 0

var bullet_damage = 30
var bullet_reload_time = 1000
var bullet_fired_time = 0.5
var bullet_scene = preload("res://Scenes/bullet.tscn")

func _ready():
	health_updated.emit(health, max_health)
	stamina_updated.emit(stamina, max_stamina)

	ammo_pickups_updated.emit(ammo_pickup)
	health_pickups_updated.emit(health_pickup)
	stamina_pickups_updated.emit(stamina_pickup)

func _process(delta):
	var updated_health = min(health + regen_health * delta, max_health)
	if updated_health != health:
		health = updated_health
		health_updated.emit(health, max_health)
	var updated_stamina = min(stamina + regen_stamina * delta, max_stamina)
	if updated_stamina != stamina:
		stamina = updated_stamina
		stamina_updated.emit(stamina, max_stamina)

func _physics_process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	if Input.is_action_pressed("ui_sprint"):
		while stamina >= 25:
			speed = 100
			stamina -= 5
			stamina_updated.emit(stamina, max_stamina)
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50

	var movement = direction * speed * delta

	if !is_attacking:
		move_and_collide(movement)
		play_animations(direction)

	if is_attacking and !$AnimatedSprite2D.is_playing():
		is_attacking = false

func _input(event):
	if event.is_action_pressed("ui_attack"):
		var now = Time.get_ticks_msec()
		# 当冷却时间结束并且有子弹才可以发射
		if now >= bullet_fired_time && ammo_pickup > 0:
			is_attacking = true
			animation = "attack_" + returned_direction(new_direaction)
			$AnimatedSprite2D.play(animation)
			# 设置冷却时间
			bullet_fired_time = now + bullet_reload_time
			# 更新子弹数量
			ammo_pickup -= 1
			ammo_pickups_updated.emit(ammo_pickup)
	elif event.is_action_pressed("ui_consume_health"):
		if health > 0 && health_pickup > 0:
			health_pickup -= 1
			health = min(health + 50, max_health)
			health_updated.emit(health, max_health)
			health_pickups_updated.emit(health_pickup)
	elif event.is_action_pressed("ui_consume_stamina"):
		if stamina > 0 && stamina_pickup > 0:
			stamina_pickup -= 1
			stamina = min(stamina + 50, max_stamina)
			stamina_updated.emit(stamina, max_stamina)
			stamina_pickups_updated.emit(stamina_pickup)

func play_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direaction = direction
		animation = "walk_" + returned_direction(new_direaction)
		$AnimatedSprite2D.play(animation)
	else:
		animation = "idle_" + returned_direction(new_direaction)
		$AnimatedSprite2D.play(animation)

func returned_direction(direction: Vector2):
	var normalized_direction = direction.normalized()
	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		return "side"
	else:
		return ""


func add_pickup(item):
	if item == Pickups.AMMO:
		ammo_pickup += 3
		ammo_pickups_updated.emit(ammo_pickup)
	elif item == Pickups.HEALTH:
		health_pickup += 1
		health_pickups_updated.emit(health_pickup)
	elif item == Pickups.STAMINA:
		stamina_pickup += 1
		stamina_pickups_updated.emit(stamina_pickup)

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

	if $AnimatedSprite2D.animation.begins_with("attack_"):
		var bullet = bullet_scene.instantiate()
		bullet.damage = bullet_damage
		bullet.direction = new_direaction.normalized()
		# 子弹生成位置应该在player位置再向前偏移4-5像素
		bullet.position = position + new_direaction.normalized() * 4
		get_tree().root.get_node("Main").add_child(bullet)
