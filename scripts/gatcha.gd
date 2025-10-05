extends Node2D

const MAIN = preload("res://scenes/main.tscn")
const COLLECTIBLE = preload("res://scenes/collectible.tscn")

@onready var node_2d: Node2D = $CanvasLayer/Node2D

var rewards = []

func _on_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")
    

func _ready():
    print(MAIN)
    get_collectible()



func get_collectible():
    
    var collectible = COLLECTIBLE.instantiate()
    node_2d.add_child(collectible)
    
