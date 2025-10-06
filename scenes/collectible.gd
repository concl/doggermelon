extends Node2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func fade_in():
	animation_player.play("fade_in")
