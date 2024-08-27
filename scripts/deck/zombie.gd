extends Entity

@export var patientName: String = "Zombie"
@export var patientDescription: String = "A nice zombie?"
@export var patientLige: int = 8
@export var patientDamage: int = 3

func _init():
	super._init(patientName, patientDescription, patientLige, patientDamage)


