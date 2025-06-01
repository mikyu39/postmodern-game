extends note

class_name hold_start

var game = null

var lane = -1

func save_reference(reference):
	game = reference
	
func set_lane(lane):
	self.lane = lane

func _on_area_3d_area_entered(area: Area3D) -> void:
	var node = area.get_parent_node_3d().get_parent_node_3d()
	if node is hold_middle:
		game.register_hold(lane)
		if node != null:
			node.free()
