extends Line2D

# This class defines the behavior of a connection between two patches
class_name Connection

signal add_length

# List of clusters/plunger this line connects
var nodes = []

func _input(ev):
	if ev is InputEventMouseButton and ev.doubleclick:
		
		# Make sure click is between the two points
		var left_bound = min(nodes[0].rect_global_position.x, nodes[1].rect_global_position.x)
		var right_bound = max(nodes[0].rect_global_position.x, nodes[1].rect_global_position.x)
		var top_bound = min(nodes[0].rect_global_position.y, nodes[1].rect_global_position.y)
		var bottom_bound = max(nodes[0].rect_global_position.y, nodes[1].rect_global_position.y)
		if ev.global_position.x > left_bound \
				and ev.global_position.x < right_bound \
				and ev.global_position.y > top_bound \
				and ev.global_position.y < bottom_bound:
			
			# Add connection length back to counter
			var length = nodes[0].rect_position.distance_to(nodes[1].rect_position)
			emit_signal("add_length", length)
			
			destroy()

# Set up connection line
func _init_(src_cluster, dest_cluster):
	
	# Save clusters for future refence
	nodes.append(src_cluster)
	nodes.append(dest_cluster)
	
	# Setup endpoints
	add_point(src_cluster.rect_position + src_cluster.rect_size * src_cluster.rect_scale / 2.0)
	add_point(dest_cluster.rect_position + dest_cluster.rect_size * dest_cluster.rect_scale / 2.0)
	
	# Setup line's visuals
	set_begin_cap_mode(Line2D.LINE_CAP_ROUND)
	set_end_cap_mode(Line2D.LINE_CAP_ROUND)
	set_texture_mode(Line2D.LINE_TEXTURE_TILE)
	set_texture(load("res://assets/images/cord_pattern.tres"))

# Destroy this connection and update clusters accordingly
func destroy():
	nodes[0].add_connection()
	nodes[1].add_connection()
	nodes[0].connected_nodes.erase(nodes[1].node_id)
	nodes[1].connected_nodes.erase(nodes[0].node_id)
	self.queue_free()
