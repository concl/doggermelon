extends CanvasLayer

const MAIN = preload("res://scenes/main.tscn")
const COLLECTIBLE = preload("res://scenes/collectible.tscn")

@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var node_2d: Node2D = $CanvasLayer/Node2D
@onready var animation_player: AnimationPlayer = $CanvasLayer2/Chest/chest/AnimationPlayer
@onready var animation_player_bottom: AnimationPlayer = $CanvasLayer2/Chest/chest/AnimationPlayerBottom

@onready var chest: Node3D = $CanvasLayer2/Chest/chest
@onready var back: Button = $CanvasLayer/UI/Back

var chest_hp = 5
var rewards = []
var item = null

func activate():
	show()
	item.hide()
	back.hide()
	chest_hp = 5
	chest.show()
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
	collectible.hide()
	collectible.sprite.modulate = 0
	item = collectible
  
func break_chest():
	animation_player.play("top explode")
	animation_player_bottom.play("bottom_explode")
	item.fade_in()
	item.show()
	
  
func hit_chest():
	animation_player.play("hit")
	animation_player_bottom.play("bottom_hit")
	chest_hp -= 1
	if chest_hp == 0:
		break_chest()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if visible:
		if event.is_action_pressed("click") and chest_hp > 0:
			hit_chest()
			


func _on_animation_player_bottom_animation_finished(anim_name: StringName) -> void:
	if anim_name == "bottom_explode":
		chest.hide()
		back.show()
