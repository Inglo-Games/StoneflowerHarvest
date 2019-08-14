extends Control

onready var GameRoot = get_node("/root/game_world")

func _ready():
	set_process_input(true)
	connect("gui_input", self, "set_mode_create")

func set_mode_create():
	GameRoot.conn_mode = "create"
