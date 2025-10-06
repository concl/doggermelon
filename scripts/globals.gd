extends Node

enum GameStage { EARLY, MID, LATE }

signal xp_changed

signal clear_all_balls

var xp = 0
var level = 1

var collectibles = []

func update_xp(added):
	xp += added
	xp_changed.emit()


func add_collectible(collectible):
	collectibles.append(collectible)
