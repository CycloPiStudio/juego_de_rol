extends Control

# conecta las llamadas "fallo de conexion con la func _a_conexion_falla...etc
func _ready():

	GlobalServer.connect("fallo_conexion", self, "_a_conexion_falla")
	GlobalServer.connect("conexion_exitosa", self, "_a_conexion_exitosa")
	GlobalServer.connect("cambia_lista_jugadores", self, "refrescar_lobby")
	GlobalServer.connect("final_juego", self, "_a_final_juego")
	GlobalServer.connect("error_juego", self, "_a_error_juego")

# boton de HOST
func _on_Host_pressed():
	# si no pones nada en el nombre retorna
	if $Connect/Name.text == "":
		$Connect/ErrorLabel.text = "Nombre no valido!"
		return
	$Connect.hide()
	$Players.show()
	$Connect/ErrorLabel.text = ""

	var nombre_jugador = $Connect/Name.text
	# crear juego crea un servidor
	GlobalServer.crear_juego(nombre_jugador)
	refrescar_lobby()

func _on_Start_pressed():
	pass # Replace with function body.


func _on_Join_pressed():
	if $Connect/Name.text == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return

	var ip = $Connect/IPAddress.text
	if not ip.is_valid_ip_address():
		$Connect/ErrorLabel.text = "Invalid IP address!"
		return

	$Connect/ErrorLabel.text = ""
	$Connect/Host.disabled = true
	$Connect/Join.disabled = true

	var nombre_jugador = $Connect/Name.text
	GlobalServer.join_game(ip, nombre_jugador)

func _a_conexion_exitosa():
	$Connect.hide()
	$Players.show()


func _a_conexion_falla():
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false
	$Connect/ErrorLabel.set_text("Error de conexion.")


func _a_final_juego():
	show()
	$Connect.show()
	$Players.hide()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false


func _a_error_juego(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false



func refrescar_lobby():
	var jugadores = GlobalServer.coger_lista_jugadores()
	jugadores.sort()
	$Players/List.clear()
	$Players/List.add_item(GlobalServer.coger_nombre_jugador() + " (You)")
	for p in jugadores:
		$Players/List.add_item(p)

	$Players/Start.disabled = not get_tree().is_network_server()

func _on_game_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false





func _on_start_pressed():
#	GlobalServer.empezar_juego()
	pass

func _on_find_public_ip_pressed():
	OS.shell_open("https://icanhazip.com/")
