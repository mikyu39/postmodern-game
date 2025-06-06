extends Node2D

@onready
var text = $Camera2D/UI/TextBox
@onready
var interact_texts = $Camera2D/UI/InteractText

@onready
var player = $Player/CharacterBody2D

var can_psycho = false

var can_interact_npc = false

var can_change_room = false

var is_teleporting = false

var map = 0

var player_dest = Vector2.ZERO

var camera_dest = Vector2.ZERO



@onready 
var scene = preload("res://Scenes/rhythm_game.tscn").instantiate()

func show_text(show):
	for i in range(len(interact_texts.get_children())):
		if i != show:
			interact_texts.get_children()[i].visible = false
		else:
			interact_texts.get_children()[i].visible = true

func hide_text():
	for i in range(len(interact_texts.get_children())):
		interact_texts.get_children()[i].visible = false

func update_interact_npc(blurb, can_detect, in_map):
	text.set_text(blurb)
	can_interact_npc = can_detect
	if can_detect:
		show_text(1)
		map = in_map
	else:
		hide_text()
		text.visible = false
		update_enter_psycho(false)

func update_enter_psycho(show):
	can_psycho = show
	if show:
		show_text(0)
		
func update_change_room(can_move, camera, player):
	if !can_move:
		if is_teleporting:
			is_teleporting = false
		else:
			can_change_room = false
			hide_text()
		
	elif can_move:
		can_change_room = true
		camera_dest = camera
		player_dest = player
		show_text(2)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if can_psycho:
			get_tree().root.add_child(scene)
			# update the hair value to the new scene
			get_node("/root/RhythmGame").set_map(map)
			# free the current scene
			get_node("/root/GameManager").free()
		if can_interact_npc:
			text.visible = true
			text.scroll_text()
			update_enter_psycho(true)
		if can_change_room:
			player.global_position = player_dest
			$Camera2D.position = camera_dest
			is_teleporting = true
		
