extends Label

onready var countdown_timer = $CountdownTimer

var time_spent = 0

func start_timer():
	countdown_timer.connect("timeout", self, "on_timeout")
	countdown_timer.start()

func on_timeout():
	time_spent += 1
	text = seconds_to_string(time_spent)

func seconds_to_string(seconds):
	return "%02d:%02d" % [seconds / 60, seconds % 60]
