extends Node2D

@export var crafts = [
	{"ingredients": {"Drugs": 2},"result": {"Patient": 2}},
]

func _ready():
	var patient = preload("res://scenes/deck/patient.tscn").instantiate()
	patient.position.x = -100
	$CardsInGame.add_child(patient)
	var drugs = preload("res://scenes/deck/drugs.tscn").instantiate()
	drugs.position.x = 50
	$CardsInGame.add_child(drugs)
	var drugs2 = preload("res://scenes/deck/drugs.tscn").instantiate()
	drugs2.position.x = 200
	$CardsInGame.add_child(drugs2)

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
	for card in cards.keys():
		for i in range(cards[card]):
			var cardPath = "res://scenes/deck/" + card.to_lower() + ".tscn"
			var newCardScene = load(cardPath)
			
			if newCardScene:
				var newCard = newCardScene.instantiate()
				newCard.position.x = newPositon.x + 100
				newCard.position.y = newPositon.y + 100
				$CardsInGame.add_child(newCard)
			else:
				print("Failed to load scente: " + cardPath)
