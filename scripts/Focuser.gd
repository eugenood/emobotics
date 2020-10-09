extends Label

func _ready():
	self._pause()

func _input(event):
	if event.is_action_released("interact"):
		self._resume()
	if event.is_action_released("cancel"):
		self._pause()

func _resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.get_tree().paused = false
	self.visible = false

func _pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.get_tree().paused = true
	self.visible = true
