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

var hold_l0 = false
var hold_l1 = false
var hold_l2 = false
var hold_l3 = false

var tap_note = preload("res://Scenes/notes/tap.tscn")
var hold_front = preload("res://Scenes/notes/hold_start.tscn")
var hold_mid = preload("res://Scenes/notes/hold_middle.tscn")

@export
var note_speed = 0

@export
var timer_offset = 0

var curtime = 0

var offset = 0

var hold_sound_cd = 75

var last_played_hold = -hold_sound_cd

const hold_note_offset = 24

@export
var map = ""

var combo = 0

var max_combo = 0

var max_score = 0

var score = 0

var t_judge = 1.0

var t_combo = 1.0

var scene = preload("res://Scenes/game.tscn").instantiate()

func spawn_tap(lane, start_time):
	var cur_note = tap_note.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	var delta = curtime - start_time
	var position_offset = (delta/1000) * note_speed
	cur_note.position.z = 50-position_offset
	cur_note.set_time(start_time - offset)
	cur_note.set_type(0)
	cur_note.get_child(0).velocity = Vector3(0, 0, -1 *note_speed)
	add_child(cur_note)
	
func spawn_hold_start(lane, start_time):
	var cur_note = hold_front.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	var delta = curtime - start_time
	var position_offset = (delta/1000) * note_speed
	cur_note.position.z = 50-position_offset
	cur_note.set_time(start_time - offset)
	cur_note.set_type(1)
	cur_note.set_lane(lane)
	cur_note.save_reference(self)
	cur_note.get_child(0).velocity = Vector3(0, 0, -1 *note_speed)
	add_child(cur_note)
	
func spawn_hold_middle(lane, start_time):
	var cur_note = hold_mid.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	var delta = curtime - start_time
	var position_offset = (delta/1000) * note_speed
	cur_note.position.z = 50-position_offset
	cur_note.set_time(start_time - offset)
	cur_note.set_type(2)
	cur_note.get_child(0).velocity = Vector3(0, 0, -1 * note_speed)
	add_child(cur_note)

func show_judgement(judge):
	$Camera3D/Control/Judgement.text = judge
	$Camera3D/Control/Judgement.scale = Vector2(0.6, 0.6)
	t_judge = 0.6
	
func show_combo(combo):
	$Camera3D/Control/Combo/ComboNum.visible = (combo > 0)
	$Camera3D/Control/Combo/ComboLabel.visible = (combo > 0)
	$Camera3D/Control/Combo/ComboNum.text = str(combo)
	$Camera3D/Control/Combo/ComboNum.scale = Vector2(0.6, 0.6)
	t_combo = 0.6
	
func judge_time(dist):
	var judgement = ""
	if 125 < dist:
		judgement = "Miss"
		combo = 0
	elif 108.3 < dist and dist <= 125:
		judgement = "Bad"
		combo = 0
		score += 1
	elif 83.3 < dist and dist <= 108.3:
		judgement = 'Good'
		combo = 0
		score += 2
	elif 41.7 < dist and dist <= 83.3:
		judgement = 'Great'
		combo += 1
		score += 3
	elif dist <= 41.7:
		judgement = 'Perfect'
		combo += 1
		score += 4
	max_score += 4
	show_judgement(judgement)
	show_combo(combo)
	$TapSoundPlayer.play()

func judge_l0():
	if in_lane0.is_empty():
		return
	var type = in_lane0[0].get_type()
	var time = in_lane0[0].get_time()
	var dist = abs(time - curtime)
	if type == 0:
		if dist < 150 and Input.is_action_just_pressed("lane0"):
			var cur_note = in_lane0.pop_front()
			judge_time(dist)
			cur_note.visible = false
			cur_note.free()
	elif type == 1:
		if dist < 150 and Input.is_action_just_pressed("lane0"):
			var cur_note = in_lane0[0]
			judge_time(dist)
			cur_note.get_child(0).velocity = Vector3.ZERO
			hold_l0 = true
			cur_note.set_checking(true)
		elif Input.is_action_just_released("lane0") and hold_l0:
			hold_l0 = false
			var cur_note = in_lane0.pop_front()
			while !in_lane0.size() == 0 and (in_lane0[0] == null or in_lane0[0].get_type() == 2):
				var middle = in_lane0[0]
				if is_instance_valid(middle):
					if middle.get_type() == 1:
						break
					middle.free()
				in_lane0.pop_front()
			cur_note.free()
			
func judge_l1():
	if in_lane1.is_empty():
		return
	var type = in_lane1[0].get_type()
	var time = in_lane1[0].get_time()
	var dist = abs(time - curtime)
	if type == 0:
		if dist < 150 and Input.is_action_just_pressed("lane1"):
			var cur_note = in_lane1.pop_front()
			judge_time(dist)
			cur_note.visible = false
			cur_note.free()
	elif type == 1:
		if dist < 150 and Input.is_action_just_pressed("lane1"):
			var cur_note = in_lane1[0]
			judge_time(dist)
			cur_note.get_child(0).velocity = Vector3.ZERO
			hold_l1 = true
			cur_note.set_checking(true)
		elif Input.is_action_just_released("lane1") and hold_l1:
			hold_l1 = false
			var cur_note = in_lane1.pop_front()
			while !in_lane1.size() == 0 and (in_lane1[0] == null or in_lane1[0].get_type() == 2):
				var middle = in_lane1[0]
				if is_instance_valid(middle):
					if middle.get_type() == 1:
						break
					middle.free()
				in_lane1.pop_front()
			cur_note.free()
		
