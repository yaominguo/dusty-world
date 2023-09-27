extends Area2D

var npc

func _ready():
	npc = get_tree().root.get_node("Main/NPC")

func _on_body_entered(body:Node2D):
	if body.name == "Player":
		print("Quest item obtained!")
		get_tree().queue_delete(self)
		npc.quest_complete = true