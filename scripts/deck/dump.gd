extends Consumable

@export var fleshName: String = "Dump"
@export var fleshDescription: String = "It stinks!"
@export var fleshUses: int = 2

func _init():
	super._init(fleshName, fleshDescription, fleshUses)
