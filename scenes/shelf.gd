extends StaticBody2D

func _ready():
    var screen_size = get_viewport().get_visible_rect().size
    global_scale = Vector2(0.4,0.4)
    global_position = Vector2(200, screen_size.y / 2)
    print("shelf",position)
