extends Sprite

func _ready():
	visible=true
	$TSB.connect("released",self,"Return2Title")
	if (GLOBAL.WT==-1):
		var scene="Wishlist"
		set_texture(load("res://IMAGENS_ICONES/Icon_"+scene+".png"))
		$RichTextLabel.text=scene
	elif (GLOBAL.WT==1):
		var scene="Tradable"
		set_texture(load("res://IMAGENS_ICONES/Icon_"+scene+".png"))
		$RichTextLabel.text=scene
	elif (GLOBAL.WT==2):
		#var scene="My_Decks"
		set_texture(load("res://IMAGENS_ICONES/Icon_My_Decks.png"))
		$RichTextLabel.text="My Decks"

func Return2Title():
	get_tree().change_scene("res://SCENE/MAIN.tscn")
