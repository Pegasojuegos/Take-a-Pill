extends Node2D

class_name Card

var description: String
var life: int
var dragging: bool

func _on_area_2d_input_event(viewport, event, shape_idx):
	dragCard(event)
	

func _process(delta):
	#while dragging follow the mouse
	if dragging:
		global_position = get_global_mouse_position()

#On click activate dragging and take to the front, on unclick desactivate dragging
func dragCard(event):
	if event is InputEventMouseButton and isTopCard():
		if event.is_pressed():
			dragging = true
			get_parent().move_child(self, get_parent().get_child_count()-1)# Bring cart to the front
		else:
			dragging = false

# Function to check if this card is the topmost at the mouse position.
func isTopCard() -> bool:
	var parent = get_parent()
	var res: bool = true
	for child in parent.get_children():
		if child is Card and child != self:
			# Check if another card is closer to the mouse and has a higher z_index.
			if child.global_position.distance_to(get_global_mouse_position()) < global_position.distance_to(get_global_mouse_position()) and child.z_index >= z_index:
				res = false
	return res
	

func usar():
	pass






func _on_area_2d_area_entered(area):
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	pass # Replace with function body.
