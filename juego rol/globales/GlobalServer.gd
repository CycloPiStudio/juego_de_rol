extends Node

const DEFAULT_PORT =  1909
#10567
const MAX_JUGADORES = 12
#"127.0.0.1"
var peer = null
var nombre_jugador = "Barbaro"
var jugadores = {}
var jugadores_preparados = []

# Signals to let lobby GUI know what's going on.
signal cambia_lista_jugadores()
signal fallo_conexion()
signal conexion_exitosa()
signal final_juego()
signal error_juego(what)

func _jugador_conectado(id):
	# Registration of a client beings here, tell the connected player that we are here.
	rpc_id(id, "registrar_jugador", nombre_jugador)


func _jugador_desconectado(id):
	if has_node("/root/Mundo"): # Game is in progress.
		if get_tree().is_network_server():
			emit_signal("error_juego", "Jugador " + jugadores[id] + " desconectado")
			end_game()
	else: # Game is not in progress.
		# Unregister this player.
		unregister_player(id)


# Callback from SceneTree, only for clients (not server).
func _conexion_ok():
	# We just connected to a server
	emit_signal("conexion_exitosa")


# Callback from SceneTree, only for clients (not server).
func _servidor_desconectado():
	emit_signal("error_juego", "Server disconnected")
	end_game()


# Callback from SceneTree, only for clients (not server).
func _fallo_conexion():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("fallo_conexion")


remote func registrar_jugador(nuevo_nombre_jugador):
	var id = get_tree().get_rpc_sender_id()
	print(id)
	jugadores[id] = nuevo_nombre_jugador
	emit_signal("cambia_lista_jugadores")


func unregister_player(id):
	jugadores.erase(id)
	emit_signal("cambia_lista_jugadores")


func crear_juego(nuevo_nombre_jugador):
	nombre_jugador = nuevo_nombre_jugador
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_JUGADORES)
	get_tree().set_network_peer(peer)


func join_game(ip, nuevo_nombre_jugador):
	nombre_jugador = nuevo_nombre_jugador
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)


func coger_lista_jugadores():
	return jugadores.values()


func coger_nombre_jugador():
	return nombre_jugador

#func empezar_juego():
#	assert(get_tree().is_network_server())
#
#	# Create a dictionary with peer id and respective spawn points, could be improved by randomizing.
#	var spawn_points = {}
#	spawn_points[1] = 0 # Server in spawn point 0.
#	var spawn_point_idx = 1
#	for p in jugadores:
#		spawn_points[p] = spawn_point_idx
#		spawn_point_idx += 1
#	# Call to pre-start game with the spawn points.
#	for p in jugadores:
#		rpc_id(p, "pre_start_game", spawn_points)
#
#	pre_start_game(spawn_points)

func end_game():
	if has_node("/root/World"): # Game is in progress.
		# End it
		get_node("/root/World").queue_free()

	emit_signal("final_juego")
	jugadores.clear()

func _ready():
	
	get_tree().connect("network_peer_connected", self, "_jugador_conectado")
	get_tree().connect("network_peer_disconnected", self,"_jugador_desconectado")
	get_tree().connect("connected_to_server", self, "_conexion_ok")
	get_tree().connect("connection_failed", self, "_fallo_conexion")
	get_tree().connect("server_disconnected", self, "_servidor_desconectado")
	
