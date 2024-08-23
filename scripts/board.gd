extends Node2D

var crafts = [
	{"ingredients": {"Drugs": 2},"result": "Patient"},
]

func _ready():
	var patient = preload("res://scenes/deck/patient.tscn").instantiate()
	patient.position.x = -50
	$CardsInGame.add_child(patient)
	var drugs = preload("res://scenes/deck/drugs.tscn").instantiate()
	drugs.position.x = 50
	$CardsInGame.add_child(drugs)
	var drugs2 = preload("res://scenes/deck/drugs.tscn").instantiate()
	drugs2.position.x = 60
	$CardsInGame.add_child(drugs2)

func checkCrafting(selectCards: Array):
	pass
