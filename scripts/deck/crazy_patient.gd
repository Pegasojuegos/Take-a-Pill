extends Bot

@export var crazyPatientName: String = "CrazyPatient"
@export var crazyPatientDescription: String = "A sick patient"
@export var crazyPatientLife: int = 5
@export var crazyPatientDamage: int = 2

func _init():
	super._init(crazyPatientName, crazyPatientDescription, crazyPatientLife, crazyPatientDamage)

func goNormal():
	var normal = preload("res://scenes/deck/patient.tscn").instantiate()
	normal.position = position
	get_parent().add_child(normal)
	get_parent().get_parent().patientsInGame.append(normal)
	get_parent().get_parent().crazyPatientsInGame.erase(self)
	queue_free()


