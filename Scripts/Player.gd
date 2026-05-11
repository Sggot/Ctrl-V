class_name Player
extends KinematicBody2D


# ---- Exportables (editables desde el inspector) ----
export var gravity = 1500
export var speed = 400
export var jump_force = -600
export var player_id = 1
export var hp = 100
export var attack_damage = 10
export var attack_cooldown = 0.5  # segundos entre ataques


# ---- Señales (el HUD y Main.tscn las escuchan) ----
signal hp_changed(new_hp)
signal player_died


# ---- Variables internas ----
var velocity : Vector2 = Vector2.ZERO
var attack_key : String
var fuck1
var is_attacking = false
var cdHit


func _ready():
	# Definir tecla de ataque según jugador
	attack_key = "p1_attack" if player_id == 1 else "p2_attack"

	# La hitbox empieza desactivada
	$Hitbox/CollisionShape2D.disabled = true

	# Conectar señal del Area2D a esta misma función
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	print("si se esta ejecut<ndo")
	
	
func _physics_process(delta):
	# ---- Gravedad ----
	velocity.y += gravity * delta
	velocity.x = 0

	# ---- Teclas de movimiento según jugador ----
	var left  = "p1_left"  if player_id == 1 else "p2_left"
	var right = "p1_right" if player_id == 1 else "p2_right"
	var jump  = "p1_up"    if player_id == 1 else "p2_up"

	# ---- Movimiento horizontal ----
	if Input.is_action_pressed(right):
		velocity.x = speed

	if Input.is_action_pressed(left):
		velocity.x = -speed
	
	
	# ---- Salto ----
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = jump_force
		
		
		
	# ---- Ataque ----
	if not is_attacking :
		$AnimatedSprite.play("Idle")
			
			
	# ---- Aplicar movimiento ----
	velocity = move_and_slide(velocity, Vector2.UP)

	_attack()

func _attack():
	if Input.is_action_just_pressed(attack_key) and $CooldownTimer.is_stopped():
		is_attacking = true
		$AnimatedSprite.play("attack")
		$Hitbox/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(0.4), "timeout")
		$Hitbox/CollisionShape2D.disabled = true
		$CooldownTimer.start()
		is_attacking = false
		$AnimatedSprite.play("Idle")
		
		
func _on_Hitbox_body_entered(body):
	# Verificar que el cuerpo que entró no sea uno mismo
	if body != self and body.has_method("take_damage"):
		body.take_damage(attack_damage)
		
		
func take_damage(amount):
	# Restar vida
	hp -= amount

	# Avisar al HUD que la vida cambió
	emit_signal("hp_changed", hp)

	# Si se acabó la vida, avisar que este jugador perdió
	if hp <= 0:
		emit_signal("player_died")



