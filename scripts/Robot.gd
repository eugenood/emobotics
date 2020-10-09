extends KinematicBody

signal delivered

enum Emotion { NONE, HAPPY, SAD, WINK }

export(NodePath) var hand_spatial_path
export(NodePath) var sink_path

export(bool) var is_sacarstic = false

export(Emotion) var emotion

onready var robot_animation = $RobotAnimation
onready var click_audio = $ClickAudio
onready var failing_audio = $FailingAudio
onready var robot_emote = $RobotMesh/Hook/Screen/RobotEmote

onready var hand_spatial = get_node(hand_spatial_path)
onready var sink = get_node(sink_path)

var none_emote = preload("res://images/emotes/None.png")
var happy_emote = preload("res://images/emotes/Happy.png")
var sad_emote = preload("res://images/emotes/Sad.png")
var wink_emote = preload("res://images/emotes/Wink.png")

var is_delivering = false
var is_failing = false
var has_failed = false
var num_delivered = 0

func _ready():
	robot_animation.connect("animation_finished", self, "_on_animation_finished")
	robot_animation.connect("animation_started", self, "_on_animation_started")

func _on_animation_started(anim_name):
	if anim_name == "failing":
		_on_failing_started()

func _on_animation_finished(anim_name):
	if anim_name == "delivering":
		_on_delivering_finished()
	if anim_name == "failing":
		_on_failing_finished()
	if anim_name == "succeeding":
		_on_succeeding_finished()
	if anim_name == "returning":
		_on_returning_finished()

func _on_delivering_finished():
	if num_delivered != 1:
		robot_animation.play("succeeding")
		_show_emotion(Emotion.HAPPY)
	else:
		failing_audio.play()
		robot_animation.play("failing")
		_show_emotion(Emotion.WINK if is_sacarstic else Emotion.SAD)

func _on_succeeding_finished():
	var plate = drop()
	sink.take(plate, "robot")
	robot_animation.play("returning")

func _on_failing_started():
	is_failing = true

func _on_failing_finished():
	robot_animation.play("failing")
	failing_audio.play()

func _on_returning_finished():
	num_delivered += 1
	is_delivering = false
	robot_animation.play("idling")

func _deliver_for(human):
	var plate = human.drop()
	take(plate)
	is_delivering = true
	has_failed = false
	_show_emotion(Emotion.NONE)
	human.wait(1)
	robot_animation.play("delivering")

func _fixed_by(human):
	robot_animation.play("succeeding")
	failing_audio.stop()
	is_failing = false
	has_failed = true

func _show_emotion(emotion):
	match emotion:
		Emotion.NONE:
			robot_emote.texture = none_emote
		Emotion.HAPPY:
			robot_emote.texture = happy_emote
		Emotion.SAD:
			robot_emote.texture = sad_emote
		Emotion.WINK:
			robot_emote.texture = wink_emote

func interact(human):
	if human.is_holding_plate() and not is_delivering:
		_deliver_for(human)
	if is_failing:
		_fixed_by(human)

func take(plate):
	hand_spatial.add_child(plate)
	click_audio.play()

func drop():
	var plate = hand_spatial.get_children()[0]
	hand_spatial.remove_child(plate)
	return plate
