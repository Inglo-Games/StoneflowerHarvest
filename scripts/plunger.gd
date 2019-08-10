extends GameNode

# This class defines the behavior of the plunger icon in the bottom left
class_name Plunger

func _ready():
	max_connections = 1
	available_connections = 1
	set_process_input(true)
