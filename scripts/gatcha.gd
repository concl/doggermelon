extends CanvasLayer

const MAIN = preload("res://scenes/main.tscn")
const COLLECTIBLE = preload("res://scenes/collectible.tscn")
@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var node_2d: Node2D = $CanvasLayer/Node2D

var rewards = []

func _on_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")
    

func _ready():
    print(MAIN)
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
    
