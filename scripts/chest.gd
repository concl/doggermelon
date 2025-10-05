extends Node3D

func _process(delta: float) -> void:
    print(get_parent().get_parent())
    print(get_parent().get_parent().visible)
    
    if get_parent().get_parent().visible == false:
        hide()
    else:
        show()
