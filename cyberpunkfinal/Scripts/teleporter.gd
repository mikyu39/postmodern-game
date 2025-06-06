extends Node2D

@export
var camera_dest = Vector2.ZERO

@export 
var player_dest = Vector2.ZERO

@onready
var gm = get_parent()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.get_parent().name) == "Player":
		gm.update_change_room(false, camera_dest, player_dest)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.get_parent().name) == "Player":
		gm.update_change_room(true, camera_dest, player_dest)
