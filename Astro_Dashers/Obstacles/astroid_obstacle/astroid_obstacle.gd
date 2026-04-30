extends Node2D

@onready var life_timer: Timer = $LifeTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.speed_scale = randf_range(0.25, 1.0)
	if randi_range(0, 1) == 1:
		animated_sprite_2d.self_modulate = Color(1,1,1,1)
	else:
		animated_sprite_2d.self_modulate = Color(randf_range(0.3, 0.7), randf_range(0.3, 0.7), randf_range(0.3, 0.7), 1)

func _on_life_timer_timeout() -> void:
	queue_free()


func _on_score_area_body_entered(body: Node2D) -> void:
	GameManager.playerScore += 1
