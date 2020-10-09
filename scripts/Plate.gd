extends StaticBody

var can_interact = true

func interact(human):
	if can_interact and not human.is_holding_plate():
		get_parent().remove_child(self)
		human.take(self)
		can_interact = false
