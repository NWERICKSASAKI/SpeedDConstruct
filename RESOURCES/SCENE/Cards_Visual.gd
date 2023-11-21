extends Node2D

onready var GLOBAL=get_viewport().get_node("/root/GLOBAL")
onready var myConfs = GLOBAL.myConfs

onready var CB=[$CB_Grayscale,$CB_ShowNumber,$CB_DescSelection,$CB_SRUR_Particles,$CB_ShowDiference,$CB_KeepText,$CB_NameDate,$TXT_NAME]
onready var Tw=get_viewport().get_node("CONF/Tween")
onready var DATABASE=GLOBAL.DATABASE

func _ready():
	var i = 0
	$SampleCARD/Card_Manual.loadData(DATABASE[DATABASE.size()-1])
	while i<CB.size():
		if i==7:
			$TXT_NAME.connect("text_changed",self,"RENAME")
			$TXT_NAME.connect("focus_entered",self,"FOCUS_ON",[1])
			$TXT_NAME.connect("focus_exited",self,"FOCUS_ON",[0])
			if myConfs[7] is int or myConfs[7]=="":
				$TXT_NAME.text = "User123"
			else:
				$TXT_NAME.text=myConfs[7]
		else:
			CB[i].connect("pressed",self,"pressed_b",[i])
			CB[i].pressed=myConfs[i]
		CB[i].modulate=Color(1,1,1,0)
		Tw.interpolate_property(CB[i],"rect_position:x", CB[i].rect_position[0]+1500*(i+1), CB[i].rect_position[0], 0.5+i*0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		Tw.start()
		Tw.interpolate_property(CB[i],"modulate", Color(1,1,1,-(i+1)), Color(1,1,1,1), 1+i*0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		Tw.start()
		i+=1
	updateSampleCard()

func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position):
		$TXT_NAME.release_focus()

func _is_pos_in(checkpos:Vector2):
	var gr=$TXT_NAME.get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y

func RENAME():
	myConfs[7]=$TXT_NAME.text
	GLOBAL._save_conf()

func pressed_b(b):
	myConfs[b]=int(CB[b].pressed)
	GLOBAL._save_conf()
	updateSampleCard()

func updateSampleCard():
	$SampleCARD/Card_Manual.rainbow(true)
	$SampleCARD/Card_Manual.grayscale(myConfs[0])
	$SampleCARD/TXT.visible=(myConfs[1])
	$SampleCARD/Card_Manual/DESC.selection_enabled=(myConfs[2])
	$SampleCARD/PARTICLE.visible=(myConfs[3])
	if myConfs[4]:
		$SampleCARD/TXT.bbcode_text="[center]+3"
	else:
		$SampleCARD/TXT.bbcode_text="[center]0"
	$TXT_NAME.visible=(myConfs[6])

func FOCUS_ON(n):
	if(bool(myConfs[5])==false):
		$TXT_NAME.text=""
	match n:
		1:
			print("focus on")
			set_process(true)
		0:
			print("focus off")
			set_process(false)
			get_viewport().get_node("CONF").position.y=0

func _process(_delta):
	pass
#	get_viewport().get_node("CONF").position.y=-OS.get_virtual_keyboard_height()

