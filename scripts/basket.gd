extends StaticBody2D

var vw : Vector2 

func _ready() -> void:
	vw = get_viewport().size
	change_position()

func change_position() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var x : int = randi_range(35, int(vw.x) - 35)
	var y : int = randi_range(50, int(vw.y) - 100)
	
	tween.tween_property(self, "global_position", Vector2(x, y), 2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Basketball" and body.linear_velocity.y > 0:
		change_position()
		$ScoreSfx.play()
