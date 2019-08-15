extends Control

# Abstract class to define the behavior of connectable game elements
# (i.e., the plunger icon and flower clusters)
class_name GameNode

onready var GameRoot = get_node("/root/game_world")

var available_connections
var max_connections
var node_id
var connected_nodes

func _ready():
	connected_nodes = []

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

func can_drop_data(position, data):
	return data.get_class() == "GameNode" \
			and data != self \
			and self.available_connections > 0 \
			and data.available_connections > 0

func drop_data(position, data):
	GameRoot.connect_clusters(data, self)
	self.remove_conn()
	data.remove_conn()
	connected_nodes.append(data.node_id)
	data.connected_nodes.append(node_id)

func get_drag_data(position):
	return self
