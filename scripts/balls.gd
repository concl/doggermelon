extends RigidBody2D

class_name Ball
const BALL_CLASS = preload("res://scenes/balls.tscn")

var lvl = 0
var merged = false
var can_drop = false
var holding = false


var spawn_probabilities : Dictionary = {
	Globals.GameStage.EARLY: {
		0: 0.8,
		1: 0.1,
		2: 0.05,
		3: 0.05
	},
	Globals.GameStage.MID: {
		0: 0.40,
		1: 0.30,
		2: 0.20,
		3: 0.10
	},
	Globals.GameStage.LATE: {
		0: 0.20,
		1: 0.40,
		2: 0.20,
		3: 0.15,
		4: 0.05,
	}
}

var sprite_levels = {
	0: preload("res://assets/balls_dogs/ball_pomeranian_rsz.png"),
	1: preload("res://assets/balls_dogs/ball_greyhound_rsz.png"),
	2: preload("res://assets/balls_dogs/ball_pug_rsz.png"),
	3: preload("res://assets/balls_dogs/ball_dachshund_rsz.png"),
	4: preload("res://assets/balls_dogs/ball_shiba_rsz.png"),
	5: preload("res://assets/balls_dogs/ball_poodle_rsz.png"),
	6: preload("res://assets/balls_dogs/ball_golden_rsz.png"),
	7: preload("res://assets/balls_dogs/ball_dane_rsz.png"),
	8: preload("res://assets/balls_dogs/ball_bernard_rsz.png"),
	9: preload("res://assets/balls_dogs/ball_clifford_rsz.png"),
	10: preload("res://assets/balls_dogs/ball_cat_rsz.png")
}

var sprite_levels_default = {
	0: preload("res://assets/balls_default/redball.png"),
	1: preload("res://assets/balls_default/orangeball.png"),
	2: preload("res://assets/balls_default/yellowball.png"),
	3: preload("res://assets/balls_default/ygreenball.png"),
	4: preload("res://assets/balls_default/greenball.png"),
	5: preload("res://assets/balls_default/lblueball.png"),
	6: preload("res://assets/balls_default/dblueball.png"),
	7: preload("res://assets/balls_default/purpleball.png")
}

func level_to_value(level) -> int:
	return 2**(level+1)

func get_scalar(level) -> Vector2:
	var starter = 0.04
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
	if other is not Ball:
		return
	if other == null || freeze || other.freeze || other.lvl != lvl:
		return
	if merged || other.merged:
		return
	merge(other)

func _on_merge_tween_finished(other, spawn_position: Vector2):
	var new_ball = spawn_merged_ball(spawn_position)
	
	# Clean up old ones immediately after spawning
	other.queue_free()
	queue_free()

func merge(other):
	if lvl == 10:
		return
	
	merged = true
	other.merged = true

	var sprite_self = $Sprite2D
	var sprite_other = other.get_node("Sprite2D")

	# --- Find lower ball position (use mostly the lower one's Y) ---
	var lower_ball = self if global_position.y > other.global_position.y else other
	var upper_ball = other if lower_ball == self else self

	# Blend positions: mostly lower, slightly averaged
	var avg_position = lower_ball.global_position * 0.75 + upper_ball.global_position * 0.25

	# --- Merge animation ---
	var tween = create_tween()
	tween.set_parallel(true)

	# Slight shrink + move toward each other
	tween.tween_property(sprite_self, "scale", sprite_self.scale * 0.8, 0.12)
	tween.tween_property(sprite_other, "scale", sprite_other.scale * 0.8, 0.12)
	tween.tween_property(self, "global_position", avg_position, 0.12)
	tween.tween_property(other, "global_position", avg_position, 0.12)

	# --- Spawn new ball just after they meet ---
	print("asdf")
	tween.connect("finished", Callable(self, "_on_merge_tween_finished").bind(other, avg_position))


func move_to_location(location: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "global_position", location, 1.0)
	tween.connect("finished", remove)
	freeze_ball(true)
	

func remove():
	Globals.update_xp(level_to_value(lvl))
	queue_free()

func spawn_merged_ball(location: Vector2):
	var new_ball = BALL_CLASS.instantiate()
	new_ball.lvl = lvl + 1
	get_parent().add_child(new_ball)
	new_ball.global_position = location
	print("spawned")
	print(new_ball)
	print(new_ball.global_position)
	return new_ball
