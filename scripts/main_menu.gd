extends Control

onready var GameWorld = preload("res://scenes/game_world.tscn")
onready var Tutorial = preload("res://scripts/tutorial.gd")

func _ready():
	
	# Set up menu buttons
	$container/play_btn.connect("pressed", self, "play_game")
	$container/tut_btn.connect("pressed", self, "play_tutorial")
	$container/quit_btn.connect("pressed", self, "quit_game")

func play_game():
	get_tree().change_scene("res://scenes/game_world.tscn")

func play_tutorial():
	
	# Manually change scenes so we can use the tutorial script instead of the
	# normal one
	var root = get_tree().get_root()
	var menu = root.get_node("menu")
	root.remove_child(menu)
	menu.queue_free()
	var tutorial = GameWorld.instance()
	tutorial.set_script(Tutorial)
	root.add_child(tutorial)

func quit_game():
	get_tree().quit()
