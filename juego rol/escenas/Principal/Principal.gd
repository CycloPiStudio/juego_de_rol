extends Spatial


onready var escenaMenuPrincipal = preload("res://menus/MenuPrincipal/Menuprincipal.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var node = escenaMenuPrincipal.instance()	
	add_child(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
