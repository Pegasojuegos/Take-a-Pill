extends Card

class_name Entity

@export var life: int
@export var damage: int

func _init(cardName: String, description: String, life: int, damage:int):
	super._init(cardName, description)
	self.life = life
	self.damage = damage
	$Label.text = str(life)


func hurt(damageDone: int) -> bool:
	life -= damageDone
	$Label.text = str(life)
	var die: bool = life <= 0
	if die : 
		emit_signal("cardRemoved")
		queue_free()
	return die
