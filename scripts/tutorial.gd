extends GameWorld

# Dialog window and label to give instructions to user
var dialog
var dialog_label

func _ready():
	
	tut_step = 0
	
	# Set up instruction dialog window
	dialog = DialogWindow.instance()
	dialog.rect_position = DIALOG_COORDS
	dialog_label = dialog.get_node("label")
	$ui_layer.add_child(dialog)
	
	dialog.connect("continue_tut", self, "_on_next_step")
	plunger.connect("continue_tut", self, "_on_next_step")
	
	# Make unused icons inivible
	$ui_layer/time_label.visible = false
	$ui_layer/ui_btns/skip_btn.visible = false
	
	# Only have one cluster initially
	generate_clusters(1)
	
	connect("continue_tut", self, "_on_next_step")
	_on_next_step()

# Overriding these functions to prevent timer from running
# warning-ignore:unused_argument
func _process(delta):
	pass
func start_timed_game():
	pass

# Generate some special cluster nodes for the tutorial
func generate_clusters(num):
	
	# Generate clusters and connect them to tutorial signal
	for i in range(num):
		var new_cluster = Cluster.instance()
		new_cluster.rect_position = rand_coords()
		new_cluster.set_id(i+1)
		new_cluster.connect("continue_tut", self, "_on_next_step")
		clusters.append(new_cluster)
		call_deferred("add_child", new_cluster)
	
	# Calculate the solution path
	calculate_min_path()

# Show the dialog box and insert some text
func display_dialog(text):
	dialog.visible = true
	dialog_label.text = text

# Display a new action based on previous one
func _on_next_step():
	match tut_step:
		0:
			display_dialog("Ah! You must be the new worker!")
		1:
			display_dialog("Well the Stoneflower Festival is tomorrow, so we have no time to waste.")
		2:
			display_dialog("See the group of flowers with dynamite in the middle?  Your job is going to be to harvest those flowers by blowing them up!")
		3:
			display_dialog("The dynamite is all set, you just need to connect the plunger over there to it with some detonation cord.")
		4:
			display_dialog("So what are you waiting for?  Click and drag to connect them!!")
		5:
			dialog.visible = false
		6:
			display_dialog("If the connection is good, push down on the plunger and show those flowers who's boss!")
		7:
			dialog.visible = false
		8:
			display_dialog("Oh, you're a natural!  Excellent work!  Now let's move on to the next site.")
		9:
			# Generate new level with 2 clusters
			generate_clusters(2)
			display_dialog("The next lesson: every bundle of dynamite can only have one line coming in and one line going out.")
		10:
			display_dialog("Two connections is all you get.")
		11:
			display_dialog("Except for the plunger -- it can only have one line coming out!")
		12:
			dialog.visible = false
		13:
			display_dialog("The next thing you'll need to remember is detonation cord is expensive.")
		14:
			display_dialog("The plunger is programmed to only work if you're using as little as possible, so plan your connections carefully.")
		15:
			display_dialog("The counter in the top left will tell you how much cord you have left to use.")
		16:
			dialog.visible = false
		17:
			display_dialog("Nicely done!")
		18:
			generate_clusters(2)
			display_dialog("Final thing: if you make a mistake, you can remove a connection.")
		19:
			display_dialog("Just double click on the connection you want to remove!")
		20:
			display_dialog("If the whole thing is wrong, hit that eraser icon to get rid of everything.")
		21:
			dialog.visible = false
		22:
			display_dialog("Well, I think that's all I can teach you.  Good luck, and get us some delicious flowers!")
		23:
			clear_ui_and_return()
	
	tut_step += 1
