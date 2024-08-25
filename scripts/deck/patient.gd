extends Entity

@export var patientName: String = "Patient"
@export var patientDescription: String = "A sick patient"
@export var patientLige: int = 5
@export var patientDamage: int = 1

func _init():
	super._init(patientName, patientDescription, patientLige, patientDamage)

func goCrazy():
	$Sprite2D.texture = load("res://assets/images/deck/card_flesh.png")
