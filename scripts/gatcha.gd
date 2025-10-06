extends CanvasLayer

const MAIN = preload("res://scenes/main.tscn")
const COLLECTIBLE = preload("res://scenes/collectible.tscn")

@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var node_2d: Node2D = $CanvasLayer/Node2D
@onready var animation_player: AnimationPlayer = $CanvasLayer2/Chest/chest/AnimationPlayer
@onready var animation_player_bottom: AnimationPlayer = $CanvasLayer2/Chest/chest/AnimationPlayerBottom

var rewards = []


func activate():
	show()
	animation_player.play("top_drop") 
	animation_player_bottom.play("drop") 

func _ready():
	get_collectible()

func _process(delta: float) -> void:
	if not visible:
		canvas_layer_2.hide()
		canvas_layer.hide()
		
	else:
		canvas_layer.show()
		canvas_layer_2.show()


func get_collectible():
	
	var collectible = COLLECTIBLE.instantiate()
	node_2d.add_child(collectible)
	
func hit_chest():
	animation_player.play("hit")
	animation_player_bottom.play("bottom_hit")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if visible:
		if event.is_action_pressed("drop_ball"):
			hit_chest()
			
