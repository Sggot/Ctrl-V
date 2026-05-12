class_name Player
extends KinematicBody2D

export var gravity = 1500
export var speed = 400
export var jump_force = -600
export var player_id = 1
export var hp = 100
export var attack_damage = 10
export var attack_cooldown = 0.5

signal hp_changed(new_hp)
signal player_died

var velocity : Vector2 = Vector2.ZERO
var attack_key : String
var is_attacking : bool = false
export var direction = 1 # 1 para Derecha, 0 para Izquierda (antes llamado lol)

func _ready():
	attack_key = "p1_attack" if player_id == 1 else "p2_attack"
	$Hitbox/CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D1.disabled = true
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$AnimatedSprite.play("IdleR")

func _physics_process(delta):
	var left  = "p1_left"  if player_id == 1 else "p2_left"
	var right = "p1_right" if player_id == 1 else "p2_right"
	var jump  = "p1_up"    if player_id == 1 else "p2_up"

	# Aplicar gravedad siempre
	velocity.y += gravity * delta
	
	# Reiniciar velocidad horizontal
	velocity.x = 0

	# MOVIMIENTO: Solo si no estamos atacando
	if not is_attacking:
		if Input.is_action_pressed(right):
			velocity.x = speed
			direction = 1
		elif Input.is_action_pressed(left):
			velocity.x = -speed
			direction = 0

		if is_on_floor() and Input.is_action_just_pressed(jump):
			velocity.y = jump_force

	# SISTEMA DE ATAQUE
	_attack()

	# GESTIÓN DE ANIMACIONES: Solo si no está atacando (para no interrumpir el ataque)
	if not is_attacking:
		_update_animations()

	# Aplicar movimiento
	velocity = move_and_slide(velocity, Vector2.UP)

func _update_animations():
	if not is_on_floor():
		if direction == 1:
			if $AnimatedSprite.animation != "jump":
				$AnimatedSprite.play("jump")
		else:
			if $AnimatedSprite.animation != "jump1":
				$AnimatedSprite.play("jump1")
	elif velocity.x > 0:
		if $AnimatedSprite.animation != "walk":
			$AnimatedSprite.play("walk")
	elif velocity.x < 0:
		if $AnimatedSprite.animation != "walk1":
			$AnimatedSprite.play("walk1")
	else:
		# IDLE: Aquí se corrige que se quede mirando a la izquierda
		if direction == 1:
			if $AnimatedSprite.animation != "IdleR":
				$AnimatedSprite.play("IdleR")
		else:
			if $AnimatedSprite.animation != "IdleL":
				$AnimatedSprite.play("IdleL")

func _attack():
	# Solo atacar si no está atacando ya y el cooldown terminó
	if Input.is_action_just_pressed(attack_key) and not is_attacking and $CooldownTimer.is_stopped():
		is_attacking = true
		
		if direction == 1:
			$Hitbox/CollisionShape2D.disabled = false
			$AnimatedSprite.play("attack")
		else:
			$Hitbox/CollisionShape2D1.disabled = false
			$AnimatedSprite.play("attack1")

func _on_animation_finished():
	# Solo resetear si terminó una animación de ataque
	if $AnimatedSprite.animation == "attack" or $AnimatedSprite.animation == "attack1":
		$Hitbox/CollisionShape2D.disabled = true
		$Hitbox/CollisionShape2D1.disabled = true
		$CooldownTimer.start(attack_cooldown)
		is_attacking = false
		
		# Después de atacar, volver al Idle correspondiente inmediatamente
		if direction == 1:
			$AnimatedSprite.play("IdleR")
		else:
			$AnimatedSprite.play("IdleL")

func _on_Hitbox_body_entered(body):
	if body != self and body.has_method("take_damage"):
		body.take_damage(attack_damage)

func take_damage(amount):
	hp -= amount
	emit_signal("hp_changed", hp)
	if hp <= 0:
		emit_signal("player_died")
