extends Camera2D
class_name PlayerCameraController

@export var sensitivity: float;

var x_rotation: float;
var parent: Node3D;

func _ready() -> void:
	if not validate_parent():
		push_error("Parent must be a Node3D.")

func _input(event):
	if event is InputEventMouseMotion:
		position += event.relative

func validate_parent() -> bool:
	parent = get_parent()
	if parent == null:
		return false
	return parent is Node3D
