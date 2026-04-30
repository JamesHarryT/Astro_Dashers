extends Node

var playerScore: int = 0
var highscore: int = 0
var coins: int = 0
var has_revive: bool = true

var savePath = "user://highscore.save"

func _ready() -> void:
	MobileAds.initialize()

func save() -> void:
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	if file:
		file.store_var(highscore)
		file.close()
	else:
		print("failed to save")

func loadData() -> void:
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		if file:
			highscore = file.get_var(0)
			file.close()
		else:
			print("failed to load")
	else:
		print("No save file found")

func reset_vars() -> void:
	playerScore = 0
	has_revive = false

signal playerDeath
signal reloadGame(watchedAd: bool)
