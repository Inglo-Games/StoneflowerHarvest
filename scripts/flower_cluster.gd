extends Control

class_name Cluster

func _ready():
	
	# Create a shape to display
	var shape = Sprite.new()
	call_deferred("add_child", shape)
	shape.set_texture(load("res://assets/icons/dynamite.png"))
	
	rect_size = shape.get_texture().get_size()
	
	# Get input
	set_process_input(true)

func can_drop_data(position, data):
	return (typeof(data) == typeof(self) and data != self)

func drop_data(position, data):
	print("Got some dropped data!")
	get_parent().connect_clusters(data, self)

func get_drag_data(position):
	print("Dropping data...")
	return self
