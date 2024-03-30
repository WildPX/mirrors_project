class_name Interactable
extends Area2D

@export var scroll_speed := 0.05
@export var type: String
@onready var default_scale := scale
@onready var default_rotation := global_rotation
@onready var default_skew := skew

var mouse_in_area := false


func _ready():
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


func _process(delta):
	if Input.is_action_just_pressed("delete_all_interactables"):
		_destroy_object()
	
	if Input.is_action_pressed("move_interactable") and mouse_in_area:
		Global.is_already_dragging = true
		_follow_mouse()
		if Input.is_action_pressed("rotation_modifier"):
			_rotate_object()
		if Input.is_action_pressed("size_modifier"):
			_resize_object()
		if Input.is_action_pressed("skew_modifier"):
			_skew_object()
		if Input.is_action_just_pressed("reset_interactable"):
			_reset_object()
		if Input.is_action_just_pressed("delete_interactable"):
			_destroy_object()
	elif Input.is_action_just_released("move_interactable"):
		Global.is_already_dragging = false
		mouse_in_area = false
	


func _follow_mouse():
	position = get_global_mouse_position()


func _rotate_object():
	if Input.is_action_just_pressed("rotate_up"):
		rotate(scroll_speed)
	elif Input.is_action_just_pressed("rotate_down"):
		rotate(-scroll_speed)


func _reset_object():
	scale = default_scale
	global_rotation = default_rotation
	skew = default_skew
	Global.is_already_dragging = false
	mouse_in_area = false


func _resize_object():
	if Input.is_action_just_pressed("rotate_up"):
		scale.x += scroll_speed
		scale.y += scroll_speed
	elif Input.is_action_just_pressed("rotate_down"):
		scale.x -= scroll_speed
		scale.y -= scroll_speed


func _skew_object():
	if Input.is_action_just_pressed("rotate_up"):
		skew += scroll_speed
	elif Input.is_action_just_pressed("rotate_down"):
		skew -= scroll_speed


func _destroy_object():
	Global.is_already_dragging = false
	queue_free()


func _on_mouse_entered():
	if not Global.is_already_dragging:
		mouse_in_area = true


func _on_mouse_exited():
	if not Global.is_already_dragging:
		mouse_in_area = false
