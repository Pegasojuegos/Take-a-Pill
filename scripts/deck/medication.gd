extends Consumable

@export var medicationName: String = "Medication"
@export var medicationDescription: String = "The way to save their lives"
@export var medicationUses: int = 1

func _init():
	super._init(medicationName, medicationDescription, medicationUses)
