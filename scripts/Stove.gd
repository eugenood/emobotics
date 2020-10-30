extends StaticBody

signal delivered

onready var pan_spatial = $PanSpatial

func interact(human):
	if human.is_holding_item():
		var plate = human.drop()
		take(plate, "human")

func take(pan, from):
	emit_signal("delivered")
	pan_spatial.add_child(pan)
