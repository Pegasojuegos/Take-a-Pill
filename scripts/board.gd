extends Node2D

@export var crafts = [
	{"ingredients": {"Pharmacy": 1, "Patient": 1}, "result": {"Drugs":2}},
	{"ingredients": {"Drugs": 3, "Patient":1},"result": {"Medication": 2}},
]

var days: int = 1
var craftingTime = 5
var patientsInGame: Array = []
var medicationsInGame: Array = []

func _ready():
	#Generate initial patients
	$Day.start()
	var patientsNumber = 4
	var pharmacyNumber = 2
	for i in range(patientsNumber):
		var patient = preload("res://scenes/deck/patient.tscn").instantiate()
		patient.position.x = -100
		patient.position.y = i*31
		patientsInGame.append(patient)
		$CardsInGame.add_child(patient)
	
	for i in range(pharmacyNumber):
		var pharmacy = preload("res://scenes/deck/pharmacy.tscn").instantiate()
		pharmacy.position.x = 50
		pharmacy.position.y = i*31
		$CardsInGame.add_child(pharmacy)
	#var drugs = preload("res://scenes/deck/drugs.tscn").instantiate()
	#drugs.position.x = 50
	#$CardsInGame.add_child(drugs)
	#var drugs2 = preload("res://scenes/deck/drugs.tscn").instantiate()
	#drugs2.position.x = 200
	#$CardsInGame.add_child(drugs2)

func _process(_delta):
	$Label.text = "Day: " + str(days) + "\n" + str( "%0.1f" % $Day.time_left) #Show time with one decimal

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
		if craftable:
			startCrafting(craft["result"],selectedCards)
			#createCraft(craft["result"],selectedCards[0].position)

func createCraft(cards: Dictionary, selectedCards: Array):
	var newPositon = selectedCards[0].position
	for card in cards.keys():
		for i in range(cards[card]):
			var cardPath = "res://scenes/deck/" + card.to_lower() + ".tscn"
			var newCardScene = load(cardPath)
			
			if newCardScene:
				var newCard = newCardScene.instantiate()
				newCard.position.x = newPositon.x + 100
				newCard.position.y = newPositon.y + 100 + 31*i
				
				# Safe patients and medications in the array
				match newCard.cardName:
					"Patient": patientsInGame.append(newCard)
					"Medication": medicationsInGame.append(newCard)
				
				$CardsInGame.add_child(newCard)
			else:
				print("Failed to load scente: " + cardPath)
	
	for card in selectedCards:
		if card is Consumable:
			card.use(1)


func nextDay():
	days += 1
	
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
	$Day.start()

func startCrafting(cards: Dictionary, selectedCards: Array):
	# Create a crafting node
	var craftingInstance = Crafting.new(craftingTime,selectedCards.duplicate(true), cards)
	add_child(craftingInstance)
	
	# Connect the signal to handle crafting finish
	craftingInstance.connect("craftingCompleted", Callable(self, "_on_crafting_complete"))
	
	# Connect cards to be aviable to cancel crafting if moves
	for card in selectedCards:
		card.connect("cardRemoved", Callable(craftingInstance, "cancel_crafting"))

func _on_crafting_complete(cards: Dictionary, selectedCards: Array):
	createCraft(cards,selectedCards)


func _on_day_timeout():
	nextDay()
