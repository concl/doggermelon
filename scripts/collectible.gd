extends Node2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var shelf_size = Vector2(0.3,0.3)

var y_level = 368
var shelf_positions = {
	1: Vector2(370, y_level), # sitting dog
	2: Vector2(832, y_level) # down dog
}

var collectible_skins = {
	1: preload("res://assets/collectible_figures/Sitting_dog.png"),
	2: preload("res://assets/collectible_figures/Down_dog.png")
}

var shelf_pos: Vector2
var moved = false
var currentID: int
var onShelf = false
var isPassive = false

func setup(spawnpoint, id):
	currentID = id
	match id:
		1:
			isPassive = false
		2:
			isPassive = false
	shelf_pos = shelf_positions[id]
	$Sprite2D.texture = collectible_skins[id]
	$Sprite2D.scale = shelf_size
	$Area2D.scale = $Sprite2D.scale
	global_position = spawnpoint

func move_to_shelf():
	onShelf = true
	var tween = create_tween()
	var tween2 = create_tween()

	tween.tween_property(self, "global_position", shelf_pos, 0.5)
	tween2.tween_property(sprite, "global_scale", shelf_size, 0.5)
	$Area2D.scale = shelf_size
	Globals.collecting = clamp(Globals.collecting - 1, 0, INF)
	await tween.finished
	
	if Globals.collectibles_on_shelf[currentID]:
		queue_free()
	else:
		Globals.collectibles_on_shelf[currentID] = true

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	# move to shelf on click
	if event.is_action_pressed("click"):
		print("clicked")
		if !onShelf:
			move_to_shelf()
		else:
			if !isPassive:
				Globals.emit_signal("powerup_used", currentID)
			
func fade_in():
	animation_player.play("fade_in")
