extends note

class_name hold_start

var game = null

var lane = -1

var checking = false

func save_reference(reference):
	game = reference
	
func set_lane(input):
	self.lane = input
	
func set_checking(input):
	checking = input

func _on_area_3d_area_entered(area: Area3D) -> void:
	var node = area.get_parent_node_3d().get_parent_node_3d()
	if node is hold_middle and checking:
		node.visible = false
		game.register_hold(lane)
		if node != null:
			node.free()
