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
var lol = 1  # 1 = mirando derecha, 0 = mirando izquierda

onready var collision_shape_2d = $Hitbox/CollisionShape2D

func _ready():
	attack_key = "p1_attack" if player_id == 1 else "p2_attack"
	collision_shape_2d.disabled = true
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$AnimatedSprite.play("IdleR")

func _physics_process(delta):
	# ---- Teclas según jugador ----
	var left  = "p1_left"  if player_id == 1 else "p2_left"
	var right = "p1_right" if player_id == 1 else "p2_right"
	var jump  = "p1_up"    if player_id == 1 else "p2_up"

	# ---- Gravedad ----
	velocity.y += gravity * delta
	velocity.x = 0

	# ---- Movimiento horizontal ----
	if Input.is_action_pressed(right):
		velocity.x = speed
		lol = 1
	if Input.is_action_pressed(left):
		velocity.x = -speed
		lol = 0

	# ---- Animaciones ----
	fuck()

	# ---- Salto ----
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = jump_force

	# ---- Ataque ----
	_attack()

	# ---- Aplicar movimiento ----
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func fuck():
	if not is_attacking:
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
			if $AnimatedSprite.animation != "walk":
				$AnimatedSprite.play("walk")
		elif velocity.x < 0:
				$AnimatedSprite.flip_h = false
				if $AnimatedSprite.animation != "walk1":
					$AnimatedSprite.play("walk1")
		else:
			if lol == 1:
				$AnimatedSprite.flip_h = false
				if $AnimatedSprite.animation != "IdleR":
					$AnimatedSprite.play("IdleR")
			else:
				$AnimatedSprite.flip_h = true
				if $AnimatedSprite.animation != "IdleL":
					$AnimatedSprite.play("IdleL")
					
					
func _attack():
	if Input.is_action_just_pressed(attack_key) and not is_attacking and $CooldownTimer.is_stopped():
		is_attacking = true
		collision_shape_2d.disabled = false
		$AnimatedSprite.play("attack")

func _on_animation_finished():
	if $AnimatedSprite.animation == "attack":
		collision_shape_2d.disabled = true
		$CooldownTimer.start(attack_cooldown)
		is_attacking = false
		# Volver al idle correcto según dirección
		if lol == 1:
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
