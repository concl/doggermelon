extends Node2D

var level_trophies_default = {
	4: preload("res://assets/balls_default/redball.png"),		# shiba
	5: preload("res://assets/balls_default/orangeball.png"),	# poodle
	6: preload("res://assets/balls_default/yellowball.png"),	# golden
	7: preload("res://assets/balls_default/ygreenball.png"),	# dane
	8: preload("res://assets/balls_default/greenball.png"),	# bernard
	#5: preload("res://assets/balls_default/lblueball.png"),
	#6: preload("res://assets/balls_default/dblueball.png"),
	#7: preload("res://assets/balls_default/purpleball.png")
}

var shelf_pos = null
var moved = false

func setup(spawnpoint, level):
	print("trophy setup")
	shelf_pos = Vector2(0, 0)
	if level < 4:
		level = 4
	$Sprite2D.texture = level_trophies_default[level]
	global_position = spawnpoint
	
func _on_input_event(viewport, event, shape_idx):
	if moved:
		return
	if event.is_action_pressed("click"):
		moved = true
		var tween = create_tween()
		tween.tween_property(self, "global_position", shelf_pos, 0.5)
		
