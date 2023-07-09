extends Entity


const SPEED = 25
const JUMP_VELOCITY = -100

@onready var target = get_node('/root/World/Player')
@onready var inate_weapon: Weapon = self.get_node("Weapon")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var inverted = false

func _ready():
	life_points += level * 5
	inate_weapon.damage += level

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	jump_on_wall()
	velocity.x = global_position.direction_to(target.global_position).x * SPEED
	handle_knock()
	
	if velocity.x > 0: 
		if inverted == true:
			scale.x = -1
			inverted = false
	elif velocity.x < 0:
		if inverted == false:
			scale.x = -1
			inverted = true

	move_and_slide()

func jump_on_wall():
	if is_on_wall() and is_on_floor():
		velocity.y = JUMP_VELOCITY


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if inverted:
			inate_weapon.scale.x = -1
		else: inate_weapon.scale.x = 1
		body.take_damage(inate_weapon)
