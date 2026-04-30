extends Control

const GAME_SCENE = preload("res://GameScene/game_scene.tscn")

func _ready() -> void:
	GameManager.loadData()
	#MobileAds.initialize()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)
