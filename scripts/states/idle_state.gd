extends "res://scripts/states/player_state.gd"

func enter(context):
	context.play_idle_animation()

func physics_process(context, delta):
	if !context is Player:
		context.move_and_look()
		return

	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir != Vector2.ZERO:
		context.move_and_look(dir, delta)
	else:
		context.stop_movement()

func handle_input(context, event):
	var left_mouse = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
	if left_mouse and event.pressed and context is Player:
		context.state_machine.change_state("AttackState")

func exit(_context):
	pass
