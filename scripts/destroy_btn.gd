extends Control

func _ready():
	set_process_input(true)
	connect("gui_input", self, "_on_destroy_pressed")

func _on_destroy_pressed(event):
	if event is InputEventMouseButton:
		var lines = get_node("/root/game_world/line_layer").get_children()
		for line in lines:
			line.destroy()
		var world = get_node("/root/game_world")
		world.remaining_len = world.min_len
		get_node("/root/game_world/ui_layer/length_label").text = str("%.2f" % world.min_len)
