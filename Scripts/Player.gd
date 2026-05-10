class_name Player
extends KinematicBody2D

export var gravity = 1500
export var speed = 400
export var jump_force = -600
export var player_id = 1  # Cambia a 2 en el inspector del P2

var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0

	var left  = "p1_left"  if player_id == 1 else "p2_left"
	var right = "p1_right" if player_id == 1 else "p2_right"
	var jump  = "p1_up"    if player_id == 1 else "p2_up"

	if Input.is_action_pressed(right):
		velocity.x = speed
	if Input.is_action_pressed(left):
		velocity.x = -speed

	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = jump_force

	velocity = move_and_slide(velocity, Vector2.UP)
