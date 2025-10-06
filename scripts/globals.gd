extends Node

enum GameStage { EARLY, MID, LATE }

signal xp_changed

signal clear_all_balls

var xp = 0
var level = 1

var xp_label_pos = null

var collectibles = {
	# active:
		# AUTOMERGER
	"automerger": 0,
	
	# passive:
		# THRESHOLD 1UP
	"thresholdup": 0,
}	

var trophy_level = 3 # 4, 5, 6, 7, 8

func update_xp(added):
	xp += added
	xp_changed.emit()

func add_collectible(collectible):
	collectibles[collectible] += 1
