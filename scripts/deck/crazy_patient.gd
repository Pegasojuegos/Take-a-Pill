extends Entity

@export var patientName: String = "CrazyPatient"
@export var patientDescription: String = "A crazy patient"
@export var patientLige: int = 5
@export var patientDamage: int = 1

func _init():
	super._init(patientName, patientDescription, patientLige, patientDamage)

func goNormal():
	var patient = preload("res://scenes/deck/patient.tscn").instantiate()
	patient.position = position
	get_parent().add_child(patient)
	queue_free()
