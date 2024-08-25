extends Node2D

@export var crafts = [
	{"ingredients": {"Pharmacy": 1, "Patient": 1}, "result": {"Drugs":2}},
	{"ingredients": {"Drugs": 3, "Patient":1},"result": {"Medication": 2}},
]
@export var turnsPerDay: int = 3
var turnsLeft: int = turnsPerDay
var days: int = 1
var patientsInGame: Array = []
var medicationsInGame: Array = []

func _ready():
	$Label.text = "Days: "+str(days)+"\n Turns left: "+str(turnsLeft)
	
	#Generate initial patients
	var patientsNumber = 4
	for i in range(patientsNumber):
		var patient = preload("res://scenes/deck/patient.tscn").instantiate()
		patient.position.x = -100
		patientsInGame.append(patient)
		$CardsInGame.add_child(patient)
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
			if not ingredientsCount.has(ingredient) or ingredientsCount[ingredient] != ingredientsNeeded[ingredient]:
				craftable = false
				break # If one ingredient is missing the craft doesn't match
		
		# Check if there is no extra ingredients
		for ingredient in ingredientsCount.keys():
			if not ingredientsNeeded.has(ingredient):
				craftable = false
				break
		
		# If all ingredients are present and can play turn call craft and use consumables
		if craftable and canPlayTurns(1):
			createCraft(craft["result"],selectedCards[0].position)
			
			for card in selectedCards:
				if card is Consumable:
					card.use(1)
			
			playTurns(1)

func createCraft(cards: Dictionary, newPositon: Vector2):
	for card in cards.keys():
		for i in range(cards[card]):
			var cardPath = "res://scenes/deck/" + card.to_lower() + ".tscn"
			var newCardScene = load(cardPath)
			
			if newCardScene:
				var newCard = newCardScene.instantiate()
				newCard.position.x = newPositon.x + 100
				newCard.position.y = newPositon.y + 100
				
				# Safe patients and medications in the array
				match newCard.cardName:
					"Patient": patientsInGame.append(newCard)
					"Medication": medicationsInGame.append(newCard)
				
				$CardsInGame.add_child(newCard)

			else:
				print("Failed to load scente: " + cardPath)

# You can't spend more turns than turns left
func canPlayTurns(numberOfTurns):
	return numberOfTurns <= turnsLeft

func playTurns(numberOfTurns):		
	turnsLeft -= numberOfTurns
	
	# Next day logic
	if turnsLeft <= 0:
		nextDay()
	
	$Label.text = "Days: "+str(days)+"\n Turns left: "+str(turnsLeft)

func nextDay():
	days += 1
	turnsLeft = turnsPerDay
	
	if medicationsInGame >= patientsInGame:
		#Use one medication for each patient
		for i in range(patientsInGame.size()):
			medicationsInGame[i].use(1)
		print("Life")
	else:
		#Use the medications aviable, and go crazy the patients wit no medication
		for i in range(medicationsInGame.size()):
			medicationsInGame[i].use(1)
		 
		for i in range(patientsInGame.size() - medicationsInGame.size()):
			patientsInGame[i].goCrazy()
		print("Die")
