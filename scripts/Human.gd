extends KinematicBody

const MOUSE_SENSITIVITY = 0.002
const MOVEMENT_SPEED = 1.5
const TOTAL_DISTANCE_TILL_FOOTSTEP = 50.0

export(Array, NodePath) var highlightable_paths

onready var eye_camera = $EyeCamera
onready var eye_ray = $EyeCamera/EyeRay
onready var hand_spatial = $HandSpatial
onready var footstep_audio = $FootstepAudio
onready var take_audio = $TakeAudio
onready var drop_audio = $DropAudio
onready var wait_timer = $WaitTimer

var distance_till_footstep = TOTAL_DISTANCE_TILL_FOOTSTEP
var can_move = true
var can_pan = true

var highlightables = []

func _ready():
	wait_timer.connect("timeout", self, "release")
	for highlightable_path in highlightable_paths:
		highlightables.append(get_node(highlightable_path))

func _input(event):
	if can_pan and (event is InputEventMouseMotion or event is InputEventScreenDrag):
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		eye_camera.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		eye_camera.rotation.x = clamp(eye_camera.rotation.x, -1.2, 1.2)
	if can_move and event.is_action_pressed("interact"):
		var collider = eye_ray.get_collider()
		if collider and collider.has_method("interact"):
			eye_ray.get_collider().interact(self)

func _process(delta):
	var collider = eye_ray.get_collider()
	for highlightable in highlightables:
		highlightable.set_highlight(collider == highlightable)

func _physics_process(delta):
	if can_move:
		var direction = Vector3(0, 0, 0)
		if Input.is_action_pressed("move_north"):
			direction.z -= 1
		if Input.is_action_pressed("move_south"):
			direction.z += 1
		if Input.is_action_pressed("move_east"):
			direction.x += 1
		if Input.is_action_pressed("move_west"):
			direction.x -= 1
		direction = direction.rotated(Vector3.UP, rotation.y).normalized()
		distance_till_footstep -= move_and_slide(direction * MOVEMENT_SPEED).length()
		if distance_till_footstep < 0.0:
			footstep_audio.play()
			distance_till_footstep = TOTAL_DISTANCE_TILL_FOOTSTEP

func wait(time):
	wait_timer.wait_time = time
	wait_timer.start()
	can_move = false
	can_pan = false

func release():
	wait_timer.stop()
	can_move = true
	can_pan = true

func take(item):
	hand_spatial.add_child(item)
	take_audio.play()

func drop():
	var item = hand_spatial.get_children()[0]
	hand_spatial.remove_child(item)
	drop_audio.play()
	return item

func is_holding_item():
	return hand_spatial.get_child_count() > 0
