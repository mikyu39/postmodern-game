extends Node2D

@onready
var text = $Camera2D/UI/TextBox
@onready
var interact_texts = $Camera2D/UI/InteractText

@onready
var player = $Player/CharacterBody2D

var can_psycho = false

var can_interact_npc = false

func show_text(show):
	for i in range(len(interact_texts.get_children())):
		if i != show:
			interact_texts.get_children()[i].visible = false
		else:
			interact_texts.get_children()[i].visible = true

func hide_text():
	for i in range(len(interact_texts.get_children())):
		interact_texts.get_children()[i].visible = false

func update_interact_npc(blurb, can_detect):
	text.set_text(blurb)
	can_interact_npc = can_detect
	if can_detect:
		show_text(1)
	else:
		hide_text()
		text.visible = false
		update_enter_psycho(false)

func update_enter_psycho(show):
	can_psycho = show
	if show:
		show_text(0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if can_interact_npc:
			text.visible = true
			text.scroll_text()
			update_enter_psycho(true)
