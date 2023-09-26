extends ColorRect

@onready var value = $Value
@onready var value2 = $Value2

func update_xp(xp):
	value.text = str(xp)

func update_xp_requirements(xp_requirements):
	value2.text = "/" + str(xp_requirements)
