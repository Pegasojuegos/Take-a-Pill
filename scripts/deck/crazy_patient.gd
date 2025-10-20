extends Bot

@export var crazyPatientName: String = "CrazyPatient"
@export var crazyPatientDescription: String = "A sick patient"
@export var crazyPatientLife: int = 5
@export var crazyPatientDamage: int = 2

func _init():
	super._init(crazyPatientName, crazyPatientDescription, crazyPatientLife, crazyPatientDamage)

func goNormal(patient: Entity):
	get_parent().get_parent().patientsInGame.append(patient)
	get_parent().get_parent().crazyPatientsInGame.erase(self)
	queue_free()


