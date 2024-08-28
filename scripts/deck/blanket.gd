extends Consumable

@export var blanketName: String = "Blanket"
@export var blanketDescription: String = "Its warm :D"
@export var blanketUses: int = 1

func _init():
	super._init(blanketName, blanketDescription, blanketUses)
