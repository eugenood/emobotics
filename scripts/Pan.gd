extends StaticBody

var can_interact = true

func interact(human):
	if can_interact and not human.is_holding_item():
		get_parent().remove_child(self)
		human.take(self)
		can_interact = false

func set_highlight(is_highlight):
	$PanMesh/PanOutline.visible = is_highlight
