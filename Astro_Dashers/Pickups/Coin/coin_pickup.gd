extends Node2D


func _on_life_timer_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	GameManager.coins += 1
	queue_free()
