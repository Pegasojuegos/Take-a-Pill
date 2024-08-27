extends Consumable

@export var fleshName: String = "Flesh"
@export var fleshDescription: String = "Yummi!"
@export var fleshUses: int = 1

func _init():
	super._init(fleshName, fleshDescription, fleshUses)
