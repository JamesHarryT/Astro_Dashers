extends Control

@onready var score_label: Label = $CanvasLayer/MarginContainer/ScoreLabel
#ADS STUFFF
@onready var respawnAd : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()


const GAME_SCENE = preload("res://GameScene/game_scene.tscn")
const MAIN_MENU = "res://UI/MainMenu/main_menu.tscn"

func _ready() -> void:
	if GameManager.highscore < GameManager.playerScore:
		GameManager.highscore = GameManager.playerScore
		GameManager.save()
	score_label.text = "YOU DIED! \n Score: %s \n Highscore: %s" % [GameManager.playerScore, GameManager.highscore]
	

func _on_retry_button_pressed() -> void:
	GameManager.reloadGame.emit(false)
	queue_free()


func _on_quit_button_pressed() -> void:
	GameManager.reset_vars()
	get_tree().change_scene_to_file(MAIN_MENU)


func _on_watch_ad_button_pressed() -> void:
	#frees memory I guess
	if respawnAd:
		respawnAd.destroy()
		respawnAd = null
	var rewardedAdLoadCallback := RewardedAdLoadCallback.new()
	rewardedAdLoadCallback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
	rewardedAdLoadCallback.on_ad_loaded = func(_respawnAd : RewardedAd) -> void:
		print("rewarded ad loaded" + str(_respawnAd._uid))
		respawnAd = _respawnAd
	
	RewardedAdLoader.new().load(GameManager.appID, AdRequest.new(), rewardedAdLoadCallback)
	
	
	
func onRespawnAdFinished() -> void:
	GameManager.reloadGame.emit(true)
