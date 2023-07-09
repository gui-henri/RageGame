extends Entity

@onready var graphics = $Character
@onready var anim_player = $Character/AnimationPlayer
@onready var immune_anim_player = $AnimationPlayer
@onready var floor_detection = $FloorDetection
@onready var immunity_timer = $Timer

@export var SPEED = 60.0
@export var JUMP_VELOCITY = -150.0
@export var FALL_SPEED = 1.4
@export var max_fall_speeed = 150

var immune = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var inverted = false

func _process(_delta):
	if life_points <= 0:
		get_tree().reload_current_scene()

func _physics_process(delta):
	handle_movement(delta)
	handle_knock()
	move_and_slide()

func handle_movement(delta):
	if not is_on_floor():
		if velocity.y > 0 and velocity.y < max_fall_speeed:
			velocity.y += gravity * FALL_SPEED * delta
		else:
			velocity.y += gravity * delta
	
	if is_on_floor():
		_enable_all_floor_detection()
	
	if Input.is_action_just_pressed("ui_accept") and _is_floor_detected():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		anim_player.play("walk")
		velocity.x = direction * SPEED
		if velocity.x > 0: 
			graphics.scale.x = 2
		elif velocity.x < 0:
			graphics.scale.x = -2
	else:
		anim_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.y < 0: anim_player.play("jump")
	elif velocity.y > 0: anim_player.play("fall")

func _is_floor_detected():
	var raycasts = floor_detection.get_children()
	for raycast in raycasts:
		if raycast.is_colliding():
			raycast.enabled = false
			return true
	return false

func _enable_all_floor_detection():
	var raycasts = floor_detection.get_children()
	for raycast in raycasts:
		raycast.enabled = true

func take_damage(dealer: Weapon):
	if immune == false:
		immunity_timer.start(1)
		immune_anim_player.play("immune")
		immune = true
		life_points -= dealer.damage
	knock_back = dealer.force
	if dealer.scale.x < 0: 
		knock_direction = -1
	else: knock_direction = 1

func _on_immunity_timer_timeout():
	immune_anim_player.play("RESET")
	immune = false
