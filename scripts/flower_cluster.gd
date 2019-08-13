extends GameNode

# This defines the behavior of a cluster of stoneflowers
class_name Cluster

func _ready():
	max_connections = 2
	available_connections = 2
	set_process_input(true)

func set_id(num):
	node_id = num
