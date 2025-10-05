extends Node2D

const BALL_CLASS = preload("res://scenes/balls.tscn")

@onready var score_label: Label = $CanvasLayer/UI/VBoxContainer/Score
@onready var xp_amount: Label = $CanvasLayer/UI/VBoxContainer/XPBox/XPAmount
@onready var xp_bar: TextureProgressBar = $CanvasLayer/UI/VBoxContainer/XPBox/XPBar
@onready var xp_collider: Area2D = $XPCollider

var current_ball: RigidBody2D = null
var gamestage = 0

func _ready():
    spawn_new_ball()
    Globals.xp_changed.connect(_on_xp_change)
    

func spawn_new_ball():
    if current_ball:
        return

    current_ball = BALL_CLASS.instantiate()
    current_ball.spawn(gamestage)
    current_ball.holding = true
    add_child(current_ball)

    var screen_size = get_viewport().size
    current_ball.global_position = Vector2(screen_size.x / 2, 50)
    current_ball.freeze_ball(true)
    
    current_ball.play_grow_animation()
    

func _process(_delta):
    if current_ball:
        var mouse_x = get_viewport().get_mouse_position().x
        var sprite_size = $Bucket/Sprite2D.texture.get_size() * $Bucket/Sprite2D.global_scale
        current_ball.global_position.x = clamp(mouse_x, $Bucket/Sprite2D.global_position.x - (sprite_size.x / 2.0)+40, $Bucket/Sprite2D.global_position.x + (sprite_size.x / 2.0)-40)
    
    var score = calculate_score()
    score_label.text = "Score: " + str(score)
    if score > 50 && score < 200:
        gamestage = 1
    if score > 200:
        gamestage = 0

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("drop_ball") and current_ball and current_ball.can_drop == true:
        current_ball.freeze_ball(false)
        current_ball.holding = false
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
        if node is Ball && not node.freeze:
            node.move_to_location(xp_collider.global_position)
    
    Globals.update_xp(total_score)

func merge_all_balls():
    var all_balls: Dictionary={}
    for node in get_tree().current_scene.get_children():
        if node.is_class("RigidBody2D") && not node.freeze:
            var level = node.get_level()
            if not all_balls.has(level):
                all_balls[level] = []    
            all_balls[level].append(node)
    
    for level in all_balls.keys():
        var balls_in_level = all_balls[level]
        while balls_in_level.size() >= 2:
            var ball_a = balls_in_level.pop_back()
            var ball_b = balls_in_level.pop_back()
            var new_ball = ball_a.merge(ball_b)
            ball_a.queue_free()
            ball_b.queue_free()
            
func _on_xp_change():
    xp_amount.text = str(Globals.xp)
    xp_bar.value = Globals.xp


func _on_debug_end_game_pressed() -> void:
    clear_all_balls()

func _on_debug_merge_all_pressed() -> void:
    merge_all_balls()

func _on_xp_collider_body_entered(body: Node2D) -> void:
    
    print(body)
    print(body is Ball)
    if body is Ball:
        Globals.update_xp(level_to_value(body.lvl))
        body.queue_free()
    
        

func _on_xp_bar_value_changed(value: float) -> void:
    if value == 100:
        pass
