extends Container

var Ab = []
var i = 0
onready var GLOBAL = get_node("/root/GLOBAL")
var t = 2 # tempo em segundos da animação da aparição dos botoes

func _ready():
	i=0
	Ab = [$B_Collection,$B_Decks,$B_Wishlist,$B_Tradable,$B_Conf,$B_Log]
	while i<Ab.size():
		Ab[i].modulate = Color(1,1,1,0)
		Ab[i].visible=false
		i+=1
	$LOGO.visible=true
	$Tween.interpolate_property($LOGO,"position:y", $LOGO.position[1]+500, $LOGO.position[1], t, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($LOGO,"modulate", Color(1,1,1,0), Color(1,1,1,1), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	i=0
	while i<Ab.size():
		Ab[i].visible=true
		Ab[i].connect("pressed",self,"selected_b",[i,Ab[i]])
		$Tween.interpolate_property(Ab[i],"position:y", Ab[i].position[1]+500*(i+1), Ab[i].position[1], t+i*0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		$Tween.interpolate_property(Ab[i],"modulate", Color(1,1,1,-(i+1)), Color(1,1,1,0.8), t+i*0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		i+=1

func selected_b(button,e):
	print("MAIN / selected_b(" + String(button) + "," + e.name + "):")
	$Timer.connect("timeout",self,"goto",[button])
	$Timer.wait_time=1
	$Timer.start()
	e.modulate = Color(1,1,1,1)
	i=0
	$Tween.interpolate_property($LOGO,"modulate", Color(1,1,1,1), Color(1,1,1,-0.5), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	while i<Ab.size():
		if(button==i):
			$Tween.interpolate_property(Ab[i],"position:x", Ab[i].position[0], Ab[i].position[0]+1500, t, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
			$Tween.interpolate_property(Ab[i],"modulate", Color(1,1,1,0.8), Color(1,1,1,-0.5), t, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
			i+=1
		else:
			$Tween.interpolate_property(Ab[i],"position:x", Ab[i].position[0], Ab[i].position[0]-1500, t, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
			$Tween.interpolate_property(Ab[i],"modulate", Color(1,1,1,0.8), Color(1,1,1,-0.5), t, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
			i+=1

func goto(scene):
	print("MAIN / goto("+String(scene)+")")
	match scene:
		0: # Colletion
			GLOBAL.WT=0
			get_tree().change_scene("res://SCENE/COLLECTION.tscn")
		1: # Deck
			get_tree().change_scene("res://SCENE/MY_DECKS.tscn")
			GLOBAL.WT=2
		2: # Wishlist
			GLOBAL.WT=-1
			get_tree().change_scene("res://SCENE/COLLECTION.tscn")
		3: # Tradable
			GLOBAL.WT=1
			get_tree().change_scene("res://SCENE/COLLECTION.tscn")
		4: # Conf
			get_tree().change_scene("res://SCENE/CONF.tscn")
		5: # LOG
			get_tree().change_scene("res://SCENE/UPDATE_LOG.tscn")
