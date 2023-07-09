extends Weapon

var damaged_enemys = []
func _ready():
	damage = 2
	cooldown = 0.4
	force = 130

func _on_collision_detector_body_entered(body):
	for group in body.get_groups():
		if group == "enemy" and body not in damaged_enemys:
			body.take_damage(self)
			damaged_enemys.append(body)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		queue_free()
