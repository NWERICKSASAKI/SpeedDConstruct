extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TopMenu/BackButton.connect("pressed",self,"_go_back_to_my_deck")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _go_back_to_my_deck():
	get_tree().change_scene("res://SCENE/MY_DECKS.tscn")
