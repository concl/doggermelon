extends StaticBody2D

func _ready():
    var screen_size = get_viewport().get_visible_rect().size
    global_scale = Vector2(0.8,0.8)
    position = screen_size / 2
    print("bucket",position)
