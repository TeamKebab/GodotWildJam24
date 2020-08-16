extends Node


onready var entities_container : Node = $YSort


func _ready():
	Game.connect("day_ended", self, "restart")
	

func restart():
	for entity in entities_container.get_children():
		if entity.has_method("restart"):
			entity.restart()
