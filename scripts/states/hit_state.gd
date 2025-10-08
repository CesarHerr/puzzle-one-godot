extends "res://scripts/states/player_state.gd"

func enter(context):
	context.is_hit = true
	context.play_hit_animation()

func physics_process(_context, _delta):
	# No moverse ni atacar mientras está golpeado
	pass

func handle_input(_context, _event):
	# Ignora input
	pass

func exit(context):
	context.is_hit = false
