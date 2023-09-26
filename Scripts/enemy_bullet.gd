extends Area2D

var tilemap
var speed = 80
var direction: Vector2
var damage

func _ready():
	tilemap = get_tree().root.get_node("Main/Map")

func _process(delta):
	position = position + speed * delta * direction


func _on_body_entered(body):
	if body.name == "Enemy":
		return
	if body.name == "Map":
		# 忽略与water的碰撞
		if tilemap.get_layer_name(0):
			return
	if body.name.find("Player") >= 0:
		body.hit(damage)

	direction = Vector2.ZERO
	$AnimatedSprite2D.play("impact")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "impact":
		get_tree().queue_delete(self)

func _on_timer_timeout():
	$AnimatedSprite2D.play("impact")
