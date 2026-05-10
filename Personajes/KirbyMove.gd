class_name MoveK
extends KinematicBody2D

export var gravity = 1500
export var speed = 400
export var jump_force = -600 # Valor negativo para ir hacia arriba
var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta):
	# Aplicar gravedad
	velocity.y += gravity * delta
	
	# Reiniciar movimiento horizontal
	velocity.x = 0
	
	# Detectar movimiento horizontal
	if Input.is_action_pressed("p1_right"):
		velocity.x = speed
	if Input.is_action_pressed("p1_left"):
		velocity.x = -speed
	
	# --- LÓGICA DE SALTO ---
	# is_on_floor() solo funciona si usas Vector2.UP en move_and_slide
	if is_on_floor() and Input.is_action_just_pressed("p1_up"):
		velocity.y = jump_force
	
	# Mover el personaje
	velocity = move_and_slide(velocity, Vector2.UP)
