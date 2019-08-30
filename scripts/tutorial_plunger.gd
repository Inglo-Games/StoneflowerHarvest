extends Plunger

func _ready():
	node_id = 0
	max_connections = 1
	available_connections = 1
	
	set_process_input(true)
	connect("gui_input", self, "_on_mouse_event")

# Special solution function that interacts with tutorial
func _on_mouse_event(ev):
	
	# React to click release
	if ev is InputEventMouseButton and not ev.pressed:
		var solved = GameRoot.check_solution()
		
		# Prompt next tutorial step if appropriate
		if solved and [8, 17, 22].has(GameRoot.step):
			emit_signal("continue_tut")

# Special drop_data function that interacts with tutorial
func drop_data(position, data):
	GameRoot.connect_clusters(data, self)
	self.remove_conn()
	data.remove_conn()
	connected_nodes.append(data.node_id)
	data.connected_nodes.append(node_id)
	
	# Prompt next tutorial step if appropriate
	if [6, 13].has(GameRoot.step):
		emit_signal("continue_tut")
