extends Node
class_name TemperatureShaderData

@export var temp_nodes: Array[TemperatureNode] = []
@export var temp_mult: float = .5
@export var temp_exponent: float = 2.
@export var light_exponent: float = 2.
@export var opacity: float = 1.

var mesh: MeshInstance3D
var material: Material

func _ready() -> void:
	validate_parent()
	setup_material()
	
func validate_parent() -> void:
	var parent = get_parent()
	
	if parent == null:
		push_error("This node must have a parent!")
	if not parent is MeshInstance3D:
		push_error("Parent must be of type %s, but is %s" % [MeshInstance3D, parent.get_class()])
		
	mesh = parent
	
func setup_material() -> void:
	material = ShaderMaterial.new()
	
	material.shader = preload(TemperatureResources.TEMP_SHADER_PATH)
	material.set_shader_parameter("temp_mult", temp_mult)
	material.set_shader_parameter("temp_exponent", temp_exponent)
	material.set_shader_parameter("light_exponent", light_exponent)
	material.set_shader_parameter("opacity", opacity)
	
	mesh.material_override = material

func _process(_delta: float) -> void:
	update_material()

func update_material() -> void:
	var positions = PackedVector3Array()
	var values = PackedFloat32Array()
	
	for temp_node in temp_nodes:
		var mappedTemp = remap(
			temp_node.temperature,
			TemperatureUtils.min_shader_temp,
			TemperatureUtils.max_shader_temp,
			0,
			1
		)
		
		positions.append(temp_node.global_position)
		values.append(mappedTemp)
		
	material.set_shader_parameter("temp_positions", positions)
	material.set_shader_parameter("temp_values", values)
	material.set_shader_parameter("temp_count", temp_nodes.size())
	
