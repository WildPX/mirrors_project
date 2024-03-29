class_name Player
extends CharacterBody2D

@export var speed := 250

var _direction := Vector2.ZERO


func _physics_process(delta):
	_direction = _get_direction()
	velocity = _direction.normalized() * speed
	move_and_slide()


func _get_direction():
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
