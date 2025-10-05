extends Node2D

const BALL_CLASS = preload("res://scenes/balls.tscn")

var current_ball: RigidBody2D = null
var gamestage = 0

func _ready():
    spawn_new_ball()

func spawn_new_ball():
    if current_ball:
        return

    current_ball = BALL_CLASS.instantiate()
    current_ball.spawn(gamestage)
    add_child(current_ball)

    var screen_size = get_viewport().size
    current_ball.global_position = Vector2(screen_size.x / 2, 50)
    current_ball.freeze_ball(true)
    
    current_ball.play_grow_animation()
    

func _process(_delta):
    if current_ball:
        var mouse_x = get_viewport().get_mouse_position().x
        current_ball.global_position.x = clamp(mouse_x, 50, get_viewport().size.x - 50)
    
    var score = calculate_score()
    $Score.text = "Score: " + str(score)
    if score > 50 && score < 200:
        gamestage = 1
    if score > 200:
        gamestage = 0

func _input(event):
    if event.is_action_pressed("drop_ball") and current_ball and current_ball.can_drop == true:
        current_ball.freeze_ball(false)
        current_ball = null
        spawn_new_ball()

func level_to_value(level) -> int:
    return 2**(level+1)

func calculate_score() -> int:
    var score = 0
    for node in get_tree().current_scene.get_children():
        if node is RigidBody2D:
            score += level_to_value(node.lvl)
    return score

func clear_all_balls():
    var total_score = 0
    for node in get_tree().current_scene.get_children():
        if node.is_class("RigidBody2D"):
            var xp = level_to_value(node.lvl)
            node.queue_free()
