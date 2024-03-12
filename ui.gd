extends MarginContainer

@onready var shield_bar = $HBoxContainer/ShieldBar
@onready var score_counter = $HBoxContainer/ScoreCounter
# Called when the node enters the scene tree for the first time.
func _update_score(value):
	score_counter.display_digits(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update_shield(max_value, value):
	shield_bar.max_value = max_value
	shield_bar.value = value
