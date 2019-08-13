extends GameNode

# This class defines the behavior of the plunger icon in the bottom left
class_name Plunger

func _ready():
	node_id = 0
	max_connections = 1
	available_connections = 1
	
	set_process_input(true)
	connect("gui_input", self, "check_solution")

func check_solution(ev):
	if ev is InputEventMouseButton and not ev.pressed:
		GameRoot.check_solution()
