extends Line2D

# This class defines the behavior of a connection between two patches

class_name Connection

var nodes = []

func _ready():
	default_color = Color(0, 0, 0)

func _init_(src_cluster, dest_cluster):
	# Save clusters for future refence
	nodes.append(src_cluster)
	nodes.append(dest_cluster)
	# Setup endpoints
	add_point(src_cluster.rect_position + src_cluster.rect_size * src_cluster.rect_scale / 2.0)
	add_point(dest_cluster.rect_position + dest_cluster.rect_size * dest_cluster.rect_scale / 2.0)

func destroy():
	for c in nodes:
		c.add_connection()
