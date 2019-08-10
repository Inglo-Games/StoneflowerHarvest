extends GameNode

# This defines the behavior of a cluster of stoneflowers
class_name Cluster

func _ready():
	
	max_connections = 2
	available_connections = 2
	
	# Create a shape to display
	var shape = Sprite.new()
	call_deferred("add_child", shape)
	shape.set_texture(load("res://assets/images/patch_base.exr"))
	shape.centered = false
	
	rect_size = shape.get_texture().get_size()
	rect_scale = Vector2(0.1, 0.1)
	
	# Get input
	set_process_input(true)
