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

var rep_val = 0

var map = 0

var player_dest = Vector2.ZERO

var camera_dest = Vector2.ZERO

var rng = RandomNumberGenerator.new()

var is_easy = false

var replicant = [-1,1,1,1,1]
var maps = [1,2,3,4,5]

var winning = false

var note_speed = 0

var offset = 0

@onready 
var scene = load("res://Scenes/rhythm_game.tscn").instantiate()

var title = load("res://Scenes/title.tscn")

func show_text(show):
	for i in range(len(interact_texts.get_children())):
		if i != show:
			interact_texts.get_children()[i].visible = false
		else:
			interact_texts.get_children()[i].visible = true

func hide_text():
	for i in range(len(interact_texts.get_children())):
		interact_texts.get_children()[i].visible = false

func update_interact_npc(blurb, can_detect, in_map, rep):
	text.set_text(blurb)
	can_interact_npc = can_detect
	if can_detect:
		show_text(1)
		map = in_map
		rep_val = rep
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
		
func show_results(accuracy):
	var grade = ""
	if accuracy > 0.95: 
		grade = 'S'
	elif accuracy > 0.9:
		grade = 'A'
	elif accuracy > 0.8:
		grade = 'B'
	elif accuracy > 0.7:
		grade = 'C'
	elif accuracy > 0.6: 
		grade = 'D'
	else: 
		grade = 'F'
	
	var text_acc = str((round(accuracy * 10000))/100) + "%"
	print(accuracy)
	
	$Camera2D/Results/Panel/AccVal.text = text_acc
	$Camera2D/Results/Panel/Grade.text = grade
	var changed_rep = (accuracy * rep_val) + rng.randf_range(-0.85, 0.85)
	$Camera2D/Results/Panel/Replicant.text = 'Replicant Status:' + str(round((changed_rep * 10000))/100)
	$Camera2D/Results.visible = true
	
	
func set_game(difficulty, speed, off):
	note_speed = speed
	offset = off
	is_easy = difficulty
	replicant.shuffle()
	maps.shuffle()
	
	print(maps)
	print(replicant)
	
	for i in range(5):
		var node = get_node("NPC" + str(i))
		node.map = maps[i]
		node.rep_val = replicant[i]
		
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if can_psycho:
			get_tree().root.add_child(scene)
			# update the hair value to the new scene
			get_node("/root/RhythmGame").set_map(map, is_easy, note_speed, offset)
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
		

func _on_mark_replicant_item_selected(index: int) -> void:
	print(index)
	print(replicant[index])
	winning = (replicant[index] == -1)


func _on_submit_pressed() -> void:
	$Camera2D/UI/EndUI.visible = true
	if winning: 
		$Camera2D/UI/EndUI/Text.text = "You Win!"
	else:
		$Camera2D/UI/EndUI/Text.text = "You Lose!"
	

func _on_exit_pressed() -> void:
	get_tree().root.add_child(title.instantiate())
	# free the current scene
	get_node("/root/GameManager").queue_free()
