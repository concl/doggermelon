extends RigidBody2D



const BALL_CLASS = preload("res://scenes/balls.tscn")


@onready var sprite = $Sprite2D

var sprite_levels = {
    0: preload("res://assets/redball.png"),
    1: preload("res://assets/orangeball.png"),
    2: preload("res://assets/yellowball.png"),
    3: preload("res://assets/ygreenball.png"),
    4: preload("res://assets/greenball.png"),
    5: preload("res://assets/lblueball.png"),
    6: preload("res://assets/dblueball.png"),
    7: preload("res://assets/purpleball.png")
}

func get_scalar(level) -> Vector2:
    var starter = 0.01
    var diff = 0.01
    var new_scale = level*diff + starter
    return Vector2(new_scale,new_scale)

var lvl = 0

func setup(level):
    lvl = level

func _ready() -> void:
    sprite.texture = sprite_levels[lvl]
    sprite.scale = get_scalar(lvl)
    $CollisionShape2D.scale = sprite.scale
    global_position = Vector2(get_viewport().size.x/2, 0)



func merge(other):
    var new_ball = BALL_CLASS.instantiate()
    new_ball.setup(lvl+1)
    get_tree().current_scene.add_child(new_ball)
    new_ball.global_position.y = global_position.y - 100
    #queue_free()

func _on_area_2d_mouse_entered() -> void:
    if lvl<7:
        merge(null)
