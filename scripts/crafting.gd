extends Node2D

class_name Crafting

signal craftingCompleted

var craftingTime: float
var selectedCards: Array
var result: Dictionary
var progressBar: ProgressBar
var timer: Timer

func _init(craftingTime:float, selectedCards: Array, result: Dictionary):
	self.craftingTime = craftingTime
	self.selectedCards = selectedCards
	self.result = result


func _ready():
	# Create and configure the timer
	timer = Timer.new()
	timer.wait_time = craftingTime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_crafting_complete"))
	add_child(timer)
	timer.start()
	
	#Create and configure the progress bar
	progressBar = ProgressBar.new()
	progressBar.min_value = 0
	progressBar.max_value = craftingTime
	progressBar.value = 0
	progressBar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progressBar.custom_minimum_size = Vector2(100,10)
	progressBar.position = selectedCards[0].position + Vector2(-70 ,-100)
	selectedCards[0].add_child(progressBar)
	
	# Start progress bar update
	set_process(true)

func _process(delta):
	if timer.time_left > 0:
		progressBar.value = craftingTime - timer.time_left

func _on_crafting_complete():
	# Emit singal to the board to habdle the result
	emit_signal("craftingCompleted",result,selectedCards)
	
	# Delete progress bar
	progressBar.queue_free()
	
	#Delete crafting node
	queue_free()

func cancel_crafting():
	# Delete progress bar and stop crafting if cancel
	if timer and timer.is_stopped() == false:
		timer.stop()
	progressBar.queue_free()
	queue_free()
