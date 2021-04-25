extends Node2D

const shell_positions = [Vector2(150, -415), Vector2(190, -411), Vector2(328, -254), Vector2(364, -254), Vector2(423, -193), Vector2(506, -91), Vector2(608, 70), Vector2(858, 320)]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var first_playthrough = true

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_shells()
	$Mermaid.connect("dive", self, "_on_dive")
	$Mermaid.connect("surface", self, "_on_surface")


func spawn_shells():
	for pos in shell_positions:
		var shell = load("res://Shell.tscn").instance()
		add_child(shell)
		shell.connect("pearl_collected", self, "_on_pearlCollected")
		shell.position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	$Items/Treasure/AnimatedSprite.play("break_lock")
	$Items/Treasure/AnimatedSprite.play("open")
	$WinTimer.start()

func _on_FishSpawnTimer_timeout():
	var fish = load("res://Fish.tscn").instance()
	add_child(fish)
	
func _on_pearlCollected():
	$Mermaid.collect_pearl()
	$Mermaid/Lungs/OxygenTimer.wait_time += 0.2
	$Mermaid/Lungs/Lungs.scale *= 1.1
	$Mermaid/Lungs/Overlay.scale *= 1.1
	
func _on_dive():
	$Mermaid/Lungs.dive()
	
func _on_surface():
	$Mermaid/Lungs.surface()


func _on_WinTimer_timeout():
	get_tree().change_scene("res://WinMenu.tscn")
