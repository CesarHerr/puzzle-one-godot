extends "res://scripts/states/player_state.gd"

func enter(context):
	if context.is_dead:
		return

	context.is_dead = true
	context.play_death_animation()

func physics_process(_context, _delta):
	pass

func handle_input(_context, _event):
	pass

func exit(_context):
	pass
