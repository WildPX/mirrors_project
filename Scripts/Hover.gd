extends AudioStreamPlayer2D

func _on_hover():
	Global.can_shoot_laser = false
	self.play()
