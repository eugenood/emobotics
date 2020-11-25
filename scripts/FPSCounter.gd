extends Label

var average_fps = 0
var samples = 0

func _process(delta):
	var current_fps = Engine.get_frames_per_second()
	samples += 1
	average_fps = ((samples - 1.0) / samples) * average_fps + (1.0 / samples) * current_fps
	text = "FPS: " + str(current_fps)
