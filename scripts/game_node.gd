extends Control

# Abstract class to define the behavior of connectable game elements
# (i.e., the plunger icon and flower clusters)
class_name GameNode

signal continue_tut

onready var GameRoot = get_node("/root/game_world")

var available_connections
var max_connections
var node_id
var connected_nodes

func _ready():
	connected_nodes = []
	connect("gui_input", self, "_on_game_node_clicked")

# Handle mouse input
func _on_game_node_clicked(ev):
	# Handle click and drag
	if ev is InputEventMouseMotion \
			and Input.is_mouse_button_pressed(BUTTON_LEFT) \
			and not GameRoot.is_drawing:
		GameRoot.start_drawing(get_viewport().get_mouse_position())

func get_class():
	return "GameNode"

func remove_conn():
	if available_connections > 0:
		available_connections -= 1
		return true
	else:
		return false

func add_connection():
	if available_connections < max_connections:
		available_connections += 1
		return true
	else:
		return false

# warning-ignore:unused_argument
func can_drop_data(position, data):
	return data.get_class() == "GameNode" \
			and data != self \
			and self.available_connections > 0 \
			and data.available_connections > 0

# warning-ignore:unused_argument
func drop_data(position, data):
	GameRoot.connect_clusters(data, self)
	self.remove_conn()
	data.remove_conn()
	connected_nodes.append(data.node_id)
	data.connected_nodes.append(node_id)

# warning-ignore:unused_argument
func get_drag_data(position):
	return self
