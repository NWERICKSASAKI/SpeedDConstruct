extends Node2D

var TOP_pos = 0
var BOT_pos = 786

var LV_r = Vector2(0,12)
var ATK_r #= Vector2(0,4500)
var DEF_r #= Vector2(0,3800)
var LIMIT_r = Vector2(0,4)
var QTD_r = Vector2(0,99)
var FAV_r = Vector2(0,9)

var currentLV = Vector2(0,12)
var currentATK #= Vector2(0,4500)
var currentDEF #= Vector2(0,3800)
var currentLIMIT = Vector2(0,4)
var currentQTD = Vector2(0,10)
var currentFAV = Vector2(0,9)

var b # botão do slider selecionado
var w # which one?  top or bot? (1 or -1)
var r # range # ATK 0 < 4500 # LV  1 < 12 
var s #step
var SearchTheme = ""
var t = 0.5 # tempo de animação TWEEN

var topNum
var botNum

const B = 786
onready var GLOBAL = get_viewport().get_node("/root/GLOBAL")

func _ready():
	visible=false
	set_process(false)
	$TOP.connect("pressed",self,"PRESSED",[$TOP])
	$BOT.connect("pressed",self,"PRESSED",[$BOT])
	currentATK = Vector2(0,GLOBAL.MAX_ATK)
	currentDEF = Vector2(0,GLOBAL.MAX_DEF)

