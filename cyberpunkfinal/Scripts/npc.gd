extends Node2D

@export var version = 0

@export var blurb = ""

var gm

@export var map = 1

@export var rep_val = 0

func _ready() -> void:
	$AnimatedSprite2D.play("idle_" + str(version))
	gm = get_parent()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.get_parent().name) == "Player":
		gm.update_interact_npc(blurb, true, map, rep_val)
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	gm.update_interact_npc(blurb, false, map, rep_val)
	
