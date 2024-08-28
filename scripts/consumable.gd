extends Card

class_name Consumable

var uses: int

func _init(cardName: String, description: String, uses: int):
	super._init(cardName, description)
	self.uses = uses

func use(number):
	uses -= number
	if uses <= 0:
		queue_free() 
