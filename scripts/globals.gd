extends Node

enum GameStage { EARLY, MID, LATE }

signal xp_changed
signal gain_chest

signal delete_next_ball

signal powerup_used(id)

signal mouse_over_bucket(state: bool)

var collecting = 0
var xp: int = 0
var level = 1

var unopened_chests = 0

var xp_label_pos = null

var collectibles = {
	# (number of total owned, number of uses left)
	# active:
	1: Vector2(0,0), # automerger
	
	# passive:
	2: Vector2(0,0), # threshold 1up
	
}

var collectibles_on_shelf = {
	1: false,
	2: false
}

var trophy_level = 3 # 4, 5, 6, 7, 8

func update_xp(added):
	xp += added
	if xp >= 100:
		level += xp / 100
		unopened_chests += xp / 100
		xp %= 100
		gain_chest.emit()
	xp_changed.emit()
	
func play_sound(file_path: String) -> void:
	# Create an AudioStreamPlayer node dynamically
	var player := AudioStreamPlayer.new()
	
	# Load the audio stream from the given file path
	var stream := load(file_path)
	if stream == null:
		push_error("Failed to load sound file: " + file_path)
		return

	player.stream = stream
	player.autoplay = false

	# Add the player to the scene tree (under the root so it persists while playing)
	get_tree().root.add_child(player)

	# Play the sound
	player.play()

	# Queue free after the sound finishes playing
	player.connect("finished", Callable(player, "queue_free"))

func update_chests(change):
	unopened_chests += change
	gain_chest.emit()
	
func add_collectible(collectible):
	collectibles[collectible] += 1
