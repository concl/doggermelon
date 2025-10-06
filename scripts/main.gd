extends Node2D

const BALL_CLASS = preload("res://scenes/balls.tscn")
@onready var gatcha: CanvasLayer = $Gatcha

@onready var game: CanvasLayer = $Game
@onready var score_label: Label = $Game/UI/VBoxContainer/Score
@onready var xp_amount: Label = $Game/UI/VBoxContainer/XPBox/XPAmount
@onready var xp_bar: TextureProgressBar = $Game/UI/VBoxContainer/XPBox/XPBar
@onready var bucket_sprite = $Game/Bucket/Sprite2D
@onready var xp_label: Label = $Game/UI/VBoxContainer/XPBox/XPLabel

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
	game.add_child(current_ball)

	var screen_size = get_viewport().size
	current_ball.global_position = Vector2(screen_size.x / 2, 50)
	current_ball.freeze_ball(true)
	
	current_ball.play_grow_animation()
	

func _process(_delta):
	if current_ball:
		var mouse_x = get_viewport().get_mouse_position().x
		
		var sprite_size = bucket_sprite.texture.get_size() * bucket_sprite.global_scale
		current_ball.global_position.x = clamp(mouse_x, bucket_sprite.global_position.x - (sprite_size.x / 2.0)+40, bucket_sprite.global_position.x + (sprite_size.x / 2.0)-40)
	
	var score = calculate_score()
	score_label.text = "Score: " + str(score)
	
	if score > 50 && score < 200:
		gamestage = 1
	if score > 200:
		gamestage = 2
	
	check_ceiling_balls()

func check_ceiling_balls() -> void:
	var velocity_threshold = 5.0
	
	var ceiling : Area2D = $Game/Ceiling
	if ceiling == null:
		return
	
	for node in ceiling.get_overlapping_bodies():
		if node is Ball:
			if node.linear_velocity.length() <= velocity_threshold:
				# Ball is touching ceiling and almost stopped, trigger clear
				clear_all_balls()
				return  # stop after first detection

func _unhandled_input(event: InputEvent) -> void:
	
	
	if game.visible and event.is_action_pressed("drop_ball") and current_ball and current_ball.can_drop == true:
		current_ball.freeze_ball(false)
		current_ball.holding = false
		current_ball = null
		spawn_new_ball()

func level_to_value(level) -> int:
	return 2**(level+1)

func calculate_score() -> int:
	var score = 0
	for node in game.get_children():
		if node is RigidBody2D && not node.freeze:
			score += level_to_value(node.lvl)
	return score

func clear_all_balls():
	var total_score = 0
	for node in game.get_children():
		if node is Ball && not node.freeze:
			node.move_to_location(xp_label.global_position)
	
	Globals.update_xp(total_score)

func merge_all_balls():
	var all_balls: Dictionary={}
	for node in game.get_children():
		if node.is_class("RigidBody2D") && not node.freeze && node.lvl != 10:
			var level = node.lvl
			if not all_balls.has(level):
				all_balls[level] = []    
			all_balls[level].append(node)
	
	for level in all_balls.keys():
		var balls_in_level = all_balls[level]
		while balls_in_level.size() >= 2:
			var ball_a = balls_in_level.pop_back()
			var ball_b = balls_in_level.pop_back()
			#var new_ball = ball_a.merge(ball_b)
			ball_a.merge(ball_b)
			
func threshold_clear():
	var max_lvl = 0
	for node in game.get_children():
		if node.is_class("RigidBody2D") && not node.freeze:
			if node.lvl > max_lvl:
				max_lvl = node.lvl
		
	var threshold = int(max_lvl/2)
	for node in game.get_children():
		if node.is_class("RigidBody2D") && not node.freeze:
			if node.lvl < threshold:
				node.move_to_location(xp_label.global_position)
	


func _on_xp_change():
	xp_amount.text = str(Globals.xp)
	xp_bar.value = Globals.xp


func _on_debug_end_game_pressed() -> void:
	clear_all_balls()

func _on_debug_merge_all_pressed() -> void:
	merge_all_balls()

		

func _on_xp_bar_value_changed(value: float) -> void:
	if value == 100:
		pass


func _on_chest_button_pressed() -> void:
	game.hide()
	gatcha.show()


func _on_button_pressed() -> void:
	game.show()
	gatcha.hide()


func _on_half_clear_pressed() -> void:
	threshold_clear()
