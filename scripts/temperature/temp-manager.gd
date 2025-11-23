extends Node
class_name TemperatureManager

@export var chunk_size: float = 1.

var chunks: Dictionary[Vector3i, Array] = {}
var delta_time: float = 0.

func _process(delta: float) -> void:
	delta_time = delta
	var temp_nodes: Array[TemperatureNode] = get_all_temp_nodes()
	chunks = chunk_map(temp_nodes)
	
	apply_heat(temp_nodes)
	pass
	
func apply_heat(temp_nodes: Array[TemperatureNode]):
	var delta_temps = {}
	
	for temp_node in temp_nodes:
		delta_temps[temp_node] = node_heat(temp_node)
	
	for temp_node in temp_nodes:
		temp_node.add_heat(delta_temps[temp_node])
		
func node_heat(
	temp_node: TemperatureNode,
) -> float:
	if temp_node.constant:
		return 0
	var node_chunk: Vector3i = chunk_from_position(temp_node.global_position)
	var delta_temp: float = 0
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			for z in range(-1, 2):
				var neighbor_chunk: Vector3i = node_chunk + Vector3i(x, y, z)
				delta_temp += chunk_heat(temp_node, neighbor_chunk)
	
	return delta_temp
	
func chunk_heat(
	temp_node: TemperatureNode,
	neighbor_chunk: Vector3i,
) -> float:
	var heat = 0
	if chunks.has(neighbor_chunk):
		for other_node in chunks[neighbor_chunk]:
			if temp_node == other_node:
				continue
			var transfer_amount: float = temp_node.received_heat(other_node, delta_time)
			heat += transfer_amount
	return heat
	
func get_all_temp_nodes() -> Array[TemperatureNode]:
	var result: Array[TemperatureNode] = []
	result.assign(get_tree().get_nodes_in_group("temp_nodes"))
	return result

func chunk_map(temp_nodes: Array[TemperatureNode]) -> Dictionary[Vector3i, Array]:
	var map: Dictionary[Vector3i, Array] = {}
	
	for temp_node in temp_nodes:
		var chunk: Vector3i = chunk_from_position(temp_node.global_position)
		if not map.has(chunk):
			map[chunk] = []
		map[chunk].append(temp_node)
	
	return map

func chunk_from_position(position: Vector3):
	return (position/chunk_size).floor();
