extends Consumable

@export var drugsName: String = "Drugs"
@export var dugsDescription: String = "Some strange dugs"
@export var drugsUses: int = 1


func _init():
	super._init(drugsName, dugsDescription, drugsUses)
