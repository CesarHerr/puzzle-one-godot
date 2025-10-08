class_name Sentinel extends CharacterBody2D

var attack_damage := 25
var move_speed := 75
# Flags for interactions
var is_attacking := false
var is_dead := false
var is_in_damage_range := false
var is_hit := false
var attackBy := "left"

# referencia del player
@onready var player: Player = $"../Player"

@onready var state_machine: Node = $StateMachine

# referencia de la animacion
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
# referencia de heatlgomponent
@onready var health_component: HealthComponent = $Components/healthComponent

func _ready() -> void:
	if player:
		player.attack_finished.connect(verify_receive_damage)
	call_deferred("initialize_state_machine")

func initialize_state_machine():
	state_machine.change_state("IdleState")

# verifico si estoy en la zona de ataque
func verify_receive_damage():
	if is_in_damage_range:
		# recibe daño del player
		if !is_dead and player.is_attacking:
			state_machine.change_state("HitState")
			health_component.receive_damage(player.attack_damage)
			moved_by_hit()
			if health_component.current_health <= 0:
				state_machine.change_state("DeadState")

func move_and_look() -> void:
	if !is_attacking and player and !is_dead and !is_hit and !player.is_dead:
		sprite_animation.play("run_x")
		# la direccion del movimiento es la del jugador menos su posicion
		# esto es para que el sentinel siga al player
		var move_direction = (player.position - position).normalized()
		if move_direction:
			velocity = move_direction * move_speed
			sprite_animation.flip_h = move_direction.x < 0
			$attackArea.scale.x = -1 if move_direction.x < 0 else 1
			attackBy = "right" if move_direction.x <0 else "left"
		move_and_slide()

# Behavior after the sentinel is hit
func moved_by_hit():
	print(player.attackBy)
	if player.attackBy == "left":
		position.x = position.x + 100
	else:
		position.x = position.x - 100

func stop_movement() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed)
	sprite_animation.play("idle_up")
	move_and_slide()

func play_idle_animation() -> void:
	sprite_animation.play("idle_up")

func play_attack_animation() -> void:
	sprite_animation.play("attack_x")

func play_hit_animation() -> void:
	sprite_animation.play("ghost_x")

func play_death_animation() -> void:
	sprite_animation.play("death_x")

# Zona de ataque
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player and !is_dead:
		state_machine.change_state("AttackState")

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Player:
		state_machine.change_state("IdleState")

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack_x":
		# golpea al player
		player.hit_player(attack_damage, attackBy)
		state_machine.change_state("IdleState")
	if sprite_animation.animation == "ghost_x":
		state_machine.change_state("IdleState")
		
	if sprite_animation.animation == "death_x":
		queue_free()
