extends Node

var owner_player        # Referencia al Player
var current_state = null
var states = {}

func _ready():
	owner_player = get_parent()    # El Player es el nodo padre
	# Carga los estados ya instanciados como hijos
	for child in get_children():
		states[child.name] = child
	# Retrasa para que _ready() del Player y onready en Player se completen
	call_deferred("change_state", "IdleState")

func change_state(new_state_name):
	if current_state:
		current_state.exit(owner_player)
	current_state = states[new_state_name]
	current_state.enter(owner_player)

func _physics_process(delta):
	if current_state:
		current_state.physics_process(owner_player, delta)

func _input(event):
	if current_state:
		current_state.handle_input(owner_player, event)
