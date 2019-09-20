extends Node

# Admob variables
const adBannerId = "ca-app-pub-XXX/XXX"
var admob = null

func _ready():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(false, get_instance_id())
		admob.loadBanner(adBannerId, false)
