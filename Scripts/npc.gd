extends CharacterBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED}
var quest_status = QuestStatus.NOT_STARTED
var dialog_state = 0
var quest_complete = false

var dialog_popup
var player
enum Pickups {AMMO, STAMINA, HEALTH}

@export var npc_name = ""

func _ready():
	dialog_popup = get_tree().root.get_node("Main/Player/UI/DialogPopup")
	player = get_tree().root.get_node("Main/Player")
	$AnimatedSprite2D.play("idle_down")

func dialog(response = ""):
	$AnimatedSprite2D.play("talk_down")
	# 设置对话框的字段
	dialog_popup.npc = self
	dialog_popup.npc_name = str(npc_name)
	# 对话匹配
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialog_state:
				0:
					dialog_state = 1
					dialog_popup.message = "Howdy Partner. I haven't seen anybody round these parts in quite a while. That reminds me, I recently lost my momma's secret recipe book, can you help me find it?"
					dialog_popup.response = "[A] Yes  [B] No"
					dialog_popup.open() # 打开对话框
				1:
					match response:
						"A":
							dialog_state = 2
							dialog_popup.message = "That's mighty kind of you, thanks."
							dialog_popup.response = "[A] Bye"
							dialog_popup.open()
						"B":
							dialog_state = 3
							dialog_popup.message = "Well, I'll be waiting like a tumbleweed 'till you come back."
							dialog_popup.response = "[A] Bye"
							dialog_popup.open()
				2:
					dialog_state = 0
					quest_status = QuestStatus.STARTED
					dialog_popup.close()
					$AnimatedSprite2D.play("idle_down")
				3:
					dialog_state = 0
					dialog_popup.close()
					$AnimatedSprite2D.play("idle_down")
		QuestStatus.STARTED:
			match dialog_state:
				0:
					dialog_state = 1
					dialog_popup.message = "Found that book yet?"
					if quest_complete:
							dialog_popup.response = "[A] Yes  [B] No"
					else:
							dialog_popup.response = "[A] No"
					dialog_popup.open()
				1:
					if quest_complete and response == "A":
						dialog_state = 2
						dialog_popup.message = "Yeehaw! Now I can make cat-eye soup. Here, take this."
						dialog_popup.response = "[A] Bye"
						dialog_popup.open()
					else:
						dialog_state = 3
						dialog_popup.message = "I'm so hungry, please hurry..."
						dialog_popup.response = "[A] Bye"
						dialog_popup.open()
				2:
					dialog_state = 0
					quest_status = QuestStatus.COMPLETED
					dialog_popup.close()
					$AnimatedSprite2D.play("idle_down")
					# Add potion and XP to the player.
					player.add_pickup(Pickups.AMMO)
					player.update_xp(50)
				3:
					dialog_state = 0
					dialog_popup.close()
					$AnimatedSprite2D.play("idle_down")
		QuestStatus.COMPLETED:
			match dialog_state:
				0:
					dialog_state = 1
					dialog_popup.message = "Nice seeing you again partner!"
					dialog_popup.response = "[A] Bye"
					dialog_popup.open()
				1:
					dialog_state = 0
					dialog_popup.close()
					$AnimatedSprite2D.play("idle_down")
