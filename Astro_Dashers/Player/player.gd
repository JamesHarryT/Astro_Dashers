extends CharacterBody2D

#NODES
@onready var tail_sprite: Sprite2D = $TailSprite
@onready var raccoon_body_sprite: Sprite2D = $RaccoonBodySprite
@onready var arms_sprite: Sprite2D = $ArmsSprite
@onready var camera_2d: Camera2D = $Camera2D
@onready var obstacle_spawner: Node2D = $ObstacleSpawner
@onready var obstacle_timer: Timer = $ObstacleTimer
@onready var particle_fx: Node2D = $ArmsSprite/particle_fx


#SCENES
const ASTROID_OBSTACLE = preload("res://Obstacles/astroid_obstacle/astroid_obstacle.tscn")
const LASER_OBSTACLE = preload("res://Obstacles/Laser_Obstacle/laser_obstacle.tscn")
const DEATH_SCENE = preload("res://UI/DeathScene/death_scene.tscn")
const COIN_PICKUP = preload("res://Pickups/Coin/coin_pickup.tscn")


var moveSpeed : float = 400.0 
var isAlive: bool = false #set like this so player has to press button to start
var spriteRotations: Vector2
var isTimerActive: bool = false
#TODO MAKE TAIL AND ARM SPRITES SEPERATE SO THEY MOVE DIFFERENTLY. ARM SPRITES
# AIM TOWARDS THE TOUCH, TAIL AIMS AWAY FROM TOUCH

#TODO PUT TIP SAYING FURTHER FINGER AWAY FROM MIDDLE BIGGER THE PUSH

#TODO try to put like a bar in front of the player on the player scene. Then
# spawn in astroids using position of that bar (randomizing ofc) and have as child
# of different node. Should give illusion of infinite astroid generation n shii

#^^^^ delete after 5 sec or so and do animation so if player sitting still it isnt weird

func _input(event: InputEvent) -> void:
	if isAlive == true: 
		if event is InputEventScreenTouch and event.pressed:
			isTimerActive = false
			velocity = movePlayer(event.position) * moveSpeed
		if event is InputEventScreenDrag:
			velocity = movePlayer(event.position) * moveSpeed
		if event is InputEventScreenTouch and not event.pressed:
			startDeathTimer()
		update_particles(velocity)

func movePlayer(touchPos: Vector2) -> Vector2:
	var screenSize = get_viewport().get_visible_rect().size
	var normalizedTouchPos = Vector2(
		(touchPos.x / screenSize.x) * 2 - 1,
		(touchPos.y / screenSize.y) * 2 - 1   
	)
	spriteRotations = -normalizedTouchPos
	if -normalizedTouchPos.y > 0.1:
		return Vector2(0.0, 0.0) #makes top half of screen not touchable
	return -normalizedTouchPos

func calcTailAndArmRot() -> void:
	var movement_direction = velocity.normalized()
	
	# Calculate desired tail rotation (opposite movement)
	var desired_tail_rotation = movement_direction.angle() + (PI/2)
	
	# Convert rotation to degrees and clamp it between -90 and 90
	var clamped_tail_rotation = clamp(rad_to_deg(desired_tail_rotation), -90, 90)
	
	# Convert back to radians and apply smooth interpolation
	tail_sprite.rotation = lerp_angle(tail_sprite.rotation, deg_to_rad(clamped_tail_rotation), 0.1)
	
	# Arms should point toward where the player is touching + 90 degrees
	var arms_target_rotation = spriteRotations.angle() + (PI / 2)
	arms_sprite.rotation = lerp_angle(arms_sprite.rotation, arms_target_rotation, 0.2)
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func _process(delta: float) -> void:
	camera_2d.global_position.x = 0.0 #keeps camera stationary
	velocity *= 0.95
	calcTailAndArmRot()

func update_particles(velocity: Vector2) -> void:
	if (velocity.length() / moveSpeed) > 0.33:
		particle_fx.set_velocity(max(velocity.x, velocity.y))
		particle_fx.set_emitting(true)
	else:
		particle_fx.set_velocity(0.0)
		particle_fx.set_emitting(false)

func _on_area_2d_area_entered(area: Area2D) -> void:
	isAlive = false
	killPlayer()
	velocity = Vector2(0,0)


func _on_obstacle_timer_timeout() -> void:
	var screenSize = get_viewport().get_visible_rect().size
	var o = ASTROID_OBSTACLE.instantiate()
	var c = COIN_PICKUP.instantiate()
	var xPos = randf_range(-(screenSize.x/4), (screenSize.x/4))
	var coinPos = clamp((-xPos + 50 * sign(-xPos)), -screenSize.x / 4, screenSize.x / 4)
	o.global_position.x = xPos
	o.global_position.y = obstacle_spawner.global_position.y
	c.global_position.x = coinPos
	c.global_position.y = obstacle_spawner.global_position.y
	get_tree().current_scene.add_child(o)
	get_tree().current_scene.add_child(c)
	if isAlive == true:
		obstacle_timer.start()
	
func killPlayer() -> void:
	if isAlive == false:
		print("IM DEAD")
		particle_fx.set_emitting(false)
		GameManager.playerDeath.emit()
		

func startDeathTimer() -> void:
	isTimerActive = true
	await get_tree().create_timer(0.5).timeout
	if isTimerActive == true:
		isAlive = false
		killPlayer()
		
