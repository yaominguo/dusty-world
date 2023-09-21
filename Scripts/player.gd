extends CharacterBody2D

signal health_updated
signal stamina_updated

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

func _ready():
	health_updated.emit(health, max_health)
	stamina_updated.emit(stamina, max_stamina)

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

	var movement = speed * direction * delta

	if !is_attacking:
		move_and_collide(movement)
		play_animations(direction)

	if is_attacking and !$AnimatedSprite2D.is_playing():
		is_attacking = false

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		animation = "attack_" + returned_direction(new_direaction)
		$AnimatedSprite2D.play(animation)

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
		return "side"


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
