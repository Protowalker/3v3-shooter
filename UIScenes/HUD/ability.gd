extends VBoxContainer
class_name AbilityUI

@export var ability: Ability

@onready var cooldown_panel: PanelContainer =  %Cooldown
@onready var progress_bar: ProgressBar = %Cooldown/ProgressBar
@onready var label: Label = %Cooldown/Label

var is_on_cooldown := false

func _ready() -> void:
	cooldown_panel.visible = false

func _process(delta: float) -> void:
	match is_on_cooldown:
		true: 
			_on_cooldown_process(delta)
		false:
			_off_cooldown_process(delta)
	
func _on_cooldown_process(_delta: float) -> void:
	progress_bar.value = (ability.remaining_cooldown / ability.cooldown) * 100.0
	label.text = str(roundf(ability.remaining_cooldown))
	if ability.remaining_cooldown == 0.0:
		cooldown_panel.visible = false
		is_on_cooldown = false
	
func _off_cooldown_process(_delta: float) -> void:
	if ability.remaining_cooldown > 0.0:
		cooldown_panel.visible = true
		is_on_cooldown = true
