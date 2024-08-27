extends Node2D

@export var crafts = [
	{"ingredients": {"Flesh": 2, "Drugs": 1, "Patient": 1}, "result": {"Zombie": 1}},
	{"ingredients": {"Dump": 1, "Patient": 1}, "result": {"Fabric": 1, "Scrap": 1}},
	{"ingredients": {"Fabric": 1, "Scrap": 1, "Patient": 1}, "result": {"Straijacket": 1}},
	{"ingredients": {"Patient": 1, "Fabric":1, "Scrap": 2 }, "result": {"Warehouse": 1}}, #Pendig of creation
	{"ingredients": {"Patient": 1, "Fabric":1, "Scrap": 2 }, "result": {"Laboratory": 1}}, #Pendig of creation
	{"ingredients": {"Fabric": 3, "Patient": 1}, "result": {"Blanket": 1}},#Pendig of creation
	{"ingredients": {"Pharmacy": 1, "Patient": 1}, "result": {"Drugs":2}},
	{"ingredients": {"Drugs": 3, "Patient":1}, "result": {"Medication": 1}},
	{"ingredients": {"Patient": 1, "Drugs": 2, "Laboratory": 1}, "result": {"Medication": 1}},
	{"ingredients": {"Zombie": 1, "CrazyPatient":1}, "result": {"Flesh": 1}},
]
@export var combats = [
	{"fifhters": {"Zombie":1, "CrazyPatient":1}, "drops": {"Flesh":1}},
]

var days: int = 1
var craftingTime = 1
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
		
	var zombie = preload("res://scenes/deck/zombie.tscn").instantiate()
	zombie.position.x = -200
	$CardsInGame.add_child(zombie)
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
		
		# If all ingredients are present call craft
		if craftable:
			startCrafting(craft["result"],selectedCards)


func createCraft(cards: Dictionary, selectedCards: Array):
	
	var allAreEntities: bool = true
	var someoneDead: bool = false
	for card in selectedCards:
		if card is Consumable:
			card.use(1)
		if not card is Entity:
			allAreEntities = false
	
	if allAreEntities:
		if selectedCards[0].hurt(selectedCards[1].damage): someoneDead = true
		if selectedCards[1].hurt(selectedCards[0].damage): someoneDead = true
	
	var newPositon = selectedCards[0].position
	if not allAreEntities or someoneDead:
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
			patientsInGame[patientsInGame.size()-1].goCrazy()
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

#
#func checkCombat(selectedCards: Array):
	##Count how many fighers are of each type
	#var fightersCount = {}
	#
	#for card in selectedCards:
		#var cardName = card.cardName
		#if fightersCount.has(cardName):
			#fightersCount[cardName] += 1
		#else:
			#fightersCount[cardName] = 1
	#
	## Check if fighers match with any combat
	#for combat in combats:
		#var combatable: bool = true
		#var fightersNeeded = combat["fifhters"]
		#
		## Check if needed fighers are present
		#for fighter in fightersNeeded.keys():
			#if not fightersCount.has(fighter) or fightersCount[fighter] != fightersNeeded[fighter]:
				#combatable = false
				#break # If one figher is missing the combat doesn't match
		#
		## Check if there is no extra fighers
		#for fighter in fightersCount.keys():
			#if not fightersNeeded.has(fighter):
				#combatable = false
				#break
		#
		## If all fighers are present call combat 
		#if combatable:
			#startFighting(combat["drops"],selectedCards)
#
#func startFighting(cards: Dictionary, selectedCards: Array):
	#
