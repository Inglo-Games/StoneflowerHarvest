extends Node2D

const Cluster = preload("flower_cluster.gd")
const Connection = preload("connection.gd")

const SJTE = preload("sjte_alg.gd")

# List of all flower clusters in the level
var clusters = []

func _ready():
	clusters.append($ui_layer/plunger_btn)
	generate_clusters(5)
	SJTE.sjte(len(clusters)-1)

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

# Calculate the shortest Hamiltonian path
func calculate_min_path():
	# First generate a table of distances between all nodes
	var dists = []
	for i in range(len(clusters)):
		dists.append([])
		for j in range(len(clusters)):
			dists[i][j] = clusters[i].rect_position.distance_to(
					clusters[j].rect_position)
	
	# Use Steinhaus-Johnson-Trotter alg to generate all paths
	var permutations = SJTE.sjte(len(clusters)-1)
	
	# Iterate over all paths that start at 0, keeping track of current minimum
	# See Steinhaus-Johnson-Trotter algorithm
	var min_path = []
	var min_length = INF

# Get the length of a given path
func calculate_path_length(length_table, path):
	var length = 0
	for i in range(len(path)-1):
		length += length_table[path[i]][path[i+1]]
	return length
