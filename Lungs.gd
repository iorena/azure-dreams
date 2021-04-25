extends Node2D

const MAX_OXYGEN = 24
var oxygen_spent = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func dive():
	$Overlay.play("0")
	$OxygenTimer.start()
	$Lungs.visible = true
	$Overlay.visible = true

func surface():
	$OxygenTimer.stop()
	$DrownTimer.stop()
	$Lungs.visible = false
	$Overlay.visible = false
	oxygen_spent = 0
	$Drown.stop()

func _on_OxygenTimer_timeout():
	if oxygen_spent < MAX_OXYGEN:
		oxygen_spent += 1
		$Overlay.play(str(oxygen_spent))
	else:
		$OxygenTimer.stop()
		$DrownTimer.start()
		$Overlay.play("drown")
		$Drown.play()
	
