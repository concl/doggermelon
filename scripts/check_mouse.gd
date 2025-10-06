extends Area2D

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	input_pickable = true  # Make sure mouse can interact

func _on_mouse_entered():
	Globals.emit_signal("mouse_over_bucket", true)

func _on_mouse_exited():
	Globals.emit_signal("mouse_over_bucket", false)
