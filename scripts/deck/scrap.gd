extends Consumable

@export var fleshName: String = "Scrap"
@export var fleshDescription: String = "Maybe I can do something useful with this!"
@export var fleshUses: int = 1

func _init():
	super._init(fleshName, fleshDescription, fleshUses)
