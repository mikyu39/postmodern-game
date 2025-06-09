extends Node2D

var scene = load("res://Scenes/game.tscn")

var is_easy = true

func _on_start_pressed() -> void:
	get_tree().root.add_child(scene.instantiate())
	get_node("/root/GameManager").set_game(is_easy)
	get_node("/root/Title").queue_free()


func _on_difficulty_pressed() -> void:
	is_easy = !is_easy
	
	if is_easy:
		$Panel/Difficulty.text = "Difficulty: Easy"
	else:
		$Panel/Difficulty.text = "Difficulty: Hard"
