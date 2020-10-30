extends Spatial

const WAIT_TIME = 5

onready var instruction = $Instruction
onready var instruction_timer = $Instruction/InstructionTimer
onready var human = $Human
onready var robot = $Robot
onready var stove = $Stove
onready var shelf = $Shelf

var is_waiting_lookaround = false
var is_waiting_shelf = false
var is_waiting_pan = false
var is_waiting_transfer = false

func _ready():
	_step_1()

func _input(event):
	if is_waiting_lookaround:
		if event is InputEventMouseMotion:
			_step_4()

func _process(delta):
	if is_waiting_shelf:
		if human.global_transform.origin.distance_to(shelf.global_transform.origin) < 1.5:
			_step_5()
	if is_waiting_pan:
		if human.is_holding_item():
			_step_6()
	if is_waiting_transfer:
		if not human.is_holding_item():
			_step_7()

func _step_1():
	human.can_move = false
	human.can_pan = false
	instruction.visible = true
	instruction.text = "Thank you for taking your time to take part in this experiment."
	instruction_timer.connect("timeout", self, "_step_2")
	instruction_timer.wait_time = WAIT_TIME
	instruction_timer.start()

func _step_2():
	instruction.text = "We will now walk you through the controls."
	instruction_timer.disconnect("timeout", self, "_step_2")
	instruction_timer.connect("timeout", self, "_step_3")
	instruction_timer.wait_time = WAIT_TIME
	instruction_timer.start()

func _step_3():
	is_waiting_lookaround = true
	human.can_pan = true
	instruction.text = "Try moving your mouse to look around the room."
	instruction_timer.disconnect("timeout", self, "_step_3")

func _step_4():
	is_waiting_lookaround = false
	is_waiting_shelf = true
	human.can_move = true
	human.eye_ray.cast_to.z = -1.5
	instruction.text = "Good job. Now try using WASD to move towards the shelf."

func _step_5():
	is_waiting_shelf = false
	is_waiting_pan = true
	instruction.text = "Excellent. You can pick up the pan by clicking on it."

func _step_6():
	is_waiting_pan = false
	is_waiting_transfer = true
	instruction.text = "Nice. Now put the pan on the stove by clicking on the stove."

func _step_7():
	is_waiting_transfer = false
	instruction.text = "Awesome. You will be moved to the experiment soon."
	instruction_timer.connect("timeout", self, "_step_8")
	instruction_timer.wait_time = WAIT_TIME
	instruction_timer.start()

func _step_8():
	get_tree().change_scene("res://scenes/Experiment.tscn")
