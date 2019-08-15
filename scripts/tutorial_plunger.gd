extends Plunger

func _ready():
	node_id = 0
	max_connections = 1
	available_connections = 1
	
	set_process_input(true)
	connect("gui_input", self, "check_soln_tut")

# Special solution function that interacts with tutorial
func check_soln_tut(ev):
	
	# React to click release
	if ev is InputEventMouseButton and not ev.pressed:
		GameRoot.check_solution()
		
		# Prompt next tutorial step if appropriate
		if [7, 16].has(GameRoot.step):
			GameRoot.next_step("")

# Special drag_data function that interacts with tutorial
func get_drag_data(position):
	
	# Prompt next tutorial step if appropriate
	if [5, 12].has(GameRoot.step):
		GameRoot.next_step("")
	
	return self
