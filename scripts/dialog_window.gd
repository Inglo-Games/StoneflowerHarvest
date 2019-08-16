extends Control

# Base game node
var game_root

func _ready():
	game_root = get_tree().get_root().get_node("game_world")
	set_process_input(true)
	connect("gui_input", self, "_on_dialog_mouse")

func _on_dialog_mouse(ev):
	if ev is InputEventMouseButton and not ev.pressed:
		game_root.emit_signal("continue_tut")
