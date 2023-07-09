extends Node2D

signal next_level
signal restart_level

@export var next: PackedScene

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _on_spike_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal('restart_level', self)


func _on_finish_line_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal('next_level', self)
