extends Entity

@export var patientName: String = "Patient"
@export var patientDescription: String = "A sick patient"
@export var patientLige: int = 5
@export var patientDamage: int = 1

func _init():
	super._init(patientName, patientDescription, patientLige, patientDamage)

func goCrazy():
	emit_signal("cardRemoved")
	var crazy = preload("res://scenes/deck/crazy_patient.tscn").instantiate()
	crazy.position = position
	get_parent().add_child(crazy)
	get_parent().get_parent().patientsInGame.erase(self)
	get_parent().get_parent().crazyPatientsInGame.append(crazy)
	queue_free()
