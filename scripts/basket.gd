extends StaticBody2D

var vw : Vector2 
var score : int = 0

func _ready() -> void:
	vw = get_viewport().size

func change_position() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var x : int = randi_range(35, int(vw.x) - 35)
	var y : int = randi_range(40, int(vw.y) - 100)
	
	tween.tween_property(self, "global_position", Vector2(x, y), 2)

func shake(force: int) -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_EXPO)
	force /= 100
	
	for i : int in range(force):
		tween.tween_property(self, "rotation_degrees", 5, 0.05)
		tween.tween_property(self, "rotation_degrees", -5, 0.05)
	tween.tween_property(self, "rotation_degrees", 0, 0.05)
	$RimSfx.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Basketball" and body.linear_velocity.y > 0:
		change_position()
		score += 1   
		$"../Score".text = str(score)
		$ScoreSfx.play()

func _on_play_btn_pressed() -> void:
	change_position()
