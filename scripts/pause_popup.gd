extends PopupPanel

func _on_resume_pressed():
	get_tree().set_pause(false)
	queue_free()

func _on_quit_pressed():
	get_tree().change_scene("res://scenes/menu.tscn")
