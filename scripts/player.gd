class_name Player extends CharacterBody2D

var is_interacting := false
var attack_damage := 50
var move_speed := 100
var is_attacking := false
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D

# función que detecta el evento de presionar un click izquiero, mouse
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# En este punto detecta cuano el click se presiona y se suelta
		if event.pressed:
			# En este punto detecta solo cuando es presionado
			attack()
			
# función que detecta cierta física, en este caso, botones de movimiento
func _physics_process(_delta: float) -> void:
	# condiciona solo si el pj no está atacando, evita que se mueva al atacar
	if !is_attacking:
		var move_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		# Acción al detectar movimiento
		if move_direction.x != 0:
			# reproduce accion "run" del pj
			sprite_animation.play("run_x")
			# reproduce movimiento segun dirección presionada
			velocity = move_direction * move_speed
			# acción de girar al personaje, según donde se mueva
			sprite_animation.flip_h = true if move_direction.x < 0 else false
		else: if move_direction.y !=0:
			# reproduce accion "run" del pj
			sprite_animation.play("run_up" if move_direction.y < 0 else "run_down")
			# reproduce movimiento segun dirección presionada
			velocity = move_direction * move_speed
		else:
			# Evita que la detención del movimiento sea brusca
			velocity = velocity.move_toward(Vector2.ZERO, move_speed)
			# cambia a animación "idle" al detenerse
			sprite_animation.play("idle")
		move_and_slide()

func attack():
	sprite_animation.play("attack")
	is_attacking = true
	print("attacking")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack":
		is_attacking = false
