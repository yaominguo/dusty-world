extends Node2D

@export var spawn_area: Rect2 = Rect2(150, 150, 500, 500)
@export var max_enemies = 20
@export var existing_enemies = 5

var tilemap
var enemy_count = 0
var enemy_scene = load("res://Scenes/enemy.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	tilemap = get_tree().root.get_node("Main/Map")
	rng.randomize()

	for i in range(existing_enemies):
		spawn_enemy()
	enemy_count = existing_enemies

func valid_spawn_location(position: Vector2):
	# 0 = water, 1 = sand, 2 = grass, 3 = foliage, etc
	# enemy 只生成在sand或grass上
	var valid_location = (tilemap.get_layer_name(1)) || (tilemap.get_layer_name(2))
	return valid_location

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.name = "Enemy"

	enemy.death.connect(_on_enemty_death)

	var valid_location = false
	while !valid_location:
		enemy.position.x = spawn_area.position.x + rng.randf_range(0, spawn_area.size.x)
		enemy.position.y = spawn_area.position.y + rng.randf_range(0, spawn_area.size.y)
		valid_location = valid_spawn_location(enemy.position)
	enemy.spawn()

func _on_timer_timeout():
	# 当enemy数量不足，每秒创建1个
	if enemy_count < max_enemies:
		spawn_enemy()
		enemy_count += 1

func _on_enemty_death():
	enemy_count -= 1
