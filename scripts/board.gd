extends Node2D

@export var crafts = [
	{"ingredients": {"Flesh": 2, "Drugs": 1, "Patient": 1}, "result": {"Zombie": 1}},
	{"ingredients": {"Dump": 1, "Patient": 1}, "result": {"Fabric": 1, "Scrap": 1}},
	{"ingredients": {"Fabric": 1, "Scrap": 1, "Patient": 1}, "result": {"Straijacket": 1}},
	{"ingredients": {"CrazyPatient": 1, "Straijacket": 1,}, "result": {"Patient": 1}},
	#{"ingredients": {"Patient": 1, "Fabric":1, "Scrap": 2 }, "result": {"Storehouse": 1}}, #Pendig of creation
	{"ingredients": {"Patient": 1, "Fabric":1, "Scrap": 2 }, "result": {"Laboratory": 1}}, 
	{"ingredients": {"Fabric": 3, "Patient": 1}, "result": {"Blanket": 1}},#Pendig of creation
	{"ingredients": {"Pharmacy": 1, "Patient": 1}, "result": {"Drugs":2}},
	{"ingredients": {"Drugs": 3, "Patient":1}, "result": {"Medication": 1}},
	{"ingredients": {"Patient": 1, "Drugs": 2, "Laboratory": 1}, "result": {"Medication": 1}},
	{"ingredients": {"Zombie": 1, "CrazyPatient":1}, "result": {"Flesh": 1}},
	{"ingredients": {"Patient": 1, "CrazyPatient":1}, "result": {"Flesh": 1}},
	{"ingredients": {"Fabric": 4, "Patient":1}, "result": {"Blanket": 1}},
	{"ingredients": {"Blanket": 2, "Patient":1, "Flesh":2, "Scrap":1}, "result": {"Doll": 1}},
	{"ingredients": {"Doll": 6, "Flesh":6, "Patient":6}, "result": {"Ritual": 1}},
	{"ingredients": {"MisteryBox": 1, "Ritual":1, }, "result": {"final": 1}},
	{"ingredients": {"Laboratory": 1, "Scrap":6, "Blanket":1, "Patient":1 }, "result": {"UpdateLabotatory": 1}},
	{"ingredients": {"Patient": 1, "Drugs": 1, "UpdateLabotatory": 1}, "result": {"Medication": 1}},
]

var end: bool = false
var days: int = 1
var craftingTime = 5
var patientsInGame: Array = []
var crazyPatientsInGame: Array = []
var medicationsInGame: Array = []
var numberOfSteals: int = 3
var stelableCards:Dictionary = {
	"Dump":{#Probability
		"min":1,
		"max":40
	}, 
	"Pharmacy":{
		"min":41,
		"max":80
	}, 
	"Patient": {
		"min":81,
		"max":100
	}, 
}

func _ready():
	#Generate initial patients
	$Day.start()
	var patientsNumber = 1
	var pharmacyNumber = 1
	var misteryBox = preload("res://scenes/deck/mistery_box.tscn").instantiate()
	misteryBox.position.x = 980
	misteryBox.position.y = 450
	$CardsInGame.add_child(misteryBox)
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
	if !end: 
		var allAreEntities: bool = true
		var someoneDead: bool = false
		for card in selectedCards:
			if card != null and not card.is_queued_for_deletion():
				if card is Consumable:
					card.use(1)
			if not (card is Entity or card is Bot):
				allAreEntities = false
		
		if allAreEntities:
			if selectedCards[0].hurt(selectedCards[1].damage): someoneDead = true
			if selectedCards[1].hurt(selectedCards[0].damage): someoneDead = true
		
		var newPositon = selectedCards[0].position
		if not allAreEntities or someoneDead:
			for card in cards.keys():
				if card == "final":
					$ColorRect.visible = true
					$Fin.start()
				for i in range(cards[card]):
					var cardPath = "res://scenes/deck/" + card.to_lower() + ".tscn"
					var newCardScene = load(cardPath)
					
					if newCardScene:
						var newCard = newCardScene.instantiate()
						newCard.position.x = newPositon.x + 150
						newCard.position.y = newPositon.y + 150 + 31*i
						
						# Safe patients and medications in the array
						match newCard.cardName:
							"Patient": 
								patientsInGame.append(newCard)
								for j in range(selectedCards.size()):
									if selectedCards[j].cardName == "CrazyPatient":
										patientsInGame.erase(selectedCards[j])
										selectedCards[j].queue_free()
							"Medication": medicationsInGame.append(newCard)
							"Zombie": #If craft a zombie, kill the patient
								for j in range(selectedCards.size()):
									if selectedCards[j].cardName == "Patient":
										patientsInGame.erase(selectedCards[j])
										selectedCards[j].queue_free()
						
						$CardsInGame.add_child(newCard)
					else:
						print("Failed to load scente: " + cardPath)



