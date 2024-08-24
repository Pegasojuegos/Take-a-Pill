extends Consumable

@export var pharmacyName: String = "Pharmacy"
@export var pharmacyDescription: String = "Just a place where buy drugs"
@export var pharmacyUses: int = 2

func _init():
	super._init(pharmacyName, pharmacyDescription, pharmacyUses)
