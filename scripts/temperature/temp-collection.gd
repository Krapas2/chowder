@tool
extends Node3D
class_name TemperatureCollection

@export var base_temperature: float = 0.
@export var base_capacity: float = 10.
@export var base_conductivity: float = 1.
@export var base_constant: bool = false

@export var spacing: float = 1.
@export_tool_button("Populate") var populate_button: Callable = Callable(self, "populate_action")

func populate_action():
	if not validate_parent():
		push_warning("Parent must be a CollisionShape3D.")
		return
	
	var has_children: bool = get_children().size()
	
	if has_children:
		repopulate_confirmation()
	else:
		populate_collection()
		
func validate_parent() -> bool:
	var parent = get_parent()
	if parent == null:
		return false
	return parent is CollisionShape3D
	
func repopulate_confirmation():
	if not Engine.is_editor_hint():
		return
	
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text = "Are you sure you want to repopulate this temp collection?"
	dialog.title = "Confirm Repopulation"
	
	EditorInterface.get_base_control().add_child(dialog)
	
	dialog.confirmed.connect(func():
		print("Removing temp collection")
		delete_collection()
		populate_collection()
		dialog.queue_free()
	)
	
	dialog.canceled.connect(func():
		print("Repopulation canceled")
		dialog.queue_free()
	)
	
	dialog.popup_centered()

func delete_collection():
	var children = get_children()
	for child in children:
		child.free()
	print("Temp nodes deleted")

func populate_collection():
	print("Populating temp collection")
	var collision = get_parent()
	if not collision:
		return
	
	var local_aabb = collision.shape.get_debug_mesh().get_aabb()

	var offset: Vector3 = Vector3(
		fposmod(local_aabb.position.x, spacing),
		fposmod(local_aabb.position.y, spacing),
		fposmod(local_aabb.position.z, spacing)
	)
	var min_coords: Vector3 = local_aabb.position - offset
	var max_coords: Vector3 = local_aabb.end
	
	var x = min_coords.x
	while x <= max_coords.x + spacing:
		var y = min_coords.y
		while y <= max_coords.y + spacing:
			var z = min_coords.z
			while z <= max_coords.z + spacing:
				var node_position = Vector3(x,y,z)
				if CollisionUtils.is_position_in_shape(collision, node_position):
					create_temp_node(node_position)
				z += spacing
			y += spacing
		x += spacing

func create_temp_node(node_position: Vector3):
	var temp_node = Node3D.new()
	var temp_script = load("res://scripts/temperature/temp-node.gd")
	
	temp_node.name = "TempNode%d" % get_children().size()
	temp_node.position = node_position
	
	temp_node.set_script(temp_script)
	temp_node.temperature = base_temperature
	temp_node.capacity = base_capacity
	temp_node.conductivity = base_conductivity
	temp_node.constant = base_constant
	
	add_child(temp_node)
	
	temp_node.owner = get_tree().edited_scene_root
	
