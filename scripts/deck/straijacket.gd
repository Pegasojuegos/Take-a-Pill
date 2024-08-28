extends Consumable

@export var fleshName: String = "Straijacket"
@export var fleshDescription: String = "Dont put that on me please!!"
@export var fleshUses: int = 1

func _init():
	super._init(fleshName, fleshDescription, fleshUses)
