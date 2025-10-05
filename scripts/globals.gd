extends Node

enum GameStage { EARLY, MID, LATE }

signal xp_changed

var xp = 0
var level = 1

func update_xp(added):
    xp += added
    xp_changed.emit()
