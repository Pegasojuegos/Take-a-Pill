extends Node2D

class_name Card

var cardName: String
var description: String
var dragging: bool
@export var cardsUnder: Array = []
static var cardBeingDragged: Card = null

signal cardRemoved

func _init(cardName: String, description: String):
	self.cardName = cardName
	self.description = description

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	dragCard(event)
	

func _process(_delta):
	#while dragging follow the mouse
	if dragging:
		global_position = get_global_mouse_position()

# On click activate dragging and take to the front, on unclick desactivate dragging
func dragCard(event):
	z_index = 0
	if event is InputEventMouseButton and isTopCard():
		if event.is_pressed() and Card.cardBeingDragged == null:# Only drag if no other card is being dragged
			dragging = true
			Card.cardBeingDragged = self
			emit_signal("cardRemoved") # Emit signal if card moves to cancel crafting
			get_parent().move_child(self, get_parent().get_child_count()-1)# Bring cart to the front
		elif not event.is_pressed() and dragging:
			dragging = false
			Card.cardBeingDragged = null
			# If there are cards under add self to the group and call crafting
			# then erase self from the cardsUnder
			if cardsUnder.size() > 0:
				#Take the top card
				var topCard = cardsUnder[0]
				for card in cardsUnder:
					if card.get_index() > topCard.get_index(): topCard = card
				
				#Put this card down the top card
				position = Vector2(topCard.position.x,topCard.position.y+31)
				cardsUnder.append(self)
				
				#If all are entities combate else craft
				#var allAreEntities = true
				#for card in cardsUnder:
					#if not card is Entity: allAreEntities = false
				#
				#if allAreEntities: get_parent().get_parent().checkCombat(cardsUnder)
				#else: 
				get_parent().get_parent().checkCrafting(cardsUnder)
				cardsUnder.clear()

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

# Detect when contact with another card and save it
func _on_area_2d_area_entered(area):
	if (area.get_parent() is Card or area.get_parent() is Bot) and area.get_parent() != self:
		cardsUnder.append(area.get_parent())

# Detect when leave contact with another card and forget it
func _on_area_2d_area_exited(area):
	if (area.get_parent() is Card or area.get_parent() is Bot) and area.get_parent() !=self :
		cardsUnder.erase(area.get_parent())

