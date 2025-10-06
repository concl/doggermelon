extends Node3D

func _process(delta: float) -> void:
	
	if get_parent().get_parent().visible == false:
		hide()
	else:
		show()
