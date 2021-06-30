extends Spatial

onready var escenaPortada = preload("res://Portada/Portada.tscn")
#onready var Chat = get_tree().get_root().get_node("Chat")
#onready var TextEditChat = get_node("Chat/TextEditChat")

func _ready():
	PonerEscena(escenaPortada)
	
# Para poner escenas
func PonerEscena(escena):
	var node = escena.instance()
	add_child(node)
	
# Para quitar escenas
func QuitarEscena(escena):
	get_tree().get_root().get_node(escena).queue_free()


# dejo anotado abajo en cada script la funcion de quitar de esta escena
#QuitarEscena("Principal/Menuprincipal")
