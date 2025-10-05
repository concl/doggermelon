extends Node

enum GameStage { EARLY, MID, LATE }

signal xp_changed

var xp = 0
var level = 1

var collectibles = []

func update_xp(added):
    xp += added
    xp_changed.emit()


func add_collectible(collectible):
    collectibles.append(collectible)
