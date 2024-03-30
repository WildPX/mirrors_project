class_name Objects
extends Control

@export var object_paths: Array[String]

@onready var open_file := $OpenFile
@onready var save_file := $SaveFile
@onready var message := $FileMessage
@onready var click := $Click

var objects: Array[PackedScene]

func _ready():	
	for link in object_paths:
		objects.append(load(link))


func _save_current_configuration():
	var save := ""
	for child in get_tree().get_root().get_children():
		if child is Interactable:
			save += "%s (%s,%s) %s (%s,%s) %s\n" % [child.type, \
				child.global_position.x, child.global_position.y, \
				child.global_rotation, child.scale.x, child.scale.y, child.skew]
	
	return save


func _instantiate_object(idx, coordinates=Vector2(16, 464), rot=0, scl=Vector2(1, 1)):
	var instance = objects[idx].instantiate()
	get_tree().get_root().add_child(instance)
	instance.position = coordinates
	instance.rotation = rot
	instance.scale = scl


func _parse_configuration(data: String):
	var parsed_data := []
	var lines := data.split("\n")
	
	for line in lines:
		line = line.strip_edges()
		
		# End of file
		if line.is_empty():
			print("File: Success")
			break
		
		var parts = line.split(" ")
		# Wrong format check
		if parts.size() != 5:
			print("Error reading line: %s" % line)
			return null
		
		parsed_data.append({"name": parts[0], "coordinates": _str2vec2(parts[1]), \
			"rotation": float(parts[2]), "scale": _str2vec2(parts[3]), \
			"skew": float(parts[4])})
	
	return parsed_data


func _str2vec2(str: String) -> Vector2:
	var clean_string := str.replace("(", "").replace(")", "").strip_edges()
	var parts := clean_string.split(",")
	if parts.size() != 2:
		print("Error str2vec2: %s" % str)
		return Vector2.ZERO
	
	return Vector2(float(parts[0]), float(parts[1]))


func _load_configuration(data):
	# Clean scene
	for child in get_tree().get_root().get_children():
		if child is Interactable:
			child.queue_free()
	
	for obj in data:
		if Global.object_ids.has(obj["name"]):
			_instantiate_object(Global.object_ids[obj["name"]], \
				obj["coordinates"], obj["rotation"], obj["scale"])
	
	message.write_on_screen("Configuration: Success")


func _on_mirror_hor_button_down():
	click.play()
	_instantiate_object(0)


func _on_mirror_lb_button_down():
	click.play()
	_instantiate_object(1)


func _on_mirror_1_button_down():
	click.play()
	_instantiate_object(2)


func _on_mirror_2_button_down():
	click.play()
	_instantiate_object(3)


func _on_mirror_3_button_down():
	click.play()
	_instantiate_object(4)


func _on_target_button_down():
	click.play()
	_instantiate_object(5)


func _on_import_button_down():
	click.play()
	Global.can_shoot_laser = false
	open_file.popup()


func _on_export_button_down():
	click.play()
	Global.can_shoot_laser = false
	save_file.popup()


func _on_open_file_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var data = _parse_configuration(file.get_as_text())
	if not data:
		message.write_on_screen("Error loading file: %s" % path)
	else:
		_load_configuration(data)
	
	Global.can_shoot_laser = true


func _on_open_file_canceled():
	click.play()
	Global.can_shoot_laser = true


func _on_open_file_confirmed():
	click.play()
	Global.can_shoot_laser = true


func _on_save_file_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var data = _save_current_configuration()
	
	if not data:
		message.write_on_screen("Error creating confguration")
	else:
		file.store_string(data)
		message.write_on_screen("Export: Success")
	
	Global.can_shoot_laser = true


func _on_save_file_canceled():
	click.play()
	Global.can_shoot_laser = true


func _on_save_file_confirmed():
	click.play()
	Global.can_shoot_laser = true


func _enable_shooting_on_mouse_exit():
	Global.can_shoot_laser = true
