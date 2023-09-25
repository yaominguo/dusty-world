extends CharacterBody2D

@export var speed = 50

var animation
var direction: Vector2
var new_direaction = Vector2(0, 1)
var rng = RandomNumberGenerator.new()
var timer = 0
var is_attacking = false
var player

func _ready():
	player = get_tree().root.get_node("Main/Player")
	rng.randomize()

func _physics_process(delta):
	var movement = direction * speed * delta
	var collision = move_and_collide(movement)
	
	if collision != null and collision.get_collider().name != "Player" and collision.get_collider().name != "EnemySpawner" and collision.get_collider().name != "Enemy":
		# 当触碰到非玩家物体，转向，并重置timer
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		timer = rng.randf_range(2, 5)
		play_animations(direction)
	else:
		# 否则触发timeout逻辑
		timer = 0

	if !is_attacking:
		play_animations(direction)

	if $AnimatedSprite2D.animation == "spawn":
		print($AnimatedSprite2D.animation)
		is_attacking = false
		$Timer.start()
		timer = 0

func sync_new_direction():
	if direction != Vector2.ZERO:
		new_direaction = direction.normalized()

func _on_timer_timeout():
	var player_distance = player.position - position

	if player_distance.length() <= 20:
		# 当距离<=20，转向player开始攻击并停止运动
		new_direaction = player_distance.normalized()
		sync_new_direction()
		direction = Vector2.ZERO
	elif player_distance.length() <= 100 and timer == 0:
		# 当距离<=100，追逐
		direction = player_distance.normalized()
		sync_new_direction()
	elif timer == 0:
		# 否则自由行动
		var random_direction = rng.randf()
		if random_direction < 0.05:
			direction = Vector2.ZERO
		elif random_direction < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		sync_new_direction()

func play_animations(_direction: Vector2):
	if _direction != Vector2.ZERO:
		new_direaction = _direction
		animation = "walk_" + returned_direction(new_direaction)
		$AnimatedSprite2D.play(animation)
	else:
		animation = "idle_" + returned_direction(new_direaction)
		$AnimatedSprite2D.play(animation)

func returned_direction(_direction: Vector2):
	var normalized_direction = _direction.normalized()
	if normalized_direction.y >= 0.7:
		return "down"
	elif normalized_direction.y <= -0.7:
		return "up"
	elif normalized_direction.x >= 0.7:
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x <= -0.7:
		$AnimatedSprite2D.flip_h = true
		return "side"
	else:
		return ""
func spawn():
	# create a animation delay
	$AnimatedSprite2D.play("spawn")
	is_attacking = true
