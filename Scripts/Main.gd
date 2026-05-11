extends Node2D

onready var player1 = $P1
onready var player2 = $P2
onready var barra_p1 = $HUD/BarraP1
onready var barra_p2 = $HUD/BarraP2
onready var pantalla_victoria = $PantallaVictoria
onready var label_ganador = $PantallaVictoria/LabelGanador

func _ready():
	# Configurar barras de vida
	barra_p1.max_value = 100
	barra_p1.value = 100
	barra_p2.max_value = 100
	barra_p2.value = 100

	# Ocultar pantalla de victoria al inicio
	pantalla_victoria.visible = false

	# Conectar señales jugador 1
	player1.connect("hp_changed", self, "_on_p1_hp_changed")
	player1.connect("player_died", self, "_on_p1_died")

	# Conectar señales jugador 2
	player2.connect("hp_changed", self, "_on_p2_hp_changed")
	player2.connect("player_died", self, "_on_p2_died")

func _on_p1_hp_changed(new_hp):
	barra_p1.value = new_hp

func _on_p2_hp_changed(new_hp):
	barra_p2.value = new_hp

func _on_p1_died():
	mostrar_victoria("P2 Win")

func _on_p2_died():
	mostrar_victoria("P1 Win")

func mostrar_victoria(texto):
	pantalla_victoria.visible = true
	label_ganador.text = texto

# Reiniciar con cualquier tecla después de que alguien gane
func _input(event):
	if pantalla_victoria.visible and event.is_pressed():
		get_tree().reload_current_scene()
