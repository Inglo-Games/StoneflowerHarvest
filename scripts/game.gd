extends Node2D

const Cluster = preload("flower_cluster.gd")

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
	var cable = Line2D.new()
	cable.set_script("res://scripts/connection.gd")
	cable._init_(src_cluster, dest_cluster)
	cable.add_point(src_cluster.rect_position + src_cluster.rect_size * src_cluster.rect_scale / 2.0)
	cable.add_point(dest_cluster.rect_position + dest_cluster.rect_size * dest_cluster.rect_scale / 2.0)
	cable.default_color = Color(0, 0, 0)
	call_deferred("add_child", cable)
