extends Consumable

@export var dollName: String = "Doll"
@export var dollDescription: String = "Its very cute but seems suspicious"
@export var dollUses: int = 1

func _init():
	super._init(dollName, dollDescription, dollUses)
