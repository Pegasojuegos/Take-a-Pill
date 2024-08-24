extends Node2D

@export var crafts = [
	{"ingredients": {"Pharmacy": 1, "Patient": 1}, "result": {"Drugs":2}},
	{"ingredients": {"Drugs": 3, "Patient":1},"result": {"Medication": 2}},
]
@export var turnsPerRound: int = 5
var turnsLeft: int = turnsPerRound

func _ready():
	var patient = preload("res://scenes/deck/patient.tscn").instantiate()
	patient.position.x = -100
	$PatientsInGame.add_child(patient)
	var pharmacy = preload("res://scenes/deck/pharmacy.tscn").instantiate()
	pharmacy.position.x = 50
	$CardsInGame.add_child(pharmacy)
	#var drugs = preload("res://scenes/deck/drugs.tscn").instantiate()
	#drugs.position.x = 50
	#$CardsInGame.add_child(drugs)
	#var drugs2 = preload("res://scenes/deck/drugs.tscn").instantiate()
	#drugs2.position.x = 200
	#$CardsInGame.add_child(drugs2)

func checkCrafting(selectedCards: Array):
	#Count how many ingredients are of each type
	var ingredientsCount = {}
	
	for card in selectedCards:
		var cardName = card.cardName
		if ingredientsCount.has(cardName):
			ingredientsCount[cardName] += 1
		else:
			ingredientsCount[cardName] = 1
	
	# Check if ingredients match with any recipe
	for craft in crafts:
		var craftable: bool = true
		var ingredientsNeeded = craft["ingredients"]
		
		# Check if needed ingredients are present
		for ingredient in ingredientsNeeded.keys():
			if not ingredientsCount.has(ingredient) or ingredientsCount[ingredient] < ingredientsNeeded[ingredient]:
				craftable = false
				break # If one ingredient is missing the craft doesn't match
		
		# If all ingredients are present call craft and use consumables
		if craftable:
			createCraft(craft["result"],selectedCards[0].position)
			
			for card in selectedCards:
				if card is Consumable:
					card.use(1)

func createCraft(cards: Dictionary, newPositon: Vector2):
	turnsLeft -= 1
	print(turnsLeft)
	for card in cards.keys():
		for i in range(cards[card]):
			var cardPath = "res://scenes/deck/" + card.to_lower() + ".tscn"
			var newCardScene = load(cardPath)
			
			if newCardScene:
				var newCard = newCardScene.instantiate()
				newCard.position.x = newPositon.x + 100
				newCard.position.y = newPositon.y + 100
				
				# Difference between some tipes to have count of them
				match newCard.cardName:
					"Patient": $PatientsInGame.add_child(newCard)
					"Medication": $MedicationsInGame.add_child(newCard)
					_: $CardsInGame.add_child(newCard)

			else:
				print("Failed to load scente: " + cardPath)
