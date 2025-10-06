extends Node2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var y_level = 260
var shelf_positions = {
	1: Vector2(125, y_level), # sitting dog
	2: Vector2(280, y_level)
}

var collectible_skins = {
	1: preload("res://assets/collectible_figures/Sitting_dog.png"),
	2: null
}

var shelf_pos = null
var moved = false

func setup(spawnpoint, id):
	id = 1
	shelf_pos = shelf_positions[id]
	$Sprite2D.texture = collectible_skins[id]
	$Sprite2D.scale = Vector2(0.1,0.1)
	#$Area2D/CollisionShape2D.scale = $Sprite2D.scale
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



func fade_in():
	animation_player.play("fade_in")
