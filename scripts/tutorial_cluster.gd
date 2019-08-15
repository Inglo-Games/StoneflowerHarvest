extends Cluster

func _ready():
	pass

# Special drag_data function that interacts with tutorial
func get_drag_data(position):
	
	# Prompt next tutorial step if appropriate
	if [5, 12].has(GameRoot.step):
		GameRoot.next_step("")
	
	return self
