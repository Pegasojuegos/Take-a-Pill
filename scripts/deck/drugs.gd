extends Consumable

@export var drugsName: String = "Drugs"
@export var dugsDescription: String = "Some strange dugs"
@export var drugsUses: int = 2


func _init():
	super._init(drugsName, dugsDescription, drugsUses)
