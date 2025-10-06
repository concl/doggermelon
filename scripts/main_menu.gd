extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_button: TextureButton = $MenuUI/Main/VBoxContainer/StartButton
const MAIN = preload("res://scenes/main.tscn")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "fade_out":
        get_tree().change_scene_to_packed(MAIN)

# UI Logic
@onready var main: Control = $MenuUI/Main
@onready var options: Control = $MenuUI/Options


func _on_start_button_pressed() -> void:
    animation_player.play("fade_out")


func _on_options_button_pressed() -> void:
    main.hide()
    options.show()


func _on_back_button_pressed() -> void:
    main.show()
    options.hide()


func _on_quit_button_pressed() -> void:
    get_tree().quit()
