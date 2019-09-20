extends Control

onready var GameWorld = preload("res://scenes/game_world.tscn")
onready var Tutorial = preload("res://scripts/tutorial.gd")


func _ready():
	
	# Show banner ad at bottom if possible
	if Ads.admob != null:
		Ads.admob.showBanner()

func _on_play_pressed():
	
	if Ads.admob != null:
		Ads.admob.hideBanner()
	
	get_tree().change_scene("res://scenes/game_world.tscn")

func _on_tutorial_pressed():
	
	if Ads.admob != null:
		Ads.admob.hideBanner()
	
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
