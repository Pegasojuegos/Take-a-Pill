extends Consumable

@export var fleshName: String = "Fabric"
@export var fleshDescription: String = "It is soft"
@export var fleshUses: int = 1

func _init():
	super._init(fleshName, fleshDescription, fleshUses)
