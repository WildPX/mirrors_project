class_name Laser
extends Node2D

@onready var raycast = $RayCast2D
@onready var line = $Line2D
@onready var sfx = $Shoot

@export var raycast_length := 2000
const MAX_BOUNCES := 5


func _process(delta):
	line.clear_points()
	if Input.is_action_just_pressed("shoot_laser") and Global.can_shoot_laser:
		sfx.play()
	if Input.is_action_pressed("shoot_laser") and Global.can_shoot_laser:
		line.add_point(Vector2.ZERO)
		
		# Define initial raycast
		raycast.global_position = line.global_position
		raycast.target_position = (get_global_mouse_position() - line.global_position).normalized() * raycast_length
		raycast.force_raycast_update()
		
		var previous = null
		var bounces = 0
		
		while true:
			if not raycast.is_colliding():
				var pos = raycast.global_position + raycast.target_position
				line.add_point(line.to_local(pos))
				break
			
			var collider = raycast.get_collider()
			var pt = raycast.get_collision_point()
			
			line.add_point(line.to_local(pt))
			
			if collider.is_in_group("Target"):
				if collider.has_method("show_hit"):
					collider.show_hit()
			
			if not collider.is_in_group("Mirrors"):
				break
			
			var normal = raycast.get_collision_normal()
			
			if normal == Vector2.ZERO:
				break
			
			# Update collisions
			if previous != null:
				previous.collision_mask = 3
				previous.collision_layer = 3
			previous = collider
			previous.collision_mask = 0
			previous.collision_layer = 0
			
			# Update raycast
			raycast.global_position = pt
			raycast.target_position = raycast.target_position.bounce(normal)
			raycast.force_raycast_update()
			
			bounces += 1
			if bounces >= MAX_BOUNCES:
				break
		
		if previous != null:
			previous.collision_mask = 3
			previous.collision_layer = 3
