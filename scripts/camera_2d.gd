extends Camera2D

func _ready():
    var screen_size = get_viewport().get_visible_rect().size
    position = screen_size / 2
    print("camera",position)
