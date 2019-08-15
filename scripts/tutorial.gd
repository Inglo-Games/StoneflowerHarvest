extends GameWorld

onready var DialogWindow = preload("res://scenes/dialog_window.tscn")

# Dialog window to give instructions to user
var dialog

# Keep track of what step the user is on
var step = 0

func _ready():
	
	# Set up instruction dialog window
	dialog = DialogWindow.instance()
	dialog.rect_position = Vector2(0, get_viewport().size.y - dialog.rect_size.y)
	dialog.connect("gui_input", self, "next_step")
	
	# Remove all UI elements that aren't needed yet
	$ui_layer/length_label.visible = false
	
	# Only have one cluster initially
	generate_clusters(1)

# Show the dialog box and insert some text
func display_dialog(text):
	dialog.visible = true
	dialog.get_node("dialog_window/label").text = text

# Display a new action based on previous one
func next_step(event):
	match step:
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
			# Clear old clusters and connections
			for line in $line_layer.get_children():
				line.destroy()
			for c in clusters:
				c.queue_free()
			clusters = [$ui_layer/plunger_btn]
			generate_clusters(2)
			display_dialog("The next lesson: every bundle of dynamite can only have one line coming in and one line going out.")
		10:
			display_dialog("Two connections is all you get.")
		11:
			display_dialog("Except for the plunger -- it can only have one line coming out!")
		12:
			dialog.visible = false
		13:
			display_dialog("The last thing you'll need to remember is detonation cord is expensive.")
		14:
			display_dialog("The plunger is programmed to only work if you're using as little as possible, so plan your connections carefully.")
		15:
			dialog.visible = false
		16:
			display_dialog("Well, I think that's all I can teach you.  Good luck, and get us some delicious flowers!")
	
	step += 1
