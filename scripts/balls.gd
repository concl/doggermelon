extends RigidBody2D

const BALL_CLASS = preload("res://scenes/balls.tscn")

var lvl = 0
var merged = false
var can_drop = false


var spawn_probabilities : Dictionary = {
    Globals.GameStage.EARLY: {
        0: 0.9,
        1: 0.1,
        2: 0,
        3: 0 
    },
    Globals.GameStage.MID: {
        1: 0.40,
        2: 0.30,
        3: 0.20,
        4: 0.10
    },
    Globals.GameStage.LATE: {
        2: 0.30,
        3: 0.30,
        4: 0.25,
        5: 0.10,
        6: 0.05
    }
}

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


func freeze_ball(value: bool):
    freeze = value
    if freeze:
        collision_layer = 0
        collision_mask = 0
    else:
        collision_layer = 1
        collision_mask = 1

func choose_level_by_probability(prob_table: Dictionary) -> int:
    var rand_val := randf()
    var cumulative := 0.0
    var keys := prob_table.keys()
    keys.sort()
    for level in keys:
        cumulative += prob_table[level]
        if rand_val <= cumulative:
            return level
    return prob_table.keys().back() # fallback

func setup(level):
    lvl = level

func spawn(stage: int) -> void:
    var prob_table : Dictionary = spawn_probabilities[stage]
    lvl = choose_level_by_probability(prob_table)
    
    lvl = clamp(lvl, 0, sprite_levels.size() - 1)
    
    # Update visuals
    $Sprite2D.texture = sprite_levels[lvl]
    $Sprite2D.scale = get_scalar(lvl)
    $CollisionShape2D.scale = $Sprite2D.scale
    $Area2D/CollisionShape2D.scale = $Sprite2D.scale
    
    play_grow_animation()

    
    

func _ready() -> void:
    $Sprite2D.texture = sprite_levels[lvl]
    $Sprite2D.scale = get_scalar(lvl)
    $CollisionShape2D.scale = $Sprite2D.scale
    $Area2D/CollisionShape2D.scale = $Sprite2D.scale
    #global_position = Vector2(get_viewport().size.x/2, 0)

func play_grow_animation():
    $Sprite2D.scale = Vector2(0.0001, 0.0001)
    var tween = create_tween()
    tween.tween_property($Sprite2D, "scale", get_scalar(lvl), 0.3)
    tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished():
    can_drop = true


func _on_area_2d_area_entered(area: Area2D) -> void:
    var other = area.get_parent()
    if other == null || freeze || other.freeze || other.lvl != lvl:
        return
    if merged || other.merged:
        return
    merge(other)

func merge(other):
    merged = true
    other.merged = true

    var avg_position = (global_position + other.global_position) / 2
    spawn_merged_ball(avg_position)
    
    other.queue_free()
    queue_free()

func spawn_merged_ball(location: Vector2):
    var new_ball = BALL_CLASS.instantiate()
    new_ball.setup(lvl+1)
    get_tree().current_scene.add_child(new_ball)
    new_ball.global_position = location

func get_level() -> int:
    return lvl
