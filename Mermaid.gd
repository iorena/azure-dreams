extends KinematicBody2D

signal pearl_collected
signal surface
signal dive

enum { UP, DOWN, LEFT, RIGHT, UPLEFT, UPRIGHT, DOWNLEFT, DOWNRIGHT }
const DIRECTION_VECTORS = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1)]
const ROTATIONS = [0, 180, 270, 90, 315, 45, 225, 135]


var diving = false
var pearls = 0
var speech_completed = 0
var speech_click_timeout = false

# "gravity"
const FLOAT = -20
const SWIM_SPEED = 100
const RESISTANCE = 0.1

var velocity = Vector2()
var direction = UP
var swim_cooldown = false
var dive_cooldown = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpeechBubble/SpeechTimer.start()
	$Splash.stream.loop = false
	$Breath.stream.loop = false
	
func surface():
	diving = false
	dive_cooldown = true
	$DiveTimer.start()
	$AnimatedSprite.play("surface")
	$AnimatedSprite.rotation_degrees = 0
	$SurfaceCam.current = true
	emit_signal("surface")
	position.y = -515
	velocity = Vector2(0, 0)
	$Breath.play()
	
func dive():
	diving = true
	dive_cooldown = true
	$AnimatedSprite.play("default")
	$DiveTimer.start()
	$DiveCam.current = true
	emit_signal("dive")
	direction = DOWN
	position.y = -460
	velocity = SWIM_SPEED* 2 * DIRECTION_VECTORS[DOWN]
	$Splash.play()

func check_direction_diving():
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_down"):
			direction = DOWNLEFT
		elif Input.is_action_pressed("ui_up"):
			direction = UPLEFT
		else:
			direction = LEFT
	elif Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_up"):
			direction = UPRIGHT
		elif Input.is_action_pressed("ui_down"):
			direction = DOWNRIGHT
		else:
			direction = RIGHT
	elif Input.is_action_pressed("ui_up"):
		direction = UP
	elif Input.is_action_pressed("ui_down"):
		direction = DOWN
		
	$AnimatedSprite.rotation_degrees = ROTATIONS[direction]

	# kick with your tail n__n
	if Input.is_action_pressed("ui_select") and not swim_cooldown:
		$AnimatedSprite.play("kick")
		$KickTimer.start()
		swim_cooldown = true
		$SwimTimer.start()
		
func check_movement_surface():
	if Input.is_action_pressed("ui_left"):
		velocity = SWIM_SPEED * DIRECTION_VECTORS[LEFT]
	if Input.is_action_pressed("ui_right"):
		velocity = SWIM_SPEED * DIRECTION_VECTORS[RIGHT]
	if speech_completed < 6 and Input.is_action_pressed("ui_select") and not speech_click_timeout:
		speech_completed += 1
		speech_click_timeout = true
		$SpeechBubble/SpeechClickTimer.start()
		if speech_completed < 6:
			$SpeechBubble/AnimatedSprite.play(str(speech_completed))
		if speech_completed > 5:
			$SpeechBubble.queue_free()
		else:
			$SpeechBubble/SpeechTimer.start()
	if speech_completed > 5 and Input.is_action_pressed("ui_select") and not dive_cooldown:
		dive()

func check_surfacing():
	if diving and position.y < -480 and not dive_cooldown:
		surface()
		
func collect_pearl():
	pearls += 1

func _physics_process(delta):
	if diving:
		check_direction_diving()
		check_surfacing()
	else:
		check_movement_surface()

		#apply water resistance
	velocity *= pow(RESISTANCE, delta)
	if diving:
		#apply float
		velocity.y += delta * FLOAT
		
	var motion = velocity * delta
	var collision = move_and_collide(motion)
	if collision and collision.collider.has_method("collect") and not collision.collider.collected:
		collision.collider.collect()
		collect_pearl()

func _on_SwimTimer_timeout():
	swim_cooldown = false
	if diving:
		$AnimatedSprite.play("default")


func _on_DrownTimer_timeout():
	get_tree().change_scene("res://GameOverMenu.tscn")


func _on_DiveTimer_timeout():
	dive_cooldown = false


func _on_SpeechTimer_timeout():
	speech_completed += 1
	if speech_completed < 6:
		$SpeechBubble/AnimatedSprite.play(str(speech_completed))
	$SpeechBubble/SpeechTimer.start()
	if speech_completed > 5:
		$SpeechBubble.queue_free()


func _on_SpeechClickTimer_timeout():
	speech_click_timeout = false


func _on_KickTimer_timeout():
	velocity = SWIM_SPEED * DIRECTION_VECTORS[direction]

