extends Node2D

const Cluster = preload("res://scenes/cluster.tscn")
const Connection = preload("connection.gd")

const SJTE = preload("sjte_alg.gd")

# Minimum distance allowed between clusters in pixels
const dist_threshold = 180

# List of all flower clusters in the level
var clusters = []

func _ready():
	clusters.append($ui_layer/plunger_btn)
	generate_clusters(5)
	calculate_min_path()

# Generate a number of flower clusters and place them about the screen randomly
func generate_clusters(num):
	# warning-ignore:unused_variable
	for i in range(num):
		var new_cluster = Cluster.instance()
		new_cluster.rect_position = rand_coords()
		clusters.append(new_cluster)
		call_deferred("add_child", new_cluster)

# Generate a set of random coordinates within the screen
func rand_coords():
	var win = get_viewport().size
	var temp_pos = Vector2(rand_range(0.1, 0.9) * win.x, rand_range(0.1, 0.9) * win.y)
	
	# Make sure new cluster isn't too close to others
	for c in clusters:
		if temp_pos.distance_to(c.rect_position) < dist_threshold:
			temp_pos = rand_coords()
	return temp_pos

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
			dists[i].append(0)
			dists[i][j] = clusters[i].rect_position.distance_to(
					clusters[j].rect_position)
	
	# Use Steinhaus-Johnson-Trotter alg to generate all paths
	var permutations = SJTE.sjte(len(clusters)-1)
	for list in permutations:
		list.push_front(0)
	
	# Iterate over all paths that start at 0, keeping track of current minimum
	var min_path = []
	var min_length = INF
	for path in permutations:
		var length = calculate_path_length(dists, path)
		if length < min_length:
			min_length = length
			min_path = path
	print("Shortest path: " + str(min_path))
	print("Length: " + str(min_length))

# Get the length of a given path
func calculate_path_length(length_table, path):
	var length = 0
	for i in range(len(path)-1):
		length += length_table[path[i]][path[i+1]]
	return length
