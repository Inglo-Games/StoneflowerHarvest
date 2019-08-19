extends Line2D

# This class defines the behavior of a connection between two patches
class_name Connection

var nodes = []

func _ready():
	default_color = Color(0, 0, 0)

func _init_(src_cluster, dest_cluster):
	
	# Save clusters for future refence
	nodes.append(src_cluster)
	nodes.append(dest_cluster)
	
	# Setup endpoints
	add_point(src_cluster.rect_position + src_cluster.rect_size * src_cluster.rect_scale / 2.0)
	add_point(dest_cluster.rect_position + dest_cluster.rect_size * dest_cluster.rect_scale / 2.0)
	
	# Load pattern image from disk
	var img = Image.new()
	img.load("res://assets/images/cord_pattern.png")
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	# Setup line's visuals
	set_begin_cap_mode(Line2D.LINE_CAP_ROUND)
	set_end_cap_mode(Line2D.LINE_CAP_ROUND)
	set_texture_mode(Line2D.LINE_TEXTURE_TILE)
	set_texture(tex)

# Destroy this connection and update clusters accordingly
func destroy():
	nodes[0].add_connection()
	nodes[1].add_connection()
	nodes[0].connected_nodes.erase(nodes[1].node_id)
	nodes[1].connected_nodes.erase(nodes[0].node_id)
	self.queue_free()
