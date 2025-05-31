extends Node3D


var lane0_queue = []
var lane1_queue = []
var lane2_queue = []
var lane3_queue = []

var lane0_queue_types = []
var lane1_queue_types = []
var lane2_queue_types = []
var lane3_queue_types = []

# blocks are 1.25 in length and top of screen is at z=50. 
# judgement line is at z = 60. 

var lane0_time = []
var lane0_type = []
var in_lane0 = []

var lane1_time = []
var lane1_type = []
var in_lane1 = []

var lane2_time = []
var lane2_type = []
var in_lane2 = []

var lane3_time = []
var lane3_type = []
var in_lane3 = []

var tap_note = preload("res://Scenes/notes/tap.tscn")
var hold_start = preload("res://Scenes/notes/hold_start.tscn")
var hold_middle = preload("res://Scenes/notes/hold_middle.tscn")


var note_speed = 40

var curtime = 200

var offset = -1000.0 / (note_speed/60.0)

func spawn_tap(lane, expected_time):
	var cur_note = tap_note.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	var start_time = expected_time + offset
	var delta = curtime - start_time
	var position_offset = (delta/1000) * note_speed
	cur_note.position.z = 50-position_offset
	cur_note.get_child(0).velocity = Vector3(0, 0, -1 *note_speed)
	add_child(cur_note)
	
func spawn_hold_start(lane, expected_time):
	var cur_note = hold_start.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	var start_time = expected_time + offset
	var delta = curtime - start_time
	var position_offset = (delta/1000) * note_speed
	cur_note.position.z = 50-position_offset
	cur_note.get_child(0).velocity = Vector3(0, 0, -1 *note_speed)
	add_child(cur_note)
	
func spawn_hold_middle(lane, expected_time):
	var cur_note = hold_middle.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	var start_time = expected_time + offset
	var delta = curtime - start_time
	var position_offset = (delta/1000) * note_speed
	cur_note.position.z = 50-position_offset
	cur_note.get_child(0).velocity = Vector3(0, 0, -1 *note_speed)
	add_child(cur_note)
	
func judge_l0():
	if len(lane0_time) < 1:
		return
	var dist =  abs(lane0_time[0] - curtime)
	if dist < 250:
		if 125 < dist:
			print("miss")
		elif 108.3 < dist and dist <= 125:
			print("bad")
		elif 83.3 < dist and dist <= 108.3:
			print('good')
		elif 41.7 < dist and dist <= 83.3:
			print('great')
		elif dist <= 41.7:
			print('perfect')
		lane0_time.pop_front()
		lane0_type.pop_front()
		var front = in_lane0.pop_front()
		if front != null:
			front.queue_free()
	
func judge_l1():
	if len(lane1_time) < 1:
		return
	var dist =  abs(lane1_time[0] - curtime)
	if dist < 250:
		if 125 < dist:
			print("miss")
		elif 108.3 < dist and dist <= 125:
			print("bad")
		elif 83.3 < dist and dist <= 108.3:
			print('good')
		elif 41.7 < dist and dist <= 83.3:
			print('great')
		elif dist <= 41.7:
			print('perfect')
		lane1_time.pop_front()
		lane1_type.pop_front()
		var front = in_lane1.pop_front()
		if front != null:
			front.queue_free()
		
func judge_l2():
	if len(lane2_time) < 1:
		return
	var dist =  abs(lane2_time[0] - curtime)
	if dist < 250:
		if 125 < dist:
			print("miss")
		elif 108.3 < dist and dist <= 125:
			print("bad")
		elif 83.3 < dist and dist <= 108.3:
			print('good')
		elif 41.7 < dist and dist <= 83.3:
			print('great')
		elif dist <= 41.7:
			print('perfect')
		lane2_time.pop_front()
		lane2_type.pop_front()
		var front = in_lane2.pop_front()
		if front != null:
			front.queue_free()
			
func judge_l3():
	if len(lane3_time) < 1:
		return
	var dist =  abs(lane3_time[0] - curtime)
	if dist < 250:
		if 125 < dist:
			print("miss")
		elif 108.3 < dist and dist <= 125:
			print("bad")
		elif 83.3 < dist and dist <= 108.3:
			print('good')
		elif 41.7 < dist and dist <= 83.3:
			print('great')
		elif dist <= 41.7:
			print('perfect')
		lane3_time.pop_front()
		lane3_type.pop_front()
		var front = in_lane3.pop_front()
		if front != null:
			front.queue_free()
		
