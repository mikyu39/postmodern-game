extends Node2D

var scene = load("res://Scenes/game.tscn")

var is_easy = true

var note_speed = 43

var offset = 0

func _on_start_pressed() -> void:
	get_tree().root.add_child(scene.instantiate())
	get_node("/root/GameManager").set_game(is_easy, note_speed, offset)
	get_node("/root/Title").queue_free()


func _on_difficulty_pressed() -> void:
	is_easy = !is_easy
	
	if is_easy:
		$Panel/Difficulty.text = "Difficulty: Easy"
	else:
		$Panel/Difficulty.text = "Difficulty: Hard"


func _on_note_speed_value_changed(value: float) -> void:
	note_speed = int(value)
	$Panel/SpeedLabel.text = "Note Speed: " + str(note_speed)


func _on_offset_value_changed(value: float) -> void:
	offset = int(value)
	$Panel/OffsetLabel.text = "Offset: " + str(offset) + " ms"
