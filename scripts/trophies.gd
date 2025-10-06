extends Node2D

var level_trophies_dog = {
	4: preload("res://assets/dog_trophies/shiba.png"),
	5: preload("res://assets/dog_trophies/poodle.png"),
	6: preload("res://assets/balls_default/orangeball.png"), # !
	7: preload("res://assets/dog_trophies/dane.png"),
	8: preload("res://assets/dog_trophies/bernard.png")
}

var level_trophies_default = {
	4: preload("res://assets/balls_default/redball.png"),	# shiba
	5: preload("res://assets/balls_default/orangeball.png"),	# poodle
	6: preload("res://assets/balls_default/yellowball.png"),	# golden
	7: preload("res://assets/balls_default/ygreenball.png"),	# dane
	8: preload("res://assets/balls_default/greenball.png"),	# bernard
	#5: preload("res://assets/balls_default/lblueball.png"),
	#6: preload("res://assets/balls_default/dblueball.png"),
	#7: preload("res://assets/balls_default/purpleball.png")
}

var shelf_positions = {
	4: Vector2(80, 467),
	5: Vector2(180, 467),
	6: Vector2(280, 467),
	7: Vector2(380, 467),
	8: Vector2(480, 467)
}

var shelf_pos = null
var moved = false

func setup(spawnpoint, level):
	shelf_pos = shelf_positions[level]
	$Sprite2D.texture = level_trophies_dog[level]
	$Sprite2D.scale = Vector2(0.05,0.05)
	$Area2D/CollisionShape2D.scale = $Sprite2D.scale
	global_position = spawnpoint
	
func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if moved:
		return
	# move to shelf on click
	if event.is_action_pressed("click"):
		var tween = create_tween()
		tween.tween_property(self, "global_position", shelf_pos, 0.5)
		moved = true
		Globals.collecting -= 1
