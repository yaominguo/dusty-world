extends Popup

signal dialog_opened()
signal dialog_closed()

var npc_name: set = npc_name_set
var message: set = message_set
var response: set = response_set

var npc

# 关闭状态不接受input
func _ready():
	set_process_input(false)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			npc.dialog("A")
		elif event.pressed and event.keycode == KEY_B:
			npc.dialog("B")

func npc_name_set(new_value):
	npc_name = new_value
	$Dialog/NPC.text = new_value

func message_set(new_value):
	message = new_value
	$Dialog/Message.text = new_value

func response_set(new_value):
	response = new_value
	$Dialog/Response.text = new_value

# 打开对话
func open():
	popup()
	dialog_opened.emit()

# 关闭对话
func close():
	set_process_input(false)
	hide()
	dialog_closed.emit()

func _on_animation_player_animation_finished(_anim_name):
	set_process_input(true)
