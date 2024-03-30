class_name FileMessage
extends Label


func write_on_screen(content):
	text = content
	modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 2.0)
