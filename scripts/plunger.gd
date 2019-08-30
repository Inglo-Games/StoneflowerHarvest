extends GameNode

# This class defines the behavior of the plunger icon in the bottom left
class_name Plunger

func _ready():
	node_id = 0
	max_connections = 1
	available_connections = 1
	
	set_process_input(true)
	connect("gui_input", self, "_on_click")

# Handle mouse input
func _on_click(ev):
	# Handle single click
	if ev is InputEventMouseButton and not ev.pressed:
		GameRoot.check_solution()

# Function only exists for simplicity in check_solution function
func fire_explosion():
	pass
