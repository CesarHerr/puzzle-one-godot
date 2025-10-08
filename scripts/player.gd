class_name Player extends CharacterBody2D

signal attack_finished

@onready var state_machine: Node = $StateMachine
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/healthComponent
@onready var attack_area: Area2D = $attackArea
@onready var sentinel: Sentinel = $"../Sentinel"

var move_speed = 200
var attack_damage = 150
var attackBy = null
var looking = null
var is_attacking = false
var is_dead = false
var is_hit = false

func _ready():
	call_deferred("initialize_state_machine")

func initialize_state_machine():
	state_machine.change_state("IdleState")

func _physics_process(delta):
	if state_machine.current_state:
		state_machine.current_state.physics_process(self, delta)

func _input(event):
	if state_machine.current_state:
		state_machine.current_state.handle_input(self, event)

# Métodos usados por los estados:

func move_and_look(dir: Vector2, _delta: float) -> void:
	velocity = dir * move_speed
	if abs(dir.x) > abs(dir.y):
		move_and_look_horizontal(dir)
	elif abs(dir.y) > 0:
		move_and_look_vertical(dir)
	move_and_slide()
	
func move_and_look_horizontal(dir):
	if dir.x < 0:
		looking = "left"
		attack_area.scale.x = -1
		attackBy = "right"
		sprite_animation.flip_h = true
	else:
		looking = "right"
		attack_area.scale.x = 1
		attackBy = "left"
		sprite_animation.flip_h = false
	sprite_animation.play("run_x")
	
func move_and_look_vertical(dir):
	if dir.y < 0:
		looking = "up"
		sprite_animation.play("run_up")
	else:
		looking = "down"
		sprite_animation.play("run_down")

func stop_movement() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, move_speed)
	if looking == "up":
		sprite_animation.play("idle_up")
	else:
		sprite_animation.play("idle_down")
	move_and_slide()

func play_idle_animation() -> void:
	if looking == "up":
		sprite_animation.play("idle_up")
	else:
		sprite_animation.play("idle_down")

func play_attack_animation() -> void:
	if looking == "down":
		sprite_animation.play("attack_down")
	elif looking == "right" or looking == "left":
		sprite_animation.play("attack_x")
	else:
		sprite_animation.play("attack_up")

func play_hit_animation() -> void:
	if looking == "down":
		sprite_animation.play("ghost_down")
	elif looking == "right" or looking == "left":
		sprite_animation.play("ghost_x")
	else:
		sprite_animation.play("ghost_up")

func play_death_animation() -> void:
	if looking == "down":
		sprite_animation.play("death_down")
	elif looking == "right" or looking == "left":
		sprite_animation.play("death_x")
	else:
		sprite_animation.play("death_up")

func hit_player(damage: int, attacked_by: String) -> void:
	health_component.receive_damage(damage)
	moved_by_hit(attacked_by)
	if health_component.current_health <= 0:
		state_machine.change_state("DeadState")
	else:
		state_machine.change_state("HitState")

func moved_by_hit(attacked_by: String) -> void:
	position.x = position.x + 100 if attacked_by == "left" else position.x - 100

func _on_animated_sprite_2d_animation_finished() -> void:
	var anim = sprite_animation.animation
	if anim == "attack_down" or anim == "attack_x" or anim == "attack_up":
		attack_finished.emit()
		state_machine.change_state("IdleState")
	elif anim == "ghost_down" or anim == "ghost_up" or anim == "ghost_x":
		state_machine.change_state("IdleState")
	elif anim == "death_down" or anim == "death_x" or anim == "death_up":
		get_tree().paused = true

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Sentinel:
		body.is_in_damage_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Sentinel:
		body.is_in_damage_range = false
