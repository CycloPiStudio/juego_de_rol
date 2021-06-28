extends Node
var peer = NetworkedMultiplayerENet.new()

onready var JUGADORES_MAX : int = 8
onready var EscenaPrincipal = get_tree().get_root().get_node("Principal")
# Player info, associate ID to data
onready var ListaJugadores : Array = []
# Info we send to other players
var Jugador : String
var TextoChatList : RichTextLabel


func create_server(SERVER_PORT):
	
	peer.create_server(SERVER_PORT, JUGADORES_MAX)
	get_tree().network_peer = peer
	EscenaPrincipal.get_node("CapaChat/Chat").MostrarChat(true)
	# Añado el servidor a la lista de Jugadores
	ListaJugadores.append({"ID": 1 , "NOMBRE" : Jugador})
	EscenaPrincipal.get_node("CapaChat/Chat").ResetearTextListaJugadores(ListaJugadores)
	print("servidor iniciado")
	
	peer.connect("peer_connected", self, "_Peer_Connected")
	peer.connect("peer_disconnected", self, "_Peer_Disconnected")


func create_client(SERVER_IP, SERVER_PORT):
	
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	peer.connect("connection_failed", self, "_OnConnectionFailed")
	peer.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	peer.connect("server_disconnected" , self, "_OnServerDisconnected")

func _Peer_Connected(id):
	ServerMandarTextoChat(id,":  se ha conectado")

func _Peer_Disconnected(id):
	print("jugador: ", id , " desconectado")

func _OnConnectionSucceeded():
	# el jugador le manda el registro al server
	var newJugador : String = Jugador
	MandarRegistroJugador(newJugador)
	EscenaPrincipal.get_node("CapaChat/Chat").MostrarChat(true)
	
func _OnConnectionFailed():
	EscenaPrincipal.get_node("Menuprincipal").PrintInfo("Error de conexion")
	EscenaPrincipal.get_node("Menuprincipal").desactivarBotones(false)

func _OnServerDisconnected():
	print("upps")

# el jugador manda el registro del nombre y la id
func MandarRegistroJugador(nuevoJugador):
	var ID = get_tree().get_network_unique_id()
	rpc_id(1,"ReciveRegistroServer", ID, nuevoJugador)
	
### el servidor recive el Registro del jugador
remote func ReciveRegistroServer(i , nuevoJugador):
	
	var Registro : Dictionary = {"ID": i , "NOMBRE" : nuevoJugador}
	ListaJugadores.append(Registro)
	print("ListaJugadores : ", ListaJugadores)
	### el servidor manda la Lista de Jugadores
	ServidorMandaListaJugadores(ListaJugadores)
### el servidor manda la Lista a todos los jugadores "0"
func ServidorMandaListaJugadores(Lista):
	rpc_id(0,"RecibirListaJugadores", Lista)
	### reseteo el RichTextLabel "TextListaJugadores" de la escena Chat
	EscenaPrincipal.get_node("CapaChat/Chat").ResetearTextListaJugadores(Lista)
# los jugadores reciben la lista
remote func RecibirListaJugadores(Lista):
	ListaJugadores = Lista
	EscenaPrincipal.get_node("CapaChat/Chat").ResetearTextListaJugadores(Lista)

func MandarTextoChat(jug , texto):

	if get_tree().is_network_server():
		#### el servidor manda el texto
		jug = Jugador
		ServerMandarTextoChat(jug, texto)
		
	else:
		#### el cliente manda el texto
		rpc_id(1, "ServerReciveTextoChat", Jugador, texto)
		
##### el servidor recive texto
remote func ServerReciveTextoChat(jug , texto):	
	ServerMandarTextoChat(jug, texto)

### el servidor le manda el texto a los clientes
func ServerMandarTextoChat(jug, texto):
	rpc_id(0, "RecivirJugadoresChat",jug , texto)
	AnadirTextoChat(jug, texto)
### los jugadores reciven el texto
remote func RecivirJugadoresChat(jug, texto):
	AnadirTextoChat(jug, texto)

func AnadirTextoChat(jug, texto):
	EscenaPrincipal.get_node("CapaChat/Chat/TextChat").add_text(str(jug , ": " ,texto))
	EscenaPrincipal.get_node("CapaChat/Chat/TextChat").newline()
	