func judge_l2():
	if in_lane2.is_empty():
		return
	var type = in_lane2[0].get_type()
	var time = in_lane2[0].get_time()
	var dist = abs(time - curtime)
	if type == 0:
		if dist < 150 and Input.is_action_just_pressed("lane2"):
			var cur_note = in_lane2.pop_front()
			judge_time(dist)
			cur_note.visible = false
			cur_note.free()
	elif type == 1:
		if dist < 150 and Input.is_action_just_pressed("lane2"):
			var cur_note = in_lane2[0]
			judge_time(dist)
			cur_note.get_child(0).velocity = Vector3.ZERO
			hold_l2 = true
			cur_note.set_checking(true)
		elif Input.is_action_just_released("lane2") and hold_l2:
			hold_l2 = false
			var cur_note = in_lane2.pop_front()
			while !in_lane2.size() == 0 and (in_lane2[0] == null or in_lane2[0].get_type() == 2):
				var middle = in_lane2[0]
				if is_instance_valid(middle):
					if middle.get_type() == 1:
						break
					middle.free()
				in_lane2.pop_front()
			cur_note.free()
			
func judge_l3():
	if in_lane3.is_empty():
		return
	var type = in_lane3[0].get_type()
	var time = in_lane3[0].get_time()
	var dist = abs(time - curtime)
	if type == 0:
		if dist < 150 and Input.is_action_just_pressed("lane3"):
			var cur_note = in_lane3.pop_front()
			judge_time(dist)
			cur_note.visible = false
			cur_note.free()
	elif type == 1:
		if dist < 150 and Input.is_action_just_pressed("lane3"):
			var cur_note = in_lane3[0]
			judge_time(dist)
			cur_note.get_child(0).velocity = Vector3.ZERO
			hold_l3 = true
			cur_note.set_checking(true)
		elif Input.is_action_just_released("lane3") and hold_l3:
			hold_l3 = false
			var cur_note = in_lane3.pop_front()
			while !in_lane3.size() == 0 and (in_lane3[0] == null or in_lane3[0].get_type() == 2):
				var middle = in_lane3[0]
				if is_instance_valid(middle):
					if middle.get_type() == 1:
						break
					middle.free()
				in_lane3.pop_front()
			cur_note.free()
		
func generate_queues(path):
	var file = FileAccess.open(path, FileAccess.READ)
	file.get_csv_line()
	while file.get_position() < file.get_length():
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
				for i in range(time+hold_note_offset, end + 1, hold_note_offset):
					lane0_queue.append(i + offset)
					lane0_queue_types.append(2)
					lane0_time.append(time)
					lane0_type.append(2)
			elif lane == 1:
				lane1_queue.append(time+offset)
				lane1_queue_types.append(1)
				lane1_time.append(time)
				lane1_type.append(1)
				for i in range(time+hold_note_offset, end + 1, hold_note_offset):
					lane1_queue.append(i + offset)
					lane1_queue_types.append(2)
					lane1_time.append(time)
					lane1_type.append(2)
			elif lane == 2:
				lane2_queue.append(time+offset)
				lane2_queue_types.append(1)
				lane2_time.append(time)
				lane2_type.append(1)
				for i in range(time+hold_note_offset, end + 1, hold_note_offset):
					lane2_queue.append(i + offset)
					lane2_queue_types.append(2)
					lane2_time.append(time)
					lane2_type.append(2)
			elif lane == 3:
				lane3_queue.append(time+offset)
				lane3_queue_types.append(1)
				lane3_time.append(time)
				lane3_type.append(1)
				for i in range(time+hold_note_offset, end + 1, hold_note_offset):
					lane3_queue.append(i + offset)
					lane3_queue_types.append(2)
					lane3_time.append(time)
					lane3_type.append(2)
		
