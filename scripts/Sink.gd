extends StaticBody

signal delivered

var plate_spatials = []

var timestamps = []
var froms = []

var num_plates = 0
var time_so_far = 0

func _ready():
	plate_spatials.append($FirstPlateSpatial)
	plate_spatials.append($SecondPlateSpatial)
	plate_spatials.append($ThirdPlateSpatial)
	plate_spatials.append($FourthPlateSpatial)
	plate_spatials.append($FifthPlateSpatial)
	plate_spatials.append($SixthPlateSpatial)

func _process(delta):
	time_so_far += delta

func interact(human):
	if human.is_holding_item():
		var plate = human.drop()
		take(plate, "human")

func take(plate, from):
	emit_signal("delivered")
	plate_spatials[num_plates].add_child(plate)
	timestamps.append(time_so_far)
	froms.append(from)
	num_plates += 1
	
func set_highlight(is_highlight):
	$SinkMesh/SinkOutline.visible = is_highlight
