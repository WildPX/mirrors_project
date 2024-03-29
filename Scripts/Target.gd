class_name Target
extends Area2D

@onready var sprite := $AnimatedSprite2D
# @onready var hit_detected := $"Hit Detected/Label"
@onready var hit_timer := $"Hit_Timer"


func _process(delta):
	if hit_timer.time_left == 0:  # and hit_detected.visible == true:
		show_not_hit()


func show_hit():
	sprite.play("hit")
	# hit_detected.visible = true
	hit_timer.start()


func show_not_hit():
	sprite.play("not_hit")
	# hit_detected.visible = false
