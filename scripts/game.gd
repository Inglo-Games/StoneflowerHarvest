extends Node2D

class_name GameWorld

# Preload classes
const Cluster = preload("res://scenes/cluster.tscn")
const Plunger = preload("res://scenes/plunger_btn.tscn")
const Connection = preload("connection.gd")
const SJTE = preload("sjte_alg.gd")

# UI elements
onready var length_label = $ui_layer/length_label

# Minimum distance allowed between clusters in pixels
const dist_threshold = 180

# List of all flower clusters in the level
var clusters = []

var plunger = 0

# Smallest path through the clusters and its length
var min_path = []
var min_len = -1

# Amount of connection length left to use
var remaining_len = -1

func _ready():
	
	# Add plunger_btn scene
	plunger = Plunger.instance()
	plunger.rect_position = Vector2(40, 450)
	$ui_layer.call_deferred("add_child", plunger)
	
	generate_clusters(4)

# Remove all lines and nodes in this level
func clear_level():
	for line in $line_layer.get_children():
		line.destroy()
	for i in range(len(clusters)-1):
		clusters[i+1].visible = false
		clusters[i+1].queue_free()

# Generate a number of flower clusters and place them about the screen randomly
func generate_clusters(num):
	
	# Make sure plunger node is always first
	clusters = [plunger]
	
	# Generate clusters
	for i in range(num):
		var new_cluster = Cluster.instance()
		new_cluster.rect_position = rand_coords()
		new_cluster.set_id(i+1)
		clusters.append(new_cluster)
		call_deferred("add_child", new_cluster)
	
	# Calculate the solution path
	calculate_min_path()

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
	
	# Draw the line
	var cable = Connection.new()
	cable._init_(src_cluster, dest_cluster)
	$line_layer.call_deferred("add_child", cable)
	
	# Update remaining length
	remaining_len -= src_cluster.rect_position.distance_to(dest_cluster.rect_position)
	length_label.text = str("%.2f" % remaining_len)

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
	var temp_min_path = []
	var min_length = INF
	for path in permutations:
		var length = calculate_path_length(dists, path)
		if length < min_length:
			min_length = length
			temp_min_path = path
	
	min_path = temp_min_path
	min_len = min_length
	remaining_len = min_length
	length_label.text = str("%.2f" % remaining_len)
	print("Shortest path: " + str(min_path))
	print("Length: " + str(min_length))

# Get the length of a given path
func calculate_path_length(length_table, path):
	var length = 0
	for i in range(len(path)-1):
		length += length_table[path[i]][path[i+1]]
	return length

# See if current path is the shortest path possibled
func check_solution():
	
	# Get the path drawn by the user, starting from the plunger
	var curr_path = [0]
	if len(clusters[0].connected_nodes) > 0:
		var next = clusters[0].connected_nodes[0]
		for i in range(len(clusters)-1):
			curr_path.append(next)
			var conns = clusters[next].connected_nodes
			conns.erase(curr_path[i])
			if len(conns) > 0:
				next = conns[0]
		print("Current path: " + str(curr_path))
	
	# Check that against the saved min path
	if curr_path == min_path:
		for cluster in clusters:
			cluster.fire_explosion()
		for line in $line_layer.get_children():
			line.destroy()
		
		# Go back to main menu once explosions are finished
		yield(get_tree().create_timer(2.4), "timeout")
		$ui_layer/plunger_btn.queue_free()
		get_tree().change_scene("res://scenes/menu.tscn")
		clear_level()
