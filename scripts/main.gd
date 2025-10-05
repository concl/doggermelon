extends Node2D

const BALL_CLASS = preload("res://scenes/balls.tscn")

var current_ball: RigidBody2D = null
var spawn_level = 0

func _ready():
    spawn_new_ball()

func spawn_new_ball():
    if current_ball:
        return

    current_ball = BALL_CLASS.instantiate()
    current_ball.setup(spawn_level)
    add_child(current_ball)

    var screen_size = get_viewport().size
    current_ball.global_position = Vector2(screen_size.x / 2, 50)
    current_ball.freeze_ball(true)
    
    current_ball.play_grow_animation()
    

func _process(_delta):
    if current_ball:
        var mouse_x = get_viewport().get_mouse_position().x
        current_ball.global_position.x = clamp(mouse_x, 50, get_viewport().size.x - 50)

func _input(event):
    if event.is_action_pressed("drop_ball") and current_ball and current_ball.can_drop == true:
        current_ball.freeze_ball(false)
        current_ball = null
        spawn_new_ball()
