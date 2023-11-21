extends KinematicBody2D


#var ori_pos = 425
var can_grab = false
var grabbed_offset = Vector2()
var a_off = false
onready var Tw = get_parent().get_node("Tween")
onready var SET = get_parent().get_node("SET")

var G=[] # onde fica armazenado os COVER de SET
var SetA = []
onready var GLOBAL = get_node("/root/GLOBAL")
onready var DATABASE = GLOBAL.DATABASE
onready var WT = GLOBAL.WT

func _ready():
	set_process(false)
	position.x=2500
	set_process_input(false)
	loadCoverImage()


func loadCoverImage():
	var i=0
	var j=0
	var repetido=false
	while i<DATABASE.size():
		repetido = false
		j=0
		while j<SetA.size():
			if DATABASE[i][4] == SetA[j]:
				repetido=true
			j+=1
		if repetido == false:
			SetA.append(DATABASE[i][4])
		i+=1
	print("SetA = "+String(SetA))
	var TamSet = 300 # pixels
	i = 0
	while i<SetA.size():
		var COVER_NODE = preload("res://SCENE/COVER.tscn").instance()
		COVER_NODE.position=Vector2(TamSet*G.size(),-250)#obrigatorio estar antes do add_child
		add_child(COVER_NODE)
		COVER_NODE.ID=SetA[i]
		COVER_NODE.loadIllustration(SetA[i])
		G.append(COVER_NODE)
		get_viewport().get_node("COLLECTION/TOP_MENU/SET_SELECT").set_TXT_SET()
		i+=1
	# 6.5 (quantos sets cabem na tela); 300 tamanho medio do set
	var QtdSetpTela=960*2/TamSet # média 6.5
	var Tam = 960+(SetA.size()-QtdSetpTela)*TamSet
	$CS2D.polygon=PoolVector2Array([Vector2(-960,-250),Vector2(-960,250),Vector2(Tam,250),Vector2(Tam,-250)])
	while SetA.size()<30: # espaço reservado para qaundo houver novos sets
		SetA.append("SET")
	set_process(true)



func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		set_process(true)
		a_off=false
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position.x = get_global_mouse_position()[0] + grabbed_offset[0]
	else:
		a_off=true
	if G[0].global_position.x>(1920-250)/2:
		position.x -=2500*delta
	elif G[G.size()-1].global_position.x<(1920-250)/2:
		position.x +=2500*delta
	elif a_off:
		set_process(false)

func GO2SET(ID):
	var i = 0
	while i<G.size():
		if (SetA[i]==ID):
			Tw.interpolate_property(G[i],"position:y", G[i].position[1], G[i].position[1]+2500, 1, Tween.TRANS_SINE, Tween.EASE_OUT)
			get_parent().get_node("Timer").connect("timeout",self,"call_set",[ID])
			get_parent().get_node("Timer").start()
		else:
			Tw.interpolate_property(G[i],"position:y", G[i].position[1], G[i].position[1]-2500, 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		Tw.start()
		G[i].set_process(false)
		i+=1

func call_set(which_set):
	if String(which_set) == "SET":
		which_set=false
		get_viewport().get_node("COLLECTION/TOP_MENU/SET_SELECT").SET_TXT="All Sets"
	else:
		get_viewport().get_node("COLLECTION/TOP_MENU/SET_SELECT").SET_TXT=which_set
	get_parent().get_node("Timer").stop()
	get_parent().get_node("Timer").disconnect("timeout",self,"call_set")
	SET.modulate=Color(1,1,1,0)
	Tw.interpolate_property(SET,"modulate", SET.modulate, Color(1,1,1,1), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	SET.visible=true
	visible=false
	if is_instance_valid(get_viewport().get_node("COLLECTION/FileDialog")): # é pro EXPORT/IMPORT nao aparecer depois de selecionar o SET
		get_parent().get_node("FileDialog").visible=false
#	GLOBAL.CustomFilter=[WT,f,f,f,which_set,f,f,f,f,f,f,f,f,f,f,f,f]
	var i = 0
	while i < GLOBAL.CustomFilter.size():
		GLOBAL.CustomFilter[i]=false
		i+=1
	GLOBAL.CustomFilter[0]=WT
	GLOBAL.CustomFilter[4]=which_set
	var novaPool = GLOBAL.FILTER(GLOBAL.CustomFilter)
	get_parent().get_node("SET/CARDS_DISPLAY").update_cards(novaPool,0) #abre pagina 0
	get_viewport().get_node("COLLECTION/TOP_MENU/SET_SELECT").begin()
