extends Node2D

class_name Bot

var cardName: String
var description: String
var objectiveCards: Array = []
var life:int
var damage:int

func _init(cardName: String, description: String, life: int, damage: int):
	self.cardName = cardName
	self.description = description
	self.life = life
	self.damage = damage

# Atack to one objective
func atack(objective: Card):
	position = Vector2(objective.position.x,objective.position.y+31)
	if objective.z_index <= 0: objective.z_index = 1
	z_index = objective.z_index - 1
	self.hurt(objective.damage)
	if objective.hurt(self.damage):
		var cardPath = "res://scenes/deck/flesh.tscn"
		var newCardScene = load(cardPath)
		
		if newCardScene:
			var newCard = newCardScene.instantiate()
			newCard.position.x = objective.position.x + 100
			newCard.position.y = objective.position.y + 100 
			
			get_parent().add_child(newCard)
	

func hurt(damageDone: int) -> bool:
	life -= damageDone
	var die: bool = life <= 0
	if die : queue_free()
	return die


# Detect when contact with another card and save it
func _on_area_2d_area_entered(area):
	if (area.get_parent() is Card or area.get_parent() is Bot) and area.get_parent() != self:
		objectiveCards.append(area.get_parent())

# Detect when leave contact with another card and forget it
func _on_area_2d_area_exited(area):
	if (area.get_parent() is Card or area.get_parent() is Bot) and area.get_parent() !=self :
		objectiveCards.erase(area.get_parent())
