extends Node2D


func _on_button_pressed() -> void:
	visible = false


func _on_button_button_down() -> void:
	visible = false

func _on_button_toggled(toggled_on: bool) -> void:
	visible = false
