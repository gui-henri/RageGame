extends CharacterBody2D

class_name Entity

@export var life_points: int
@export var skills: Array[Node]
@export var weapon: PackedScene
@export var knock_back: int
@export var knock_resist: int
@export var level: int

var knock_direction = 1

func _process(_delta):
	if life_points <= 0:
		queue_free()

func take_damage(dealer: Weapon):
	life_points -= dealer.damage
	knock_back = dealer.force
	if dealer.scale.x < 0 or dealer.scale.y < 0: 
		knock_direction = -1
	else: knock_direction = 1

func handle_knock():
	# If an entity desire to suffer from knockback effects, it must call this function after any changes on velocity.x
	if knock_back != 0:
		velocity.x = knock_back * knock_direction
		if knock_back > 0:
			knock_back -= knock_resist
		if knock_back < 0:
			knock_back = 0
