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
	#mi codigo por si corrompe todo :v
	match new_hp:
		
		100:$HUD/Vidav.frame=1
		
		90:$HUD/Vidav.frame=2
		
		80:$HUD/Vidav.frame=3
		
		70:$HUD/Vidav.frame=4
		
		60:$HUD/Vidav.frame=5
		
		50:$HUD/Vidav.frame=6
		
		40:$HUD/Vidav.frame=7
		
		30:$HUD/Vidav.frame=8
		
		20:$HUD/Vidav.frame=9
		
		10:$HUD/Vidav.frame=10
		
		0:$HUD/Vidav.frame=11
		
		

func _on_p2_hp_changed(new_hp):
	barra_p2.value = new_hp

#mi codigo por si corrompe todo :v

#daquem lol causas
	match new_hp:
		
		100:$HUD/Vidavp2.frame=1
		
		90:$HUD/Vidavp2.frame=2
		
		80:$HUD/Vidavp2.frame=3
		
		70:$HUD/Vidavp2.frame=4
		
		60:$HUD/Vidavp2.frame=5
		
		50:$HUD/Vidavp2.frame=6
		
		40:$HUD/Vidavp2.frame=7
		
		30:$HUD/Vidavp2.frame=8
		
		20:$HUD/Vidavp2.frame=9
		
		10:$HUD/Vidavp2.frame=10
		
		0:$HUD/Vidavp2.frame=11
		
		
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
		

	
	
	
