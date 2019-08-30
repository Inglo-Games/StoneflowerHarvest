extends Node2D

class_name GameWorld

# Preload classes
const Cluster = preload("res://scenes/cluster.tscn")
const Plunger = preload("res://scenes/plunger_btn.tscn")
const DialogWindow = preload("res://scenes/dialog_window.tscn")
const Connection = preload("connection.gd")
const SJTE = preload("sjte_alg.gd")

# Minimum distance allowed between clusters in pixels
const DIST_THRESHOLD = 180

# Amount of time per game in seconds (non-tutorial only)
const GAME_LENGTH = 60.0

# Positions of plunger icon and dialog boxes
const PLUNGER_COORDS = Vector2(48, 740)
const DIALOG_COORDS = Vector2(0, 660)

signal add_length

# UI elements
onready var dest_mode_btn = $ui_layer/ui_btns/destroy_mode_btn
onready var skip_btn = $ui_layer/ui_btns/skip_btn
onready var temp_line = $ui_layer/temp_line
onready var length_label = $ui_layer/length_label
onready var time_label = $ui_layer/time_label
onready var timer = $timer
onready var sfx_expl = $sfx_expl
onready var sfx_conn = $sfx_conn
onready var sfx_reel = $sfx_reel
var plunger

# Keep track of whether we're in the tutorial or not
var is_tutorial = false

# Track if user is actively drawing a line
var is_drawing = false

# List of all flower clusters in the level
var clusters = []

# Smallest path through the clusters and its length
var min_path = []
var min_len = -1

# Amount of connection length left to use
var remaining_len = -1

# Number of clusters harvested
var harvested = 0

# Number of skips the user has
var skips_left = 3

func _ready():
	
	# Add plunger_btn scene
	plunger = Plunger.instance()
	plunger.rect_position = PLUNGER_COORDS
	$ui_layer.call_deferred("add_child", plunger)
	clusters = [plunger]
	
	# Setup line to show while drawing
	temp_line.add_point(Vector2(0, 0))
	temp_line.add_point(Vector2(0, 0))
	temp_line.visible = false

	# Connect buttons to functions
	skip_btn.connect("pressed", self, "pass_level")
	
	# Set up timer 
	time_label.text = str("%3.2f" % GAME_LENGTH)
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.connect("timeout", self, "_on_game_timeout")
	
	randomize()
	start_timed_game()

func _process(delta):
	
	# Update timer label
	if timer.time_left >= 0:
		time_label.text = str("%3.2f" % timer.time_left)
	
	# Show dragging line
	if is_drawing and Input.is_mouse_button_pressed(BUTTON_LEFT): 
		temp_line.points[1] = get_viewport().get_mouse_position()
	elif is_drawing:
		stop_drawing()

# Re-draws the line that shows the user is drawing
func start_drawing(pos):
	temp_line.points[0] = pos
	temp_line.points[1] = pos
	temp_line.visible = true
	sfx_reel.play()
	is_drawing = true

# Function to run when player is done drawing a line
func stop_drawing():
	is_drawing = false
	temp_line.visible = false
	sfx_reel.stop()

# Function to set up and begin a timed game
func start_timed_game():
	timer.start(GAME_LENGTH)
	generate_clusters(randi() % 2 + 3)

# Re-add a removed connection's length to total
func _on_add_length(length):
	remaining_len += length
	length_label.text = str("%.2f" % remaining_len)

# End a timed game 
func _on_game_timeout():
	
	timer.stop()
	time_label.text = "0.00"
	
	# Show dialog telling user their score
	var dialog = DialogWindow.instance()
	dialog.rect_position = DIALOG_COORDS
	dialog.get_node("label").text = "Finished!\nTotal clusters harvested: %d" % harvested
	$ui_layer.call_deferred("add_child", dialog)
	dialog.connect("gui_input", self, "_on_end_dialog_mouse")

# Check if user clicked on dialog to return to menu
func _on_end_dialog_mouse(ev):
	if ev is InputEventMouseButton and not ev.pressed:
		clear_ui_and_return()

# Remove all lines and nodes in this level
func clear_level():
	for line in $line_layer.get_children():
		line.destroy()
	for i in range(len(clusters)-1):
		clusters[i+1].visible = false
		clusters[i+1].queue_free()
	clusters = [plunger]

# Remove all UI elements for when we go back to the menu
func clear_ui_and_return():
	$line_layer.queue_free()
	$ui_layer.queue_free()
	for node in $ui_layer.get_children():
		node.visible = false
		node.queue_free()
	queue_free()
	get_tree().change_scene("res://scenes/menu.tscn")

# Generate a number of flower clusters and place them about the screen randomly
func generate_clusters(num):
	
	# Generate clusters and add them to screen
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
	var temp_pos = Vector2(rand_range(0.05, 0.8) * win.x, rand_range(0.2, 0.7) * win.y)
	
	# Make sure new cluster isn't too close to others
	var too_close = true
	while too_close:
		too_close = false
		for c in clusters:
			if temp_pos.distance_to(c.rect_position) < DIST_THRESHOLD:
				too_close = true
		if not too_close:
			return temp_pos
		else:
			temp_pos = Vector2(rand_range(0.05, 0.8) * win.x, rand_range(0.2, 0.7) * win.y)

# Callback function to draw a line between two clusters
func connect_clusters(src_cluster, dest_cluster):
	
	# Draw the line
	var cable = Connection.new()
	cable._init_(src_cluster, dest_cluster)
	$line_layer.call_deferred("add_child", cable)
	
	# Set up signal for removing connection
	cable.connect("add_length", self, "_on_add_length")
	
	# Update remaining length
	remaining_len -= src_cluster.rect_position.distance_to(dest_cluster.rect_position)
	length_label.text = str("%.2f" % remaining_len)
	
	# Play connection sound
	sfx_conn.play()

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
	
	# Check that against the saved min path
	if curr_path == min_path:
		
		# Record how many clusters were harvested
		var clusters_harvested = len(clusters) - 1
		harvested += clusters_harvested
		
		for cluster in clusters:
			cluster.fire_explosion()
		for line in $line_layer.get_children():
			line.destroy()
		sfx_expl.play()
		
		# Clear the old clusters once explosions are finished
		yield(get_tree().create_timer(2.4), "timeout")
		clear_level()
		
		# If not in the tutorial, generate new clusters
		if not is_tutorial:
			
			# Add time to game timer
			timer.start(timer.time_left + clusters_harvested + 1)
		
			# Number of clusters increases as more flowers are harvested
			generate_clusters(randi() % 3 + floor(log(harvested)) + 3)
		
		return true
	
	else:
		return false

# Skip the current level
func pass_level():
	
	skips_left -= 1
	
	# Change the icon for the pass button
	if skips_left == 0:
		skip_btn.visible = false
	else:
		skip_btn.texture_normal = load("res://assets/icons/skip%d.png" % skips_left)
	
	# Clear level and generate a new one
	clear_level()
	generate_clusters(randi() % 3 + floor(log(harvested)) + 3)
