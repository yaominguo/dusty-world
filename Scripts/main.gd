extends Node2D

func _ready():
  $Player.health_updated.connect($UI/HealthBar.update_health)
  $Player.stamina_updated.connect($UI/StaminaBar.update_stamina)
  $Player.ammo_pickups_updated.connect($UI/AmmoAmount.update_ammo_pickup)
  $Player.health_pickups_updated.connect($UI/HealthAmount.update_health_pickup)
  $Player.stamina_pickups_updated.connect($UI/StaminaAmount.update_stamina_pickup)