extends Node2D

const FISH_SPEEDS = [40, 30, 20, 40]
var fish_type

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	fish_type = randi() % 3
	var x = 2500
	if fish_type == 0:
		$AnimatedSprite.play("fish1")
	elif fish_type == 1:
		$AnimatedSprite.play("fish2")
		x = -500
	else:
		$AnimatedSprite.play("fish3")
		
	var y = (randi() % 500) - 100
	global_position = Vector2(x, y)
	
func set_type(type):
	fish_type = type
	if fish_type == 0:
		$AnimatedSprite.play("fish1")
	else:
		$AnimatedSprite.play("fish4")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = -1
	if fish_type == 1 or fish_type == 3:
		dir = 1
	var velo = Vector2(dir, 0) * FISH_SPEEDS[fish_type] #todo: more fish
	position += delta * velo
