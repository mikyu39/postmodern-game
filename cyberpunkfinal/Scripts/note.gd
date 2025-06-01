extends Node3D

class_name note

var hit_time = 0

var note_type = -1

func set_time(time):
	hit_time = time

func set_type(type):
	note_type = type
	
func get_time():
	return hit_time

func get_type():
	return note_type
