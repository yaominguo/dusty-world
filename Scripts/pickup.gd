@tool

extends Area2D

enum Pickups {AMMO, STAMINA, HEALTH}
@export var item: Pickups

var ammo_texture = preload("res://Assets/Icons/shard_01i.png")
var stamina_texture = preload("res://Assets/Icons/potion_02b.png")
var health_texture = preload("res://Assets/Icons/potion_02c.png")

func _process(_delta):
	if Engine.is_editor_hint():
		if item == Pickups.AMMO:
			$Sprite2D.set_texture(ammo_texture)
		elif item == Pickups.HEALTH:
			$Sprite2D.set_texture(health_texture)
		elif item == Pickups.STAMINA:
			$Sprite2D.set_texture(stamina_texture)

func _ready():
	if not Engine.is_editor_hint():
		if item == Pickups.AMMO:
			$Sprite2D.set_texture(ammo_texture)
		elif item == Pickups.HEALTH:
			$Sprite2D.set_texture(health_texture)
		elif item == Pickups.STAMINA:
			$Sprite2D.set_texture(stamina_texture)

func _on_body_entered(body:Node2D):
	if body.name == "Player":
		body.add_pickup(item)
		get_tree().queue_delete(self)
