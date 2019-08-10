extends Line2D

# This class defines the behavior of a connection between two patches

class_name Connection

var nodes = []

func _ready():
	pass

func _init_(src_cluster, dest_cluster):
	nodes.append(src_cluster)
	nodes.append(dest_cluster)

func destroy():
	for c in nodes:
		c.add_connection()
