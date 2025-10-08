extends "res://scripts/states/player_state.gd"

func enter(context):
	context.is_attacking = true
	context.play_attack_animation()

func physics_process(_context, _delta):
	# No moverse mientras ataca
	pass

func handle_input(_context, _event):
	# Ignora input durante ataque
	pass

func exit(context):
	context.is_attacking = false
