extends Control

signal continue_tut

func _ready():
	set_process_input(true)
	connect("gui_input", self, "_on_dialog_mouse")

func _on_dialog_mouse(ev):
	if ev is InputEventMouseButton and not ev.pressed:
		emit_signal("continue_tut")
