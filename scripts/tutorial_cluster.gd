extends Cluster

# Special drop_data function that interacts with tutorial
func drop_data(position, data):
	GameRoot.connect_clusters(data, self)
	self.remove_conn()
	data.remove_conn()
	connected_nodes.append(data.node_id)
	data.connected_nodes.append(node_id)
	
	# Prompt next tutorial step if appropriate
	if [6, 13].has(GameRoot.step):
		emit_signal("continue_tut")
