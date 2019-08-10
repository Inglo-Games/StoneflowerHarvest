extends Node2D

const Cluster = preload("flower_cluster.gd")
const Connection = preload("connection.gd")

# List of all flower clusters in the level
var clusters = []

func _ready():
	generate_clusters(5)

# Generate a number of flower clusters and place them about the screen randomly
func generate_clusters(num):
	# warning-ignore:unused_variable
	for i in range(num):
		var new_cluster = Cluster.new()
		new_cluster.rect_position = rand_coords()
		clusters.append(new_cluster)
		call_deferred("add_child", new_cluster)

# Generate a set of random coordinates within the screen
func rand_coords():
	var win = get_viewport().size
	return Vector2(rand_range(0.1, 0.9) * win.x, rand_range(0.1, 0.9) * win.y)

# Callback function to draw a line between two clusters
func connect_clusters(src_cluster, dest_cluster):
	var cable = Connection.new()
	cable._init_(src_cluster, dest_cluster)
	$line_layer.call_deferred("add_child", cable)
