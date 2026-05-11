class_name Player
extends KinematicBody2D

# ---- Exportables (editables desde el inspector) ----
export var gravity = 1500
export var speed = 400
export var jump_force = -600
export var player_id = 1
export var hp = 100
export var attack_damage = 10
export var attack_cooldown = 0.5

# ---- Señales ----
signal hp_changed(new_hp)
signal player_died

# ---- Variables internas ----
var velocity : Vector2 = Vector2.ZERO
var attack_key : String
var is_attacking : bool = false

onready var collision_shape_2d = $Hitbox/CollisionShape2D

func _ready():
	# Definir tecla de ataque según jugador
	attack_key = "p1_attack" if player_id == 1 else "p2_attack"
	
	# Hitbox desactivada al inicio
	collision_shape_2d.disabled = true
	
	# Conectar señal de hitbox
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	
	# Conectar señal de animación terminada
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	
	# Reproducir animación inicial
	$AnimatedSprite.play("Idle")

func _physics_process(delta):
	# ---- Gravedad ----
	velocity.y += gravity * delta
	velocity.x = 0

	# ---- Teclas según jugador ----
	var left  = "p1_left"  if player_id == 1 else "p2_left"
	var right = "p1_right" if player_id == 1 else "p2_right"
	var jump  = "p1_up"    if player_id == 1 else "p2_up"

	# ---- Movimiento horizontal ----
	if Input.is_action_pressed(right):
		velocity.x = speed
	if Input.is_action_pressed(left):
		velocity.x = -speed
		
	
	# ---- Animación de movimiento ----
	fuck()
	

	# ---- Salto ----
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = jump_force


	# ---- Ataque ----
	_attack()

	# ---- Aplicar movimiento ----
	velocity = move_and_slide(velocity, Vector2.UP)

func _attack():
	# Solo ataca si no está atacando y el cooldown terminó
	if Input.is_action_just_pressed(attack_key) and not is_attacking and $CooldownTimer.is_stopped():
		is_attacking = true
		collision_shape_2d.disabled = false
		$AnimatedSprite.play("attack")

func _on_animation_finished():
	# Cuando termina la animación de ataque, desactivar hitbox y empezar cooldown
	if $AnimatedSprite.animation == "attack":
		collision_shape_2d.disabled = true
		$CooldownTimer.start(attack_cooldown)
		is_attacking = false
		$AnimatedSprite.play("Idle")

func _on_Hitbox_body_entered(body):
	# Si toca al rival, aplicarle daño
	if body != self and body.has_method("take_damage"):
		body.take_damage(attack_damage)

func take_damage(amount):
	# Restar vida y emitir señales
	hp -= amount
	emit_signal("hp_changed", hp)
	if hp <= 0:
		emit_signal("player_died")

func fuck():
	if not is_attacking:
		if velocity.x > 0:
			if $AnimatedSprite.animation != "walk":
				$AnimatedSprite.play("walk")
		elif velocity.x < 0:
			if $AnimatedSprite.animation != "walk1":
				$AnimatedSprite.play("walk1")
		else:
			if $AnimatedSprite.animation != "Idle":
				$AnimatedSprite.play("Idle")
