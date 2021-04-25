extends Node2D
signal pearl_collected

var collected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Click.stream.loop = false


func collect():
	if not collected:
		$AnimatedSprite.play("open")
		$DisappearTimer.start()
		collected = true
		emit_signal("pearl_collected")
		$Click.play()


func _on_DisappearTimer_timeout():
	queue_free()


func _on_Shell_body_entered(body):
	print("moi", position)
	collect()
