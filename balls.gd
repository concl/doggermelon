extends RigidBody2D


const BALL_CLASS = preload("res://scenes/balls.tscn")


@onready var sprite = $Sprite2D

var sprite_levels = {
    0: preload("res://assets/redball.png"),
    1: preload("res://assets/orangeball.png")
}

var lvl = 0

func setup(level):
    lvl = level
    print("setup",lvl)

func _ready() -> void:
    print("ready",lvl)
    sprite.texture = sprite_levels[lvl]

func merge(other):
    var new_ball = BALL_CLASS.instantiate()
    new_ball.setup(lvl+1)
    
    get_tree().current_scene.add_child(new_ball)
    new_ball.global_position.y = global_position.y + 10
    print("-:",lvl)


func _on_area_2d_mouse_entered() -> void:
    if lvl<1:
        merge(null)