func _enter(SORT):
	ATK_r = Vector2(0,GLOBAL.MAX_ATK)
	DEF_r = Vector2(0,GLOBAL.MAX_DEF)
	print("SLIDER/_enter(SORT) | SORT = ",SORT)
	var LOWER
	var UPPER
	w=0
	visible=true
	SearchTheme=SORT
	match SORT:
		"LV":
			r = 12
			LOWER = currentLV[1]/r*B
			UPPER = currentLV[0]/r*B
		"ATK":
			r = GLOBAL.MAX_ATK
			LOWER = currentATK[1]/r*B
			UPPER = currentATK[0]/r*B
		"DEF":
			r = GLOBAL.MAX_DEF
			LOWER = currentDEF[1]/r*B
			UPPER = currentDEF[0]/r*B
		"LIMIT":
			r = 4 # 0 (Forbidden), 1, 2, 3, 4  (Unlimited)
			LOWER = currentLIMIT[1]/r*B
			UPPER = currentLIMIT[0]/r*B
		"QTD":
			r = 10 # 0 a 9 e tambem um "+9"
			if currentQTD[1]>=10:
				currentQTD[1]=10
			if currentQTD[0]>=10:
				currentQTD[0]=10
			LOWER = currentQTD[1]/r*B
			UPPER = currentQTD[0]/r*B
		"FAV":
			r = 9 # 0 a 9
			LOWER = currentFAV[1]/r*B
			UPPER = currentFAV[0]/r*B
	TOP_pos = UPPER
	BOT_pos = LOWER
	$TXT_BOT.text = String(r)
	if r > 50:
		s = 100
	else:
		s = 0.10 # isso é pro LV min 7 e max 7
	$Tween.interpolate_property($TOP,"position:y", 0, UPPER, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($TXT_TOP,"rect_position:y", 0, UPPER, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($BOT,"position:y", 35, LOWER, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($TXT_BOT,"rect_position:y", 35, LOWER, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($SELECTED,"scale:y", 0, 1, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
#
	$Tween.interpolate_property(self,"modulate", self.modulate, Color(1,1,1,1), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
	set_process(true)

func PRESSED(e): # quando aperta uma das setas dos range
	print("SLIDER / PRESSED(e)")
#	$TOP.discoonect("pressed",self,"PRESSED")
#	$BOT.disconnect("pressed",self,"PRESSED")
	e.connect("released",self,"RELEASED",[e])
	set_process(true)
	b = e
	if e == $TOP:
		w = 1
	elif e == $BOT:
		w = -1

func _process(_delta):
	if w==0:
		botNum=int(($BOT.position[1])/B*r)
		topNum=int(($TOP.position[1])/B*r)
		$TXT_BOT.text=String(botNum)
		$TXT_TOP.text=String(topNum)
		if SearchTheme=="LIMIT":
			match topNum:
				0:
					$TXT_TOP.text="Forbidden"
				1:
					$TXT_TOP.text="Limit 1"
				2:
					$TXT_TOP.text="Limit 2"
				3:
					$TXT_TOP.text="Limit 3"
				4:
					$TXT_TOP.text="Unlimited"
			match botNum:
				0:
					$TXT_BOT.text="Forbidden"
				1:
					$TXT_BOT.text="Limit 1"
				2:
					$TXT_BOT.text="Limit 2"
				3:
					$TXT_BOT.text="Limit 3"
				4:
					$TXT_BOT.text="Unlimited"
		elif SearchTheme=="QTD":
			if  topNum>=10:
				$TXT_TOP.text="9+"
			if  botNum>=10:
				$TXT_BOT.text="9+"
	else:
		b.position.y = get_local_mouse_position()[1]
	match w:
		1:
			if b.position.y<0:
				b.position.y = 0
			elif b.position.y>B:
				b.position.y=B
			TOP_pos = b.position.y
			$TXT_TOP.rect_position.y= b.position[1]
			topNum=int(int((b.position[1])/B*r/s)*s) # o 2° int é pro LV min 7 e max 7
			$TXT_TOP.text=String(topNum)
			if SearchTheme=="LIMIT":
				match topNum:
					0:
						$TXT_TOP.text="Forbidden"
					1:
						$TXT_TOP.text="Limit 1"
					2:
						$TXT_TOP.text="Limit 2"
					3:
						$TXT_TOP.text="Limit 3"
					4:
						$TXT_TOP.text="Unlimited"
			elif SearchTheme=="QTD":
				if  topNum>=10:
					$TXT_TOP.text="9+"
					topNum=99
				if  botNum>=10:
					$TXT_BOT.text="9+"
					botNum=99
		-1:
			if b.position.y<0:
				b.position.y = 0
			elif b.position.y>B:
				b.position.y=B
			BOT_pos = b.position.y
			$TXT_BOT.rect_position.y=b.position[1]
			botNum=int(int((b.position[1])/B*r/s)*s) # o 2° int é pro LV min 7 e max 7
			$TXT_BOT.text=String(botNum)
			if SearchTheme=="LIMIT":
				match botNum:
					0:
						$TXT_BOT.text="Forbidden"
					1:
						$TXT_BOT.text="Limit 1"
					2:
						$TXT_BOT.text="Limit 2"
					3:
						$TXT_BOT.text="Limit 3"
					4:
						$TXT_BOT.text="Unlimited"
			elif SearchTheme=="QTD":
				if  topNum>=10:
					$TXT_TOP.text="9+"
					topNum=99
				if  botNum>=10:
					$TXT_BOT.text="9+"
					botNum=99
	$SELECTED.position.y = $TOP.position.y
	$SELECTED.scale.y = ($BOT.position.y-$TOP.position.y)/B

func RELEASED(e):
	e.disconnect("released",self,"RELEASED")
#	close()
	#retornar resposta pro get_parent()
	var C 
	var MAX = botNum
	var MIN = topNum
	var Vect = Vector2(MIN,MAX)
	if(Vect[1]<Vect[0]):
		Vect = Vector2(MAX,MIN)
	print(Vect)
	match SearchTheme:
		"LV":
			currentLV = Vect
			if LV_r == Vect:
				Vect = false
			C = 13
		"ATK":
			currentATK = Vect
			if ATK_r == Vect:
				Vect = false
			C = 14
		"DEF":
			currentDEF = Vect
			if DEF_r == Vect:
				Vect = false
			C = 15
		"LIMIT":
			currentLIMIT = Vect
			if LIMIT_r == Vect:
				Vect = false
			C = 19
		"QTD":
			currentQTD = Vect
			if QTD_r == Vect:
				Vect = false
			C = 3
		"FAV":
			currentFAV = Vect
			if FAV_r == Vect:
				Vect = false
			C = 18
	print("SLIDER / RELEASED(e) / get_parent().CustomSearch(C,Vect) - - (C,Vect) = (",String(C)," , ",String(Vect))
	get_parent().CustomSearch(C,Vect)

func close():
	b = null
	print("SLIDER / close()")
	set_process(false)
#	if visible:
#		$TOP.disconnect("pressed",self,"PRESSED")
#		$BOT.disconnect("pressed",self,"PRESSED")
	#animação de fechar tudo
	$Tween.interpolate_property($BOT,"position:y", $BOT.position.y, 35, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($TXT_BOT,"rect_position:y",$TXT_BOT.rect_position.y, 35, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($SELECTED,"scale:y", 1, 0, t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
#
	$Tween.interpolate_property(self,"modulate", self.modulate, Color(1,1,1,0), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
