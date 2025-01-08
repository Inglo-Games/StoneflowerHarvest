extends Control

onready var GameWorld = preload("res://scenes/game_world.tscn")
onready var Tutorial = preload("res://scripts/tutorial.gd")


func _on_play_pressed():
	get_tree().change_scene("res://scenes/game_world.tscn")

func _on_tutorial_pressed():
	# Manually change scenes so we can use the tutorial script instead of the
	# normal one
	var root = get_tree().get_root()
	var menu = root.get_node("menu")
	root.remove_child(menu)
	menu.queue_free()
	var tutorial = GameWorld.instance()
	tutorial.set_script(Tutorial)
	root.add_child(tutorial)

func _on_quit_game():
	get_tree().quit()
