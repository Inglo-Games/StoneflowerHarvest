extends GameNode

# This defines the behavior of a cluster of stoneflowers
class_name Cluster

func _ready():
	max_connections = 2
	available_connections = 2
	set_process_input(true)

func set_id(num):
	node_id = num

func fire_explosion():
	# Display explosion effect
	$expl_particles.emitting = true
	
	# Remove relevant sprites when they're hidden
	$dynamite.visible = false
	$stem01.visible = false
	$stem02.visible = false
	$stem03.visible = false
	$stem04.visible = false
	$AnimationPlayer.play("fall")
