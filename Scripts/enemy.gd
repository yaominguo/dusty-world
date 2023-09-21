extends CharacterBody2D

@export var speed = 50

var direction: Vector2
var new_direaction = Vector2(0, 1)
var rng = RandomNumberGenerator.new()
var timer = 0
var player

func _ready():
  player = get_tree().root.get_node("Main/Player")
  rng.randomize()

func _physics_process(delta):
  var movement = direction * speed * delta
  var collision = move_and_collide(movement)

  if collision != null and collision.get_collider().name != "Player":
    # 当触碰到非玩家物体，转向，并重置timer
    direction = direction.rotated(rng.randf_range(PI/4, PI/2))
    timer = rng.randf_range(2, 5)
  else:
    # 否则触发timeout逻辑
    timer = 0

func _on_timer_timeout():
  var player_distance = player.position - position
  if player_distance.length() <= 20:
    # 当距离<=20，停止运动并且攻击
    new_direaction = player_distance.normalized()
    direction = Vector2.ZERO
  elif player_distance.length() <= 100 and timer == 0:
    # 当距离<=100，追逐
    direction = player_distance.normalized()
  elif timer == 0:
    # 否则自由行动
    var random_direction = rng.randf()
    if random_direction < 0.05:
      direction =Vector2.ZERO
    elif random_direction < 0.1:
      direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