func nextDay():
	emit_signal("cancellCrafting")
	if medicationsInGame >= patientsInGame:
		#Use one medication for each patient
		var i = 0
		while i < patientsInGame.size():
			medicationsInGame[0].use(1)
			medicationsInGame.remove_at(0)
			i += 1
		print("Life")
	else:
		#Use the medications aviable, and go crazy the patients with no medication
		
		for i in range((patientsInGame.size() - medicationsInGame.size() )):
			patientsInGame[patientsInGame.size()-1].goCrazy()
		
		while medicationsInGame.size() > 0:
			medicationsInGame[0].use(1)
			medicationsInGame.remove_at(0)
		
		# Make the crazy patients atack patients
		var patientsAtacked: Array = []
		for crazy in crazyPatientsInGame:
			if patientsInGame.size() > 0:
				var number = int(randf_range(0,patientsInGame.size()-1))
				if not patientsAtacked.has(patientsInGame[number]):
					patientsAtacked.append(patientsInGame[number])
					crazy.atack(patientsInGame[number])
		
		print("Die")
	if patientsInGame.size() <= 0: gameOver()
	else:
		stealCard()
		days += 1
		$Day.start()

func startCrafting(cards: Dictionary, selectedCards: Array):
	# Create a crafting node
	var craftingInstance = Crafting.new(craftingTime,selectedCards.duplicate(true), cards)
	$CardsInGame.add_child(craftingInstance)
	
	# Connect the signal to handle crafting finish
	craftingInstance.connect("craftingCompleted", Callable(self, "_on_crafting_complete"))
	self.connect("cancellCrafting", Callable(craftingInstance, "cancel_crafting"))
	
	# Connect cards to be aviable to cancel crafting if moves
	for card in selectedCards:
		card.connect("cardRemoved", Callable(craftingInstance, "cancel_crafting"))

func _on_crafting_complete(cards: Dictionary, selectedCards: Array):
	createCraft(cards,selectedCards)


func _on_day_timeout():
	nextDay()

func stealCard():
	var cardsToSteal: Array = []
	cardsToSteal.append("Dump")
	cardsToSteal.append("Pharmacy")
	
	while cardsToSteal.size() < numberOfSteals:
		var random = int(randi_range(0,100))
		for card in stelableCards.keys():
			if random >= stelableCards[card]["min"] and random <= stelableCards[card]["max"]: 
				cardsToSteal.append(card)
	
	var i: int = 0
	for card in cardsToSteal:
		var cardPath = "res://scenes/deck/" + card.to_lower() + ".tscn"
		var newCardScene = load(cardPath)
		
		if newCardScene:
			var newCard = newCardScene.instantiate()
			newCard.position.x = -900 
			newCard.position.y = -400 + 31 * i
			$CardsInGame.add_child(newCard)
			
			match card:
				"Patient": patientsInGame.append(newCard)
			
			i += 1

func gameOver():
	$Day.stop()
	for child in $CardsInGame.get_children():
		$CardsInGame.remove_child(child)
	print("Game Over")
	get_tree().change_scene_to_file("res://scenes/deck/game_over.tscn")


func _on_fin_timeout():
	$Day.stop()
	for child in $CardsInGame.get_children():
		$CardsInGame.remove_child(child)
	print("Win")
	get_tree().change_scene_to_file("res://scenes/final.tscn")
