extends Popup



func MostrarChat(valor):
	visible = valor
	

func _on_ButtonTextoChat_pressed():
	var ListaPeers = get_tree().multiplayer.get_network_connected_peers()
	if ListaPeers.size()!=0:
		if not $TextEditChat.get_text().empty():
			GlobalServer.MandarTextoChat(GlobalServer.Jugador, $TextEditChat.get_text())
			$TextEditChat.clear()

func ResetearTextListaJugadores(listjug):
	$TextListaJugadores.clear()
	for j in listjug:
		$TextListaJugadores.add_text(str(j["NOMBRE"]))
		$TextListaJugadores.newline()

func _on_Button2_pressed():
	pass # Replace with function body.