func check_and_spawn():
	if len(lane0_queue) > 0:
		if curtime >= lane0_queue[0]:
			#print(lane0_queue[0])
			#print(lane0_time[0])
			#print(curtime)
			#print("--------")
			var type = lane0_queue_types.pop_front()
			var time = lane0_queue.pop_front()
			if type == 0:
				spawn_tap(0, time)
			elif type == 1:
				spawn_hold_start(0, time)
			elif type == 2:
				spawn_hold_middle(0, time)
	if len(lane1_queue) > 0:
		if curtime >= lane1_queue[0]:
			var type = lane1_queue_types.pop_front()
			var time = lane1_queue.pop_front()
			if type == 0:
				spawn_tap(1, time)
			elif type == 1:
				spawn_hold_start(1, time)
			elif type == 2:
				spawn_hold_middle(1, time)
	if len(lane2_queue) > 0:
		if curtime >= lane2_queue[0]:
			var type = lane2_queue_types.pop_front()
			var time = lane2_queue.pop_front()
			if type == 0:
				spawn_tap(2, time)
			elif type == 1:
				spawn_hold_start(2, time)
			elif type == 2:
				spawn_hold_middle(2, time)
	if len(lane3_queue) > 0:
		if curtime >= lane3_queue[0]:
			var type = lane3_queue_types.pop_front()
			var time = lane3_queue.pop_front()
			if type == 0:
				spawn_tap(3, time)
			elif type == 1:
				spawn_hold_start(3, time)
			elif type == 2:
				spawn_hold_middle(3, time)
		
func register_hold(lane):
	if Input.is_action_pressed("lane" + str(lane)):
		if curtime - last_played_hold >= hold_sound_cd:
			judge_time(0)
			$HoldSoundPlayer.play()
			last_played_hold = curtime
		
func set_map(in_map):
	map = "map" + str(in_map)
	print(map)
	generate_queues("res://Maps/"+map+".csv")
	$MusicPlayer.stream = load("res://Assets/Audio/"+map+".mp3")
	curtime = 0
	$MusicPlayer.play()
	
func _physics_process(delta: float) -> void:
	t_judge += 0.1 * delta
	
	t_judge = (1 - cos(PI * t_judge)) / 2
	
	$Camera3D/Control/Judgement.scale = $Camera3D/Control/Judgement.scale.lerp(Vector2i(1, 1), t_judge)
	
	t_combo += 0.1 * delta
	
	t_combo = (1 - cos(PI * t_combo)) / 2
	
	$Camera3D/Control/Combo/ComboNum.scale = $Camera3D/Control/Combo/ComboNum.scale.lerp(Vector2i(1, 1), t_combo)
	
	check_and_spawn()
	curtime += delta*1000
	judge_l0()
	judge_l1()
	judge_l2()
	judge_l3()
	
	if in_lane0.is_empty() and in_lane1.is_empty() and in_lane2.is_empty() and in_lane3.is_empty():
		if lane0_queue.is_empty() and lane1_queue.is_empty() and lane2_queue.is_empty() and lane3_queue.is_empty():
			print(scene)
			get_tree().root.add_child(scene)
			# update the hair value to the new scene
			get_node("/root/GameManager").show_results(float(score)/(max_score))
			# free the current scene
			get_node("/root/RhythmGame").free()
	
func _ready() -> void:
	scene = load("res://Scenes/game.tscn").instantiate()
	curtime += timer_offset
	offset = -1000.0 / (note_speed/60.0)
	$TapSoundPlayer.stream = load("res://Assets/Audio/hitsounds/se_live_perfect.mp3")
	$HoldSoundPlayer.stream = load("res://Assets/Audio/hitsounds/se_live_connect.mp3")

func _on_lane_0_counter_area_entered(area: Area3D) -> void:
	in_lane0.push_back(area.get_parent_node_3d().get_parent_node_3d())


func _on_lane_0_counter_area_exited(area: Area3D) -> void:
	var node = area.get_parent_node_3d().get_parent_node_3d()
	if !in_lane0.is_empty():
		if node == in_lane0[0]:
			lane0_time.pop_front()
			lane0_type.pop_front()
			in_lane0.pop_front()
			node.queue_free()


func _on_lane_1_counter_area_entered(area: Area3D) -> void:
	in_lane1.push_back(area.get_parent_node_3d().get_parent_node_3d())
	var node = area.get_parent_node_3d().get_parent_node_3d()


func _on_lane_1_counter_area_exited(area: Area3D) -> void:
	var node = area.get_parent_node_3d().get_parent_node_3d()
	if !in_lane1.is_empty():
		if node == in_lane1[0]:
			lane1_time.pop_front()
			lane1_type.pop_front()
			in_lane1.pop_front()
			node.queue_free()


func _on_lane_2_counter_area_entered(area: Area3D) -> void:
	in_lane2.push_back(area.get_parent_node_3d().get_parent_node_3d())

func _on_lane_2_counter_area_exited(area: Area3D) -> void:
	var node = area.get_parent_node_3d().get_parent_node_3d()
	if !in_lane2.is_empty():
		if node == in_lane2[0]:
			lane2_time.pop_front()
			lane2_type.pop_front()
			in_lane2.pop_front()
			node.queue_free()


func _on_lane_3_counter_area_entered(area: Area3D) -> void:
	in_lane3.push_back(area.get_parent_node_3d().get_parent_node_3d())


func _on_lane_3_counter_area_exited(area: Area3D) -> void:
	var node = area.get_parent_node_3d().get_parent_node_3d()
	if !in_lane3.is_empty():
		if node == in_lane3[0]:
			lane3_time.pop_front()
			lane3_type.pop_front()
			in_lane3.pop_front()
			node.queue_free()
