extends Node2D

const MAIN = preload("uid://dx6bicmwfxw14")
const COLLECTIBLE = preload("uid://b1raf6v4657bs")
@onready var node_2d: Node2D = $CanvasLayer/Node2D

var rewards = []

func _on_button_pressed() -> void:
    get_tree().change_scene_to_packed(MAIN)
    

func _ready():
    #temp
    get_collectible()



func get_collectible():
    
    var collectible = COLLECTIBLE.instantiate()
    node_2d.add_child(collectible)
    
