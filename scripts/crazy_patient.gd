extends Entity

@export var patientName: String = "Patient"
@export var patientDescription: String = "A sick patient"
@export var patientLige: int = 5
@export var patientDamage: int = 2

func _init():
	super._init(patientName, patientDescription, patientLige, patientDamage)

func goNormal():
	var normal = preload("res://scenes/deck/patient.tscn").instantiate()
	normal.position = position
	get_parent().add_child(normal)
	get_parent().get_parent().patientsInGame.append(self)
	queue_free()