func generate_queues(path):
	var file = FileAccess.open(path, FileAccess.READ)
	file.get_csv_line()
	while !file.eof_reached():
		var cur_line = file.get_csv_line()
		var x = int(cur_line.get(1))
		var time = int(cur_line.get(3))
		var type = int(cur_line.get(4))
		var end = int(cur_line.get(6))
		if type != 128:
			var lane = int(floor((x * 4)/512))
			if lane == 0:
				lane0_queue.append(time+offset)
				lane0_queue_types.append(0)
				lane0_time.append(time)
				lane0_type.append(0)
			elif lane == 1:
				lane1_queue.append(time+offset)
				lane1_queue_types.append(0)
				lane1_time.append(time)
				lane1_type.append(0)
			elif lane == 2:
				lane2_queue.append(time+offset)
				lane2_queue_types.append(0)
				lane2_time.append(time)
				lane2_type.append(0)
			elif lane == 3:
				lane3_queue.append(time+offset)
				lane3_queue_types.append(0)
				lane3_time.append(time)
				lane3_type.append(0)
		elif type == 128:
			var lane = int(floor((x * 4)/512))
			if lane == 0:
				lane0_queue.append(time+offset)
				lane0_queue_types.append(1)
				lane0_time.append(time)
				lane0_type.append(1)
				for i in range(time+1, end + 1):
					lane0_queue.append(i + offset)
					lane0_queue_types.append(2)
					lane0_time.append(time)
					lane0_type.append(2)
			elif lane == 1:
				lane1_queue.append(time+offset)
				lane1_queue_types.append(1)
				lane1_time.append(time)
				lane1_type.append(1)
				for i in range(time+1, end + 1):
					lane1_queue.append(i + offset)
					lane1_queue_types.append(2)
					lane1_time.append(time)
					lane1_type.append(2)
			elif lane == 2:
				lane2_queue.append(time+offset)
				lane2_queue_types.append(1)
				lane2_time.append(time)
				lane2_type.append(1)
				for i in range(time+1, end + 1):
					lane2_queue.append(i + offset)
					lane2_queue_types.append(2)
					lane2_time.append(time)
					lane2_type.append(2)
			elif lane == 3:
				lane3_queue.append(time+offset)
				lane3_queue_types.append(1)
				lane3_time.append(time)
				lane3_type.append(1)
				for i in range(time+1, end + 1):
					lane3_queue.append(i + offset)
					lane3_queue_types.append(2)
					lane3_time.append(time)
					lane3_type.append(2)
		
func check_and_spawn():
	if len(lane0_queue) > 0:
		if curtime >= lane0_queue[0]:
			var type = lane0_queue_types.pop_front()
			var time = lane0_queue.pop_front()
			if type == 0:
				spawn_tap(0, time-offset)
			elif type == 1:
				spawn_hold_start(0, time-offset)
			elif type == 2:
				spawn_hold_middle(0, time-offset)
	if len(lane1_queue) > 0:
		if curtime >= lane1_queue[0]:
			var type = lane1_queue_types.pop_front()
			var time = lane1_queue.pop_front()
			if type == 0:
				spawn_tap(1, time-offset)
			elif type == 1:
				spawn_hold_start(1, time-offset)
			elif type == 2:
				spawn_hold_middle(1, time-offset)
	if len(lane2_queue) > 0:
		if curtime >= lane2_queue[0]:
			var type = lane2_queue_types.pop_front()
			var time = lane2_queue.pop_front()
			if type == 0:
				spawn_tap(2, time-offset)
			elif type == 1:
				spawn_hold_start(2, time-offset)
			elif type == 2:
				spawn_hold_middle(2, time-offset)
	if len(lane3_queue) > 0:
		if curtime >= lane3_queue[0]:
			var type = lane3_queue_types.pop_front()
			var time = lane3_queue.pop_front()
			if type == 0:
				spawn_tap(3, time-offset)
			elif type == 1:
				spawn_hold_start(3, time-offset)
			elif type == 2:
				spawn_hold_middle(3, time-offset)
		
		

func _physics_process(delta: float) -> void:
	check_and_spawn()
	curtime += delta*1000
	if Input.is_action_just_pressed("lane0"):
		judge_l0()
	if Input.is_action_just_pressed("lane1"):
		judge_l1()
		print(curtime)
	if Input.is_action_just_pressed("lane2"):
		judge_l2()
		print(curtime)
	if Input.is_action_just_pressed("lane3"):
		judge_l3()

func _ready() -> void:
	generate_queues("res://Maps/map1.csv")
	#curtime += offset
	print(curtime)
	print(lane0_queue[0])
	print(lane0_time[0])
	print(lane1_queue[0])
	print(lane1_time[0])
	print(lane2_queue[0])
	print(lane2_time[0])
	print(lane3_queue[0])
	print(lane3_time[0])


func _on_lane_0_counter_body_entered(body: Node3D) -> void:
	in_lane0.push_back(body.get_parent_node_3d())

func _on_lane_0_counter_body_exited(body: Node3D) -> void:
	body.get_parent_node_3d().queue_free()
	lane0_time.pop_front()
	lane0_type.pop_front()

func _on_lane_1_counter_body_entered(body: Node3D) -> void:
	in_lane1.push_back(body.get_parent_node_3d())

func _on_lane_1_counter_body_exited(body: Node3D) -> void:
	body.get_parent_node_3d().queue_free()
	lane1_time.pop_front()
	lane1_type.pop_front()

func _on_lane_2_counter_body_entered(body: Node3D) -> void:
	in_lane2.push_back(body.get_parent_node_3d())

func _on_lane_2_counter_body_exited(body: Node3D) -> void:
	body.get_parent_node_3d().queue_free()
	lane2_time.pop_front()
	lane2_type.pop_front()

func _on_lane_3_counter_body_entered(body: Node3D) -> void:
	in_lane3.push_back(body.get_parent_node_3d())

func _on_lane_3_counter_body_exited(body: Node3D) -> void:
	body.get_parent_node_3d().queue_free()
	lane3_time.pop_front()
	lane3_type.pop_front()
