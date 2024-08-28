extends Entity

@export var zombieName: String = "Zombie"
@export var zombieDescription: String = "A nice zombie?"
@export var zombietLige: int = 8
@export var zombieDamage: int = 3

func _init():
	super._init(zombieName, zombieDescription, zombietLige, zombieDamage)


