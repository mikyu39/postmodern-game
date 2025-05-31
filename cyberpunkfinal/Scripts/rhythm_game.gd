extends Node3D

# blocks are 1.25 in length and top of screen is at z=50. 
# judgement line is at z = 60. 

var lane0_time = [0,]
var lane0_type = [1,]
var in_lane0 = []

var lane1_time = [0,]
var lane1_type = [1,]
var in_lane1 = []

var lane2_time = [0,]
var lane2_type = [1,]
var in_lane2 = []

var lane3_time = [0,]
var lane3_type = [1,]
var in_lane3 = []

var tap_note = preload("res://Scenes/notes/tap.tscn")

var note_speed = 40

var curtime = 0

func spawn_tap(lane):
	var cur_note = tap_note.instantiate()
	cur_note.position.x = 3.75 - (lane * 2.5)
	cur_note.position.z = 50
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
		in_lane0.pop_front().queue_free()
	
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
		in_lane1.pop_front().queue_free()
		
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
		in_lane2.pop_front().queue_free()
			
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
		in_lane3.pop_front().queue_free()

func _physics_process(delta: float) -> void:
	curtime += delta*1000
	if Input.is_action_just_pressed("lane0"):
		judge_l0()
		print(curtime)
	if Input.is_action_just_pressed("lane1"):
		judge_l1()
		print(curtime)
	if Input.is_action_just_pressed("lane2"):
		judge_l2()
		print(curtime)
	if Input.is_action_just_pressed("lane3"):
		judge_l3()
		print(curtime)

func _ready() -> void:
	curtime -= 1000.0 / (note_speed/60.0)
	#load stuff here
	spawn_tap(0)
	spawn_tap(1)
	spawn_tap(2)
	spawn_tap(3)


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
