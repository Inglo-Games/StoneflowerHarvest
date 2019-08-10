extends Control

# Abstract class to define the behavior of connectable game elements
# (i.e., the plunger icon and flower clusters)
class_name GameNode

var available_connections
var max_connections

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
	print("Got some dropped data!")
	get_parent().connect_clusters(data, self)
	self.remove_conn()
	data.remove_conn()

func get_drag_data(position):
	print("Dropping data...")
	return self
