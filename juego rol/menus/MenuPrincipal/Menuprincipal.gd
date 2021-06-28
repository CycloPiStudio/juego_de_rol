extends Control
onready var EscenaPrincipal = get_parent()
onready var TextEditNOMBRE = get_node("TextEditNOMBRE")
onready var ClienteBoton = get_node("ButtonCliente")
onready var ServerBoton = get_node("ButtonServidor")
onready var Info = get_node("ColorInfo/Info")
onready var ClienteTextEditSERVER_IP = get_node("PORT")
onready var ServerTextEditSERVER_PORT = get_node("IPSERVER")



# Called when the node enters the scene tree for the first time.
func _ready():
	ClienteTextEditSERVER_IP.set_text("127.0.0.1")
	ServerTextEditSERVER_PORT.set_text("1909")


func _on_ButtonServidor_pressed():
	var SERVER_PORT = int(ServerTextEditSERVER_PORT.get_text())
	
	if not TextEditNOMBRE.get_text().empty():
		desactivarBotones(true)
		GlobalServer.Jugador = TextEditNOMBRE.get_text()
		GlobalServer.create_server(SERVER_PORT)
		EscenaPrincipal.get_node("CapaChat/Chat").MostrarChat(true)
	else:
		PrintInfo(" Pon un nombre ")
	

func _on_ButtonCliente_pressed():
	var SERVER_PORT = int(ServerTextEditSERVER_PORT.get_text())
	var SERVER_IP = ClienteTextEditSERVER_IP.get_text()
	 
	if not TextEditNOMBRE.get_text().empty():
		desactivarBotones(true)
		GlobalServer.Jugador = TextEditNOMBRE.get_text()
		GlobalServer.create_client(SERVER_IP, SERVER_PORT)
		
	else:
		PrintInfo(" Pon un nombre ")

func PrintInfo(i):
	Info.set_text(i)
	pass

func desactivarBotones(d):
	ClienteBoton.disabled = d
	ServerBoton.disabled = d



	
