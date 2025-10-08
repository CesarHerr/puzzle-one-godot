class_name HealthComponent extends Node2D

@export var progress_bar: ProgressBar
@export var current_health := 500
@export var max_health := 500

func _ready() -> void:
	progress_bar.max_value = max_health
	update_health_bar()

func update_health_bar():
	if progress_bar:
		progress_bar.value = current_health
		
func receive_damage(amount: int):
	# clamp asegura que no devuelva numero menor que 0 ni mayor que max_health
	current_health = clamp(current_health - amount, 0, max_health)
	update_health_bar()
	if current_health <= 0:
		on_death()
	
func apply_health(amount: int):
	current_health = clamp(current_health + amount, 0, max_health)
	update_health_bar()
	
func on_death():
	print("death")
