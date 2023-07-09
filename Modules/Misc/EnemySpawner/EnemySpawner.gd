extends Node2D

@onready var wave_timer = $WaveTimer

@export var time_until_first_wave: int
@export var max_per_wave: int
@export var enemy_list: Array[PackedScene]
@export var enemy_total: int
@export var min_time_between_wave: int
@export var max_time_between_wave: int
@export var enemy_level: int

var _enemys_spawned = 0

func _ready():
	wave_timer.start(time_until_first_wave)

func _on_timer_timeout():
	if _enemys_spawned < enemy_total:
		var enemy_index = randi_range(0, enemy_list.size() - 1)
		var enemy_instance: Entity = enemy_list[enemy_index].instantiate()
		enemy_instance.level = enemy_level
		enemy_instance.global_position = global_position
		var enemy_set = get_node('/root/World/Enemys')
		enemy_set.add_child(enemy_instance)
		
		var new_timer_conter = randi_range(min_time_between_wave, max_time_between_wave)
		wave_timer.start(new_timer_conter)
		_enemys_spawned += 1
