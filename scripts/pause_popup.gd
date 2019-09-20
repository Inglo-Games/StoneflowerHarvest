extends PopupPanel

signal quit_game

func _on_resume_pressed():
	get_tree().set_pause(false)
	queue_free()

func _on_quit_pressed():
	get_tree().set_pause(false)
	emit_signal("quit_game")
	queue_free()
