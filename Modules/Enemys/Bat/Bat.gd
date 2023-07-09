extends Entity

const SPEED = 40
const DASH_SPEED = 60

@onready var target = get_node('/root/World/Player')
@onready var inate_weapon: Weapon = self.get_node("Weapon")
@onready var fly_timer = $FlyTimer
@onready var targets: Array[Node] = get_node('/root/World/Player/BatMarkers').get_children()

@export var agression_rate: int

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var inverted = false
var target_pos = Vector2.ZERO
var last_direction = 0.0
var is_chasing = false

func _ready():
	life_points += level * 5
	inate_weapon.damage += level
	for points in range(agression_rate):
		targets.append(target)

func _physics_process(_delta):
	velocity.y = global_position.direction_to(decide_target()).y * SPEED
	var direction = global_position.direction_to(decide_target()).x
	if not is_chasing: velocity.x = direction * SPEED
	else: velocity.x = direction * DASH_SPEED
	handle_knock()
	
	if velocity.x > 0: 
		if inverted == true:
			scale.x = -1
			inverted = false
	elif velocity.x < 0:
		if inverted == false:
			scale.x = -1
			inverted = true

	last_direction = direction
	move_and_slide()

func decide_target():
	if fly_timer.is_stopped():
		fly_timer.start(0.3)
		var index = randi_range(0, targets.size() - 1)
		target_pos = targets[index].global_position
		if targets[index].name == "Player": is_chasing = true
		else: is_chasing = false
	return target_pos

func _on_fly_timer_timeout():
	fly_timer.stop()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if inverted:
			inate_weapon.scale.x = -1
		else: inate_weapon.scale.x = 1
		body.take_damage(inate_weapon)
