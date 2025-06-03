extends Panel

@export
var scroll_speed = 0.5

var float_text_pos = 0.0 

func set_text(blurb):
	$Voiceline.text = blurb

func scroll_text():
	$Voiceline.visible_characters = 0
	float_text_pos = 0.0
	
func _process(delta: float) -> void:
	if $Voiceline.visible_characters < len($Voiceline.text):
		float_text_pos += scroll_speed
		$Voiceline.visible_characters = int(float_text_pos)
	
