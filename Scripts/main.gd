extends Node2D

func _ready():
  $Player.health_updated.connect($UI/HealthBar.update_health)
  $Player.stamina_updated.connect($UI/StaminaBar.update_stamina)