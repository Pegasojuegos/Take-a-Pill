extends Entity

@export var patientName: String = "CrazyPatientParalyzed"
@export var patientDescription: String = "Let me move!!"
@export var patientLige: int = 5
@export var patientDamage: int = 0

func _init():
	super._init(patientName, patientDescription, patientLige, patientDamage)

func goNormal():
	var normal = preload("res://scenes/deck/patient.tscn").instantiate()
	normal.position = position
	get_parent().add_child(normal)
	get_parent().get_parent().patientsInGame.append(self)
	queue_free()
