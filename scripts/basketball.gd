extends RigidBody2D

const SPEED : int = 300
const MAX_IMPULSE : int = 20000
const MAX_TRAIL_POINTS : int = 10
var trail_points : Array = []

func _physics_process(_delta: float) -> void:
	var mouse : Vector2 = get_global_mouse_position()
	var dis : int = int(global_position.distance_to(mouse))
	var impulse : Vector2 = (global_position - mouse).normalized() * dis * SPEED
	var shadow_size : float = clamp(10 / global_position.distance_to($ShadowPivot.global_position), 0, 1)
	
	if impulse.length() > MAX_IMPULSE:
		impulse = impulse.normalized() * MAX_IMPULSE
	
	if global_position.y > 100:
		if Input.is_action_pressed("click"):
			$AimLine.points[1] = to_local(mouse)
			$"../Force".text = "Force: " + str(int(impulse.length() / (MAX_IMPULSE / 100.0))) + "%"
			$"../Angle".text = "Angle: " + str(get_angle()) + "°"
		if Input.is_action_just_released("click"):
			apply_force(impulse)
			clear_aim()
	else:
		clear_aim()
	
	# Trail
	trail_points.push_front(global_position)
	
	if trail_points.size() > MAX_TRAIL_POINTS:
		trail_points.pop_back()
	
	$Trail.clear_points()
	
	for point : Vector2 in trail_points:
		$Trail.add_point(point)
	
	$"../Force".position = Vector2(global_position.x - 25, global_position.y - 25)
	$"../Angle".position = Vector2(global_position.x - 25, global_position.y - 36)
	$ShadowPivot.position.x = global_position.x
	$ShadowPivot.scale = Vector2(shadow_size, shadow_size)

func clear_aim() -> void:
	$AimLine.points[1] = Vector2.ZERO
	$"../Force".text = ""
	$"../Angle".text = ""

func get_angle() -> int:
	var mouse : Vector2 = get_global_mouse_position()
	var dir : Vector2 = mouse - global_position
	var dir_inverse : Vector2 = dir * -1
	var angle_a : int = int(rad_to_deg(atan2(dir_inverse.y, dir_inverse.x))) * -1
	var angle_b : int = int(rad_to_deg(atan2(dir.y, dir.x)))
	
	if angle_a == 89 or angle_b == 89:
		angle_a = 90
		angle_b = 90
	elif angle_a == -89 or angle_b == -89:
		angle_a = -90
		angle_b = -90
	
	if mouse.x > global_position.x:
		return angle_b
	else:
		return angle_a

func _on_area_2d_body_entered(_body: Node2D) -> void:
	var vol = clamp(linear_velocity.length() - 120, -80, 0)
	$CollisionSfx.volume_db = vol
	$CollisionSfx.play()
