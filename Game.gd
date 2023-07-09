extends Node2D

@export var first_level: PackedScene
@export var player: PackedScene

var to_remove = false
var to_remove_level

func _ready():
	if first_level != null:
		var level = first_level.instantiate()
		add_child(level)
		spawn_player(level)
		level.next_level.connect(_on_next_level)
		level.restart_level.connect(_on_restart_level)

func _process(_delta):
	if to_remove:
		to_remove_level.queue_free()
		to_remove = false

func defered_queue(to_be_excluded):
	to_be_excluded.queue_free()

func add_queue(to_add):
	add_child(to_add)

func _on_restart_level(level):
	spawn_player(level)

func _on_next_level(level):
	if level.next != null:
		to_remove = true
		to_remove_level = level
		var new_level = level.next.instantiate()
		new_level.next_level.connect(_on_next_level)
		new_level.restart_level.connect(_on_restart_level)
		call_deferred("add_child", new_level)
		spawn_player(new_level)
	else:
		get_tree().quit()

func spawn_player(level):
	var player_node = get_tree().get_first_node_in_group('Player')
	if player_node != null:
		call_deferred("defered_queue", player_node)
	var new_player = player.instantiate()
	var marker_pos = level.get_node('PlayerSpawn').position
	new_player.position = marker_pos
	call_deferred("add_child", new_player)
