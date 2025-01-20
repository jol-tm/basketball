extends Camera2D

func _physics_process(delta: float) -> void:
	if $"../Basketball".global_position.y < 0:
		global_position.y = $"../Basketball".global_position.y + -50
	else:
		global_position = Vector2(213, 120)
