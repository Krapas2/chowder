class_name CollisionUtils

static func is_position_in_shape(collision: CollisionShape3D, node_pos: Vector3) -> bool:
	if not collision.shape:
		return false
		
	if collision.shape is BoxShape3D:
		var box = collision.shape as BoxShape3D
		var half_size = box.size / 2.0
		return abs(node_pos.x) <= half_size.x and \
			   abs(node_pos.y) <= half_size.y and \
			   abs(node_pos.z) <= half_size.z
	
	elif collision.shape is SphereShape3D:
		var sphere = collision.shape as SphereShape3D
		return node_pos.length() <= sphere.radius
	
	elif collision.shape is CapsuleShape3D:
		var capsule = collision.shape as CapsuleShape3D
		var height = capsule.height
		var radius = capsule.radius
		var cylinder_half_height = (height - radius * 2.0) / 2.0
		
		if abs(node_pos.y) <= cylinder_half_height:
			return Vector2(node_pos.x, node_pos.z).length() <= radius
		else:
			var cap_center = Vector3(0, sign(node_pos.y) * cylinder_half_height, 0)
			return node_pos.distance_to(cap_center) <= radius
	
	elif collision.shape is CylinderShape3D:
		var cylinder = collision.shape as CylinderShape3D
		var half_height = cylinder.height / 2.0
		return abs(node_pos.y) <= half_height and \
			   Vector2(node_pos.x, node_pos.z).length() <= cylinder.radius
	
	return false
