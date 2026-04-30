extends Node2D

@onready var score_label: Label = $CanvasLayer/MC/ScoreLabel
@onready var player: CharacterBody2D = $Player
@onready var touch_screen_label: Label = $CanvasLayer/MC/TouchScreenLabel
@onready var coins_label: Label = $CanvasLayer/MC/HBoxContainer/CoinsLabel

const DEATH_SCENE = preload("res://UI/DeathScene/death_scene.tscn")

var hasStarted: bool = false


func _ready() -> void:
	print_debug("started game")
	GameManager.playerDeath.connect(playerDeath)
	GameManager.reloadGame.connect(reloadGame)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed and hasStarted == false:
		player.isAlive = true
		player.obstacle_timer.start()
		touch_screen_label.hide()
		hasStarted = true

func _process(delta: float) -> void:
	score_label.text = "Score: " + str(GameManager.playerScore)
	coins_label.text = str(GameManager.coins)

func playerDeath() -> void:
	var s = DEATH_SCENE.instantiate()
	get_tree().current_scene.add_child(s)

func reloadGame(watchedAd: bool) -> void:
	if watchedAd == true:
		get_tree().reload_current_scene()
	else:
		GameManager.reset_vars()
		get_tree().reload_current_scene()
