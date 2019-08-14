extends Control

func _ready():
	set_process_input(true)
	connect("gui_input", self, "destroy_all_conns")

func destroy_all_conns(event):
	if event is InputEventMouseButton:
		var lines = get_node("/root/game_world/line_layer").get_children()
		for line in lines:
			line.destroy()
		var world = get_node("/root/game_world")
		world.remaining_len = world.min_len
		get_node("/root/game_world/ui_layer/length_label").text = str("%.2f" % world.min_len)
