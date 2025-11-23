extends Node3D
class_name TemperatureNode

@export var temperature: float = 0.
@export var capacity: float = 1.
@export var conductivity: float = 1.
@export var constant: bool = false

func _ready():
	add_to_group("temp_nodes")
	
func _process(_delta: float):
	if name == "test":
		print(temperature)

func received_heat(other: TemperatureNode, delta_time: float) -> float:
	var distance_to_other = max(global_position.distance_to(other.global_position), 0.001)
	var temp_difference = other.temperature - self.temperature
	var combined_conductivity = (self.conductivity + other.conductivity) / 2.
	
	return (temp_difference * combined_conductivity * delta_time) / pow(distance_to_other, 2.)

func add_heat(heat: float) -> void:
	temperature += heat/capacity
