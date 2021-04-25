extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var fish1 = load("res://Fish.tscn").instance()
	var fish2 = load("res://Fish.tscn").instance()
	add_child(fish1)
	add_child(fish2)
	fish1.position = $Fish1Spawn.position
	fish2.position = $Fish2Spawn.position
	fish1.set_type(0)
	fish2.set_type(3)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	get_tree().change_scene("res://MainScene.tscn")
