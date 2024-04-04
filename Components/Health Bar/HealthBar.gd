extends VBoxContainer
class_name Healthbar

var health := 200.0
var max_health := 200.0

@onready var progress_bar: ProgressBar = $ProgressBar

func _on_health_changed(health: float, max_health: float) -> void:
	health = health
	max_health = max_health
	progress_bar.value = health
	progress_bar.max_value = max_health
	print("Test")
