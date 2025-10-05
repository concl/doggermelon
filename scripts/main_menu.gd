extends Node3D

@onready var start_button: Button = $MenuUI/PanelContainer/StartButton
const MAIN = preload("res://scenes/main.tscn")


func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_packed(MAIN)
