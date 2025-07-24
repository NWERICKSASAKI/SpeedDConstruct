extends Node2D

onready var GLOBAL = get_node("/root/GLOBAL")
onready var Tw = get_viewport().get_node("COLLECTION/Tween")
onready var Ti = get_viewport().get_node("COLLECTION/Timer")
onready var AA = get_viewport().get_node("COLLECTION/AA")
var t = 0.25 #tempo da animação de escurecer 


var SET_TXT="Which Set?"
var CARD1_TXT="Which Card?"
var CARD1_type = 0
var CARD2_TXT="Which Card?"
var TYPE1_TXT="Which Type?"
var TYPE2_TXT="Which Type?"
var ATTRIB_TXT="Which?"
var ATK_TXT="ATK"
var DEF_TXT="DEF"
var LV_TXT="LV"
var RARITY_TXT="Rarity"
var LIMIT_TXT="Limits"
var FAV_TXT="Fav"
var QTD_TXT="Qtd"

var SetArray = []
var CARD2_monster = ["Normal","Effect","Fusion","Ritual","Token"]
var CARD2_spell = ["Normal","Continuous","Field","Ritual","Quick-Play","Equip"]
var CARD2_trap = ["Normal","Continuous","Counter"]
var CARD2_skill = ["Normal","Continuous","Field"]
onready var CARD2_options = [CARD2_monster,CARD2_spell,CARD2_trap,CARD2_skill]

var Type1ArrayMonster = []
var Type2Array = []
var TYPE1MONSTER_TXT = ""
var TYPE1MONSTER_TXTa = ""
var TYPE1MONSTER_TXTb = ""
var TYPE1MONSTER_TXTc = ""
var Type1ArraySkill = []
var TYPE1SKILL_TXT = ""
var TYPE1SKILL_TXTa = ""
var TYPE1SKILL_TXTb = ""
var TYPE1SKILL_TXTc = ""
var TYPE1SKILL_TXTd = ""
var TYPE1SKILL_TXTe = ""
var TYPE1Array = [[],[],[],[]]
var TYPE2MONSTER_TXT = ""
var ALLATTRIB_TXT = ""
var ALLRARITY = "\nSHOW ALL \nCommon \nSuper Rare \nUltra Rare \nSecret Rare \nPrismatic Secret Rare"

var AttribArray = []

var beforePressedTXT = []
var beforePressedvisible = []
var beforePressedmodulate = []

const H = 64 # tamanho da linha dos dropdown menu


func _ready():
	SetArray = get_viewport().get_node("COLLECTION/AA").SetA
	ScanArrayOptions()
	Ti.wait_time=t
#
	$TXT_SET.modulate = Color(1,1,1,1)
	$TXT_CARD1.modulate = Color(1,1,1,0.75)
	$TXT_CARD2.modulate = Color(1,1,1,0.5)
	$TXT_TYPE1.modulate = Color(1,1,1,0.5)
	$TXT_TYPE2.modulate = Color(1,1,1,0.5)
	$TXT_ATTRIB.modulate = Color(1,1,1,0.5)
	$TXT_ATK.modulate = Color(1,1,1,0.5)
	$TXT_DEF.modulate = Color(1,1,1,0.5)
	$TXT_LV.modulate = Color(1,1,1,0.5)
	$TXT_RARITY.modulate = Color(1,1,1,0.5)
	$TXT_LIMIT.modulate = Color(1,1,1,0.5)
	$TXT_FAV.modulate = Color(1,1,1,0.5)
	$TXT_QTD.modulate = Color(1,1,1,0.5)
#
	connected_buttons(true)
#
	begin()

func connected_buttons(ToF):
	if ToF:
		$TXT_SET/BUTTON.connect("released",self,"showSet",["SET"])
		$TXT_CARD1/BUTTON.connect("released",self,"showSet",["CARD1"])
		$TXT_CARD2/BUTTON.connect("released",self,"showSet",["CARD2"])
		$TXT_TYPE1/BUTTON.connect("released",self,"showSet",["TYPE1"])
		$TXT_TYPE2/BUTTON.connect("released",self,"showSet",["TYPE2"])
		$TXT_ATTRIB/BUTTON.connect("released",self,"showSet",["ATTRIB"])
		$TXT_ATK/BUTTON.connect("released",self,"showSet",["ATK"])
		$TXT_DEF/BUTTON.connect("released",self,"showSet",["DEF"])
		$TXT_LV/BUTTON.connect("released",self,"showSet",["LV"])
		$TXT_RARITY/BUTTON.connect("released",self,"showSet",["RARITY"])
		$TXT_LIMIT/BUTTON.connect("released",self,"showSet",["LIMIT"])
		$TXT_FAV/BUTTON.connect("released",self,"showSet",["FAV"])
		$TXT_QTD/BUTTON.connect("released",self,"showSet",["QTD"])
		$THE_BUTTON.connect("released",self,"pickedSet")
		$SEARCHER.operante=true
	else:
		$TXT_SET/BUTTON.disconnect("released",self,"showSet")
		$TXT_CARD1/BUTTON.disconnect("released",self,"showSet")
		$TXT_CARD2/BUTTON.disconnect("released",self,"showSet")
		$TXT_TYPE1/BUTTON.disconnect("released",self,"showSet")
		$TXT_TYPE2/BUTTON.disconnect("released",self,"showSet")
		$TXT_ATTRIB/BUTTON.disconnect("released",self,"showSet")
		$TXT_ATK/BUTTON.disconnect("released",self,"showSet")
		$TXT_DEF/BUTTON.disconnect("released",self,"showSet")
		$TXT_LV/BUTTON.disconnect("released",self,"showSet")
		$TXT_RARITY/BUTTON.disconnect("released",self,"showSet")
		$TXT_LIMIT/BUTTON.disconnect("released",self,"showSet")
		$TXT_FAV/BUTTON.disconnect("released",self,"showSet")
		$TXT_QTD/BUTTON.disconnect("released",self,"showSet")
		$THE_BUTTON.disconnect("released",self,"pickedSet")
		#$SEARCHER.visible=false # migrado pro ShowSet()
#

func ScanArrayOptions(): #Monster Type / Skills
	var f = false
	#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18    19
	# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG,LIMIT]
	
	#var F = [f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f]
	var F = [f]
	while F.size()!=20:
		F.append(f)
	F[8] = "Monster"
	var newArray = GLOBAL.FILTER(F)
	var i=0
	var j=0
	while i<newArray.size():
		var repetidoType1 = false
		var repetidoType2 = false
		j=0
		while j<Type1ArrayMonster.size():
			if newArray[i][10] == Type1ArrayMonster[j]:
				repetidoType1=true
			j+=1
		j=0
		while j<Type2Array.size():
			if newArray[i][11] == Type2Array[j]:
				repetidoType2=true
			j+=1
		if repetidoType1 == false:
			Type1ArrayMonster.append(newArray[i][10])
		if repetidoType2 == false:
			Type2Array.append(newArray[i][11])
		i+=1
	
	
#	while TYPE1Array.size()<52:
#		TYPE1Array.append(false)
	#i = 0
	Type1ArrayMonster.sort()
	TYPE1MONSTER_TXT = "\n\nSHOW ALL"
	TYPE1MONSTER_TXTa="\n\n"
	TYPE1MONSTER_TXTb="\n\n"
	TYPE1MONSTER_TXTc="\n\n"
	i=0
	while i<Type1ArrayMonster.size():
		if i<=(1*13-1):
			TYPE1MONSTER_TXT=TYPE1MONSTER_TXT+"\n"+Type1ArrayMonster[i] 
		elif i<=(2*13-1):
			TYPE1MONSTER_TXTa=TYPE1MONSTER_TXTa+"\n"+Type1ArrayMonster[i] 
		elif i<=(3*13-1):
			TYPE1MONSTER_TXTb=TYPE1MONSTER_TXTb+"\n"+Type1ArrayMonster[i] 
		elif i<=(4*13-1):
			TYPE1MONSTER_TXTc=TYPE1MONSTER_TXTc+"\n"+Type1ArrayMonster[i] 
		i+=1
	#
	Type2Array.sort()
	TYPE2MONSTER_TXT = "\n\nSHOW ALL"
	i=0
	while i<Type2Array.size():
		TYPE2MONSTER_TXT=TYPE2MONSTER_TXT+"\n"+Type2Array[i] 
		i+=1
	while Type2Array.size()<10:
		Type2Array.append(false)
	#
	i=0
	j=0
	while i<newArray.size():
		var repetido = false
		j=0
		while j<AttribArray.size():
			if newArray[i][12] == AttribArray[j]:
				repetido=true
			j+=1
		if repetido == false:
			AttribArray.append(newArray[i][12])
		i+=1
	#
	i = 0
	ALLATTRIB_TXT = "\n\nSHOW ALL\n"
	while i<AttribArray.size():
		ALLATTRIB_TXT = ALLATTRIB_TXT + AttribArray[i] +"\n"
		i+=1
	while AttribArray.size()<20:
		AttribArray.append(false)
	
#	F = [f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f]
	F[8] = "Skill"
	newArray = GLOBAL.FILTER(F)
	i=0
	j=0
	while i<newArray.size():
		var repetido = false
		j=0
		while j<Type1ArraySkill.size():
			if newArray[i][10] == Type1ArraySkill[j]:
				repetido=true
			j+=1
		if repetido == false:
			Type1ArraySkill.append(newArray[i][10])
		i+=1
	#
	Type1ArraySkill.sort()
	TYPE1SKILL_TXT = "\n\nSHOW ALL"
	TYPE1SKILL_TXTa="\n\n"
	TYPE1SKILL_TXTb="\n\n"
	TYPE1SKILL_TXTc="\n\n"
	TYPE1SKILL_TXTd="\n\n"
	TYPE1SKILL_TXTe="\n\n"
	i=0
	while i<Type1ArraySkill.size():
		if i<=(1*13-1):
			TYPE1SKILL_TXT=TYPE1SKILL_TXT+"\n"+Type1ArraySkill[i] 
		elif i<=(2*13-1):
			TYPE1SKILL_TXTa=TYPE1SKILL_TXTa+"\n"+Type1ArraySkill[i] 
		elif i<=(3*13-1):
			TYPE1SKILL_TXTb=TYPE1SKILL_TXTb+"\n"+Type1ArraySkill[i] 
		elif i<=(4*13-1):
			TYPE1SKILL_TXTc=TYPE1SKILL_TXTc+"\n"+Type1ArraySkill[i] 
		elif i<=(5*13-1):
			TYPE1SKILL_TXTd=TYPE1SKILL_TXTd+"\n"+Type1ArraySkill[i] 
		elif i<=(6*13-1):
			TYPE1SKILL_TXTe=TYPE1SKILL_TXTe+"\n"+Type1ArraySkill[i] 
		i+=1
	TYPE1Array [0] = Type1ArrayMonster
	TYPE1Array [3] = Type1ArraySkill
#
	while Type1ArrayMonster.size()<51:
		Type1ArrayMonster.append(false)
	while Type1ArraySkill.size()<51:
		Type1ArraySkill.append(false)


func set_TXT_SET(): #chamado por fora
	SetArray = get_viewport().get_node("COLLECTION/AA").SetA
	var i = 1
	$THE_BUTTON/TXT_ALLSETS.text = "\nSHOW ALL\n"
	while i<SetArray.size():
		$THE_BUTTON/TXT_ALLSETS.text =$THE_BUTTON/TXT_ALLSETS.text+SetArray[i]
		if i%2==0:
			$THE_BUTTON/TXT_ALLSETS.text=$THE_BUTTON/TXT_ALLSETS.text+"\n"
		else:
			$THE_BUTTON/TXT_ALLSETS.text=$THE_BUTTON/TXT_ALLSETS.text+"\t"
		i+=1

func begin():
	print("COLLECTION/SET_SELECT/begin")
	
	visible=true
	$TXT_SET.visible=true
	$THE_BUTTON.visible=false
#
	$TXT_SET.text = SET_TXT
	$TXT_CARD1.text = CARD1_TXT
	$TXT_CARD2.text = CARD2_TXT
	$TXT_TYPE1.text = TYPE1_TXT
	$TXT_TYPE2.text = TYPE2_TXT
	$TXT_ATTRIB.text = ATTRIB_TXT
	$TXT_ATK.text = ATK_TXT
	$TXT_DEF.text = DEF_TXT
	$TXT_LV.text = LV_TXT
	$TXT_RARITY.text = RARITY_TXT
	$TXT_LIMIT.text = LIMIT_TXT
	$TXT_FAV.text = FAV_TXT
	$TXT_QTD.text = QTD_TXT
#
	$TXT_TYPE1.visible=false
	$TXT_TYPE2.visible=false
	$TXT_ATTRIB.visible=false
	$TXT_ATK.visible=false
	$TXT_DEF.visible=false
	$TXT_LV.visible=false
	$TXT_RARITY.visible=false
	$TXT_LIMIT.visible=false
	$TXT_FAV.visible=false
	$TXT_QTD.visible=false
#
	$TXT_RARITY.modulate = Color(1,1,1,0.5)
	$TXT_LIMIT.modulate = Color(1,1,1,0.5)
	$TXT_FAV.modulate = Color(1,1,1,0.5)
	$TXT_QTD.modulate = Color(1,1,1,0.5)
#
	if SET_TXT == "Which Set?":
			$TXT_CARD1.visible=false
			$TXT_CARD2.visible=false
	else:
			$SEARCHER.visible=true
			$TXT_CARD1.visible=true
			$TXT_CARD2.visible=true
			$TXT_RARITY.visible=true
			$TXT_LIMIT.visible=true
			$TXT_FAV.visible=true
			$TXT_QTD.visible=true
	match CARD1_TXT:
		"Monster":
			CARD1_type=0
			$THE_BUTTON/TXT_ALLCARD2.text ="\nAll Cards\nNormal\nEffect\nFusion\nRitual\nToken"
			$THE_BUTTON/TXT_ALLTYPE2.text =TYPE2MONSTER_TXT
			$TXT_TYPE1.visible=true
			$TXT_TYPE2.visible=true
			$TXT_ATTRIB.visible=true
			$TXT_ATK.visible=true
			$TXT_DEF.visible=true
			$TXT_LV.visible=true
		"Spell":
			CARD1_type=1
			$THE_BUTTON/TXT_ALLCARD2.text ="\nAll Cards\nNormal\nContinuous\nField\nRitual\nQuick-Play\nEquip"
		"Trap":
			CARD1_type=2
			$THE_BUTTON/TXT_ALLCARD2.text ="\nAll Cards\nNormal\nContinuous\nCounter"
		"Skill":
			CARD1_type=3
			$THE_BUTTON/TXT_ALLCARD2.text ="\nAll Cards\nNormal\nContinuous\nField"
			$TXT_TYPE1.visible=true
		_:
			$TXT_CARD2.visible=false
#

func showSet(WHICH): #apertado algum botao de filtro
	print("COLLENCTION / SET_SELECT / showSet(" ,WHICH," )")
#
	$THE_BUTTON/TXT_ALLSETS.visible=false
	$THE_BUTTON/TXT_ALLCARD1.visible=false
	$THE_BUTTON/TXT_ALLCARD2.visible=false
	$THE_BUTTON/TXT_ALLTYPE1.visible=false
	$THE_BUTTON/TXT_ALLTYPE1a.visible=false
	$THE_BUTTON/TXT_ALLTYPE1b.visible=false
	$THE_BUTTON/TXT_ALLTYPE1c.visible=false
	$THE_BUTTON/TXT_ALLTYPE1d.visible=false
	$THE_BUTTON/TXT_ALLTYPE1e.visible=false
	$THE_BUTTON/TXT_ALLTYPE2.visible=false
	$THE_BUTTON/TXT_ALLATTRIB.visible=false
	$THE_BUTTON/TXT_ALLRARITY.visible=false
#
	$SEARCHER.operante=false
#
	beforePressedTXT=[$TXT_SET.text,$TXT_CARD1.text,$TXT_CARD2.text,$TXT_TYPE1.text,$TXT_TYPE2.text,$TXT_ATTRIB.text,$TXT_ATK.text,$TXT_DEF.text,$TXT_LV.text,$TXT_RARITY.text,$TXT_LIMIT.text,$TXT_FAV.text,$TXT_QTD.text]
	beforePressedvisible=[$TXT_SET.visible,$TXT_CARD1.visible,$TXT_CARD2.visible,$TXT_TYPE1.visible,$TXT_TYPE2.visible,$TXT_ATTRIB.visible,$TXT_ATK.visible,$TXT_DEF.visible,$TXT_LV.visible,$TXT_RARITY.visible,$TXT_LIMIT.visible,$TXT_FAV.visible,$TXT_QTD.visible]
#
	beforePressedmodulate=[$TXT_SET.modulate,$TXT_CARD1.modulate,$TXT_CARD2.modulate,$TXT_TYPE1.modulate,$TXT_TYPE2.modulate,$TXT_ATTRIB.modulate,$TXT_ATK.modulate,$TXT_DEF.modulate,$TXT_LV.modulate,$TXT_RARITY.modulate,$TXT_LIMIT.modulate,$TXT_FAV.modulate,$TXT_QTD.modulate]
#
	$TXT_SET.modulate = Color(1,1,1,0.25)
	$TXT_CARD1.modulate = Color(1,1,1,0.25)
	$TXT_CARD2.modulate = Color(1,1,1,0.25)
	$TXT_TYPE1.modulate = Color(1,1,1,0.25)
	$TXT_TYPE2.modulate = Color(1,1,1,0.25)
	$TXT_ATTRIB.modulate = Color(1,1,1,0.25)
	$TXT_ATK.modulate = Color(1,1,1,0.25)
	$TXT_DEF.modulate = Color(1,1,1,0.25)
	$TXT_LV.modulate = Color(1,1,1,0.25)
	$TXT_RARITY.modulate = Color(1,1,1,0.25)
	$TXT_LIMIT.modulate = Color(1,1,1,0.25)
	$TXT_FAV.modulate = Color(1,1,1,0.25)
	$TXT_QTD.modulate = Color(1,1,1,0.25)
#
	match WHICH:
		"SET":
			$TXT_SET.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLSETS.visible=true
			$TXT_SET.text="Which Set?"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLSETS"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLSETS").text.length(), 4*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
		"CARD1":
			$TXT_CARD1.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLCARD1.visible=true
			$TXT_CARD1.text="Which Card?"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLCARD1"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLCARD1").text.length(), 2*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			#
			$TXT_CARD2.visible=false
			CARD2_TXT = "Which Card?"
			$TXT_CARD2.modulate = Color(1,1,1,0.5)
			$TXT_TYPE1.visible=false
			TYPE1_TXT = "Which Type?"
			$TXT_TYPE1.modulate = Color(1,1,1,0.5)
			$TXT_TYPE2.visible=false
			TYPE2_TXT = "Which Type?"
			$TXT_TYPE2.modulate = Color(1,1,1,0.5)
			$TXT_ATTRIB.visible=false
			ATTRIB_TXT = "Attribute?"
			$TXT_ATTRIB.modulate = Color(1,1,1,0.5)
			$TXT_ATK.visible=false
			$TXT_ATK.modulate = Color(1,1,1,0.5)
			$TXT_DEF.visible=false
			$TXT_DEF.modulate = Color(1,1,1,0.5)
			$TXT_LV.visible=false
			$TXT_LV.modulate = Color(1,1,1,0.5)
			GLOBAL.CustomFilter[12]=false
			GLOBAL.CustomFilter[13]=false
			GLOBAL.CustomFilter[14]=false
#			$SLIDER.currentATK=Vector2(0,GLOBAL.MAX_ATK)
#			$SLIDER.currentDEF=Vector2(0,GLOBAL.MAX_DEF)
#			$SLIDER.currentLV=Vector2(0,12)
			#
		"CARD2":
			$TXT_CARD2.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLCARD2.visible=true
			$TXT_CARD2.text="Which Card?"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLCARD2"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLCARD2").text.length(), 2*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			$TXT_TYPE2.visible=false
		"TYPE1":
			$TXT_TYPE1.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLTYPE1.visible=true
			$THE_BUTTON/TXT_ALLTYPE1a.visible=true
			$THE_BUTTON/TXT_ALLTYPE1b.visible=true
			$THE_BUTTON/TXT_ALLTYPE1c.visible=true
			$THE_BUTTON/TXT_ALLTYPE1d.visible=true
			$THE_BUTTON/TXT_ALLTYPE1e.visible=true
			$TXT_TYPE1.text="Which Type?"
			if CARD1_TXT=="Monster":
				$THE_BUTTON/TXT_ALLTYPE1.text = TYPE1MONSTER_TXT
				$THE_BUTTON/TXT_ALLTYPE1a.text = TYPE1MONSTER_TXTa
				$THE_BUTTON/TXT_ALLTYPE1b.text = TYPE1MONSTER_TXTb
				$THE_BUTTON/TXT_ALLTYPE1c.text = TYPE1MONSTER_TXTc
				$THE_BUTTON/TXT_ALLTYPE1d.text = ""
				$THE_BUTTON/TXT_ALLTYPE1e.text = ""
			elif CARD1_TXT=="Skill":
				$THE_BUTTON/TXT_ALLTYPE1.text = TYPE1SKILL_TXT
				$THE_BUTTON/TXT_ALLTYPE1a.text = TYPE1SKILL_TXTa
				$THE_BUTTON/TXT_ALLTYPE1b.text = TYPE1SKILL_TXTb
				$THE_BUTTON/TXT_ALLTYPE1c.text = TYPE1SKILL_TXTc
				$THE_BUTTON/TXT_ALLTYPE1d.text = TYPE1SKILL_TXTd
				$THE_BUTTON/TXT_ALLTYPE1e.text = TYPE1SKILL_TXTe
			else:
				$THE_BUTTON/TXT_ALLTYPE1.text = "\n\nDEU RUIM"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE1").text.length(), 2*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1a"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE1a").text.length(), 4*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1b"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE1b").text.length(), 6*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1c"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE1c").text.length(), 8*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1d"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE1d").text.length(), 10*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1e"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE1e").text.length(), 12*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()

		"TYPE2":
			$TXT_TYPE2.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLTYPE2.visible=true
			$TXT_TYPE2.text="Which Type?"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE2"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLTYPE2").text.length(), t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
		"ATTRIB":
			$TXT_ATTRIB.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLATTRIB.visible=true
			$THE_BUTTON/TXT_ALLATTRIB.text = ALLATTRIB_TXT
			$TXT_ATTRIB.text="Which?"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLATTRIB"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLATTRIB").text.length(), t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
		"ATK":
			$TXT_ATK.modulate = Color(1,1,1,0.75)
			$SLIDER._enter(WHICH)
			$SLIDER.position.x = $TXT_ATK.rect_position.x
		"DEF":
			$TXT_DEF.modulate = Color(1,1,1,0.75)
			$SLIDER._enter(WHICH)
			$SLIDER.position.x = $TXT_DEF.rect_position.x
		"LV":
			$TXT_LV.modulate = Color(1,1,1,0.75)
			$SLIDER._enter(WHICH)
			$SLIDER.position.x = $TXT_LV.rect_position.x
		"RARITY":
			$TXT_RARITY.modulate = Color(1,1,1,0.75)
			$THE_BUTTON/TXT_ALLRARITY.visible=true
#			$THE_BUTTON/TXT_ALLRARITY.text = TXT_ALLRARITY
			$TXT_ATTRIB.visible=false
			$TXT_RARITY.text="Which?"
			Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLRARITY"),"visible_characters", 0, get_node("THE_BUTTON/TXT_ALLRARITY").text.length(), t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			Tw.start()
		"LIMIT":
			$TXT_LIMIT.modulate = Color(1,1,1,0.75)
			$SLIDER._enter(WHICH)
			$SLIDER.position.x = $TXT_LIMIT.rect_position.x
		"FAV":
			$TXT_FAV.modulate = Color(1,1,1,0.75)
			$SLIDER._enter(WHICH)
			$SLIDER.position.x = $TXT_FAV.rect_position.x
		"QTD":
			$TXT_QTD.modulate = Color(1,1,1,0.75)
			$SLIDER._enter(WHICH)
			$SLIDER.position.x = $TXT_QTD.rect_position.x
	$THE_BUTTON.visible=true
#

	#Animação Escurecer o resto
	Tw.interpolate_property(get_viewport().get_node("COLLECTION/AA"),"modulate", Color(1,1,1,1), Color(1,1,1,0), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_viewport().get_node("COLLECTION/SET"),"modulate", Color(1,1,1,1), Color(1,1,1,0), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	Tw.start()
	
	Ti.stop()
	Ti.connect("timeout",self,"T1")
	Ti.start()

func T1():
	print("SET_SELECT/T1()")
	get_viewport().get_node("COLLECTION/SET/CARDS_DISPLAY").visible=false
	Ti.stop()
	Ti.disconnect("timeout",self,"T1")


func erase():
	print("SET_SELECT/erase()")
	$THE_BUTTON.visible=false
	connected_buttons(true)
#
	Ti.stop() # NÃO APAGA ESSE TRECO PELA MOR
	Ti.disconnect("timeout",self,"erase")


func pickedSet(): #algum btrão do dropdown foi selecionado
	get_viewport().get_node("COLLECTION/SET/CARDS_DISPLAY").visible=true
	var mouse_pos = get_local_mouse_position()
	print("SET_SELECT/pickedSet/mouse_pos"+String(mouse_pos))
#
	#Animação Escurecer o resto
	Tw.interpolate_property(get_viewport().get_node("COLLECTION/AA"),"modulate", Color(1,1,1,0), Color(1,1,1,1), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_viewport().get_node("COLLECTION/SET"),"modulate", Color(1,1,1,0), Color(1,1,1,1), t, Tween.TRANS_SINE, Tween.EASE_OUT)
	Tw.start()
	
	Ti.stop()
	Ti.connect("timeout",self,"erase")
	Ti.start() # pro eraser
	connected_buttons(false)
#
	$TXT_SET.text = beforePressedTXT[0]
	$TXT_CARD1.text = beforePressedTXT[1]
	$TXT_CARD2.text = beforePressedTXT[2]
	$TXT_TYPE1.text = beforePressedTXT[3]
	$TXT_TYPE2.text = beforePressedTXT[4]
	$TXT_ATTRIB.text = beforePressedTXT[5]
	$TXT_ATK.text = beforePressedTXT[6]
	$TXT_DEF.text = beforePressedTXT[7]
	$TXT_LV.text = beforePressedTXT[8]
	$TXT_RARITY.text = beforePressedTXT[9]
	$TXT_LIMIT.text = beforePressedTXT[10]
	$TXT_FAV.text = beforePressedTXT[11]
	$TXT_QTD.text = beforePressedTXT[12]
#
	$TXT_SET.visible = beforePressedvisible[0]
	$TXT_CARD1.visible = beforePressedvisible[1]
	$TXT_CARD2.visible = beforePressedvisible[2]
	$TXT_TYPE1.visible = beforePressedvisible[3]
	$TXT_TYPE2.visible = beforePressedvisible[4]
	$TXT_ATTRIB.visible = beforePressedvisible[5]
	$TXT_ATK.visible = beforePressedvisible[6]
	$TXT_DEF.visible = beforePressedvisible[7]
	$TXT_LV.visible = beforePressedvisible[8]
	$TXT_RARITY.visible = beforePressedvisible[9]
	$TXT_LIMIT.visible = beforePressedvisible[10]
	$TXT_FAV.visible = beforePressedvisible[11]
	$TXT_QTD.visible = beforePressedvisible[12]
#
	$TXT_SET.modulate = beforePressedmodulate[0]
	$TXT_CARD1.modulate = beforePressedmodulate[1]
	$TXT_CARD2.modulate = beforePressedmodulate[2]
	$TXT_TYPE1.modulate = beforePressedmodulate[3]
	$TXT_TYPE2.modulate = beforePressedmodulate[4]
	$TXT_ATTRIB.modulate = beforePressedmodulate[5]
	$TXT_ATK.modulate = beforePressedmodulate[6]
	$TXT_DEF.modulate = beforePressedmodulate[7]
	$TXT_LV.modulate = beforePressedmodulate[8]
	$TXT_RARITY.modulate = beforePressedmodulate[9]
	$TXT_LIMIT.modulate = beforePressedmodulate[10]
	$TXT_FAV.modulate = beforePressedmodulate[11]
	$TXT_QTD.modulate = beforePressedmodulate[12]
#
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLSETS"),"visible_characters", get_node("THE_BUTTON/TXT_ALLSETS").text.length(), 0, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLCARD1"),"visible_characters", get_node("THE_BUTTON/TXT_ALLCARD1").text.length(), 0, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLCARD2"),"visible_characters", get_node("THE_BUTTON/TXT_ALLCARD2").text.length(), 0, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE1").text.length(), 0, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1a"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE1a").text.length(), 0, 2*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1b"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE1b").text.length(), 0, 3*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1c"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE1c").text.length(), 0, 3*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1d"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE1d").text.length(), 0, 3*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE1e"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE1e").text.length(), 0, 3*t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLTYPE2"),"visible_characters", get_node("THE_BUTTON/TXT_ALLTYPE2").text.length(), 0, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	Tw.interpolate_property(get_node("THE_BUTTON/TXT_ALLATTRIB"),"visible_characters", get_node("THE_BUTTON/TXT_ALLATTRIB").text.length(), 0, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tw.start()
	if($SLIDER.visible):
		$SLIDER.close()

	if mouse_pos[0]<125 and $THE_BUTTON/TXT_ALLSETS.visible==true:
		if mouse_pos[1]<140-H:
			print("pass")
		elif mouse_pos[1]<140+0*H:
			CustomSearch(4,"SET")
		elif mouse_pos[1]<140+1*H:
			CustomSearch(4,SetArray[1])
		elif mouse_pos[1]<140+2*H:
			CustomSearch(4,SetArray[3])
		elif mouse_pos[1]<140+3*H:
			CustomSearch(4,SetArray[5])
		elif mouse_pos[1]<140+4*H:
			CustomSearch(4,SetArray[7])
		elif mouse_pos[1]<140+5*H:
			CustomSearch(4,SetArray[9])
		elif mouse_pos[1]<140+6*H:
			CustomSearch(4,SetArray[11])
		elif mouse_pos[1]<140+7*H:
			CustomSearch(4,SetArray[13])
		elif mouse_pos[1]<140+8*H:
			CustomSearch(4,SetArray[15])
		elif mouse_pos[1]<140+9*H:
			CustomSearch(4,SetArray[17])
		elif mouse_pos[1]<140+10*H:
			CustomSearch(4,SetArray[19])
		elif mouse_pos[1]<140+11*H:
			CustomSearch(4,SetArray[21])
		elif mouse_pos[1]<140+12*H:
			CustomSearch(4,SetArray[23])
		elif mouse_pos[1]<140+13*H:
			CustomSearch(4,SetArray[25])
		elif mouse_pos[1]<140+14*H:
			CustomSearch(4,SetArray[27])
		elif mouse_pos[1]<140+15*H:
			CustomSearch(4,SetArray[29])
	elif mouse_pos[0]<250 and $THE_BUTTON/TXT_ALLSETS.visible==true:
		if mouse_pos[1]<140-H:
			print("pass")
		elif mouse_pos[1]<140+0*H:
			CustomSearch(4,"SET")
		elif mouse_pos[1]<140+1*H:
			CustomSearch(4,SetArray[2])
		elif mouse_pos[1]<140+2*H:
			CustomSearch(4,SetArray[4])
		elif mouse_pos[1]<140+3*H:
			CustomSearch(4,SetArray[6])
		elif mouse_pos[1]<140+4*H:
			CustomSearch(4,SetArray[8])
		elif mouse_pos[1]<140+5*H:
			CustomSearch(4,SetArray[10])
		elif mouse_pos[1]<140+6*H:
			CustomSearch(4,SetArray[12])
		elif mouse_pos[1]<140+7*H:
			CustomSearch(4,SetArray[14])
		elif mouse_pos[1]<140+8*H:
			CustomSearch(4,SetArray[16])
		elif mouse_pos[1]<140+9*H:
			CustomSearch(4,SetArray[18])
		elif mouse_pos[1]<140+10*H:
			CustomSearch(4,SetArray[20])
		elif mouse_pos[1]<140+11*H:
			CustomSearch(4,SetArray[22])
		elif mouse_pos[1]<140+12*H:
			CustomSearch(4,SetArray[24])
		elif mouse_pos[1]<140+13*H:
			CustomSearch(4,SetArray[26])
		elif mouse_pos[1]<140+14*H:
			CustomSearch(4,SetArray[28])
		elif mouse_pos[1]<140+15*H:
			CustomSearch(4,SetArray[30])
	elif mouse_pos[0]<225 and $THE_BUTTON/TXT_ALLCARD1.visible==true:
			print("pass")
	elif mouse_pos[0]<455 and $THE_BUTTON/TXT_ALLCARD1.visible==true:
		if mouse_pos[1]<140-H:
			print("pass")
		elif mouse_pos[1]<140+0*H:
			CustomSearch(8,false)
		elif mouse_pos[1]<140+1*H:
			CustomSearch(8,"Monster")
		elif mouse_pos[1]<140+2*H:
			CustomSearch(8,"Spell")
		elif mouse_pos[1]<140+3*H:
			CustomSearch(8,"Trap")
		elif mouse_pos[1]<140+4*H:
			CustomSearch(8,"Skill")
	elif mouse_pos[0]<455 and $THE_BUTTON/TXT_ALLCARD2.visible==true:
		print("pass")
	elif mouse_pos[0]<700 and $THE_BUTTON/TXT_ALLCARD2.visible==true:
		if mouse_pos[1]<140-H:
			print("pass")
		elif mouse_pos[1]<140+H*0:
			CustomSearch(9,false)
		elif mouse_pos[1]<140+H*1:
			CustomSearch(9,CARD2_options[CARD1_type][0])
		elif mouse_pos[1]<140+H*2:
			CustomSearch(9,CARD2_options[CARD1_type][1])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(9,CARD2_options[CARD1_type][2])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(9,CARD2_options[CARD1_type][3])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(9,CARD2_options[CARD1_type][4])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(9,CARD2_options[CARD1_type][5])
	elif mouse_pos[0]<225 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		print("pass")
	elif mouse_pos[0]<515 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(10,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(10,TYPE1Array[CARD1_type][0])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(10,TYPE1Array[CARD1_type][1])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(10,TYPE1Array[CARD1_type][2])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(10,TYPE1Array[CARD1_type][3])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(10,TYPE1Array[CARD1_type][4])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(10,TYPE1Array[CARD1_type][5])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(10,TYPE1Array[CARD1_type][6])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(10,TYPE1Array[CARD1_type][7])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(10,TYPE1Array[CARD1_type][8])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(10,TYPE1Array[CARD1_type][9])
		elif mouse_pos[1]<140+H*12:
			CustomSearch(10,TYPE1Array[CARD1_type][10])
		elif mouse_pos[1]<140+H*13:
			CustomSearch(10,TYPE1Array[CARD1_type][11])
		elif mouse_pos[1]<140+H*14:
			CustomSearch(10,TYPE1Array[CARD1_type][12])
	elif mouse_pos[0]<805 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(10,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(10,TYPE1Array[CARD1_type][13])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(10,TYPE1Array[CARD1_type][14])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(10,TYPE1Array[CARD1_type][15])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(10,TYPE1Array[CARD1_type][16])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(10,TYPE1Array[CARD1_type][17])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(10,TYPE1Array[CARD1_type][18])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(10,TYPE1Array[CARD1_type][19])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(10,TYPE1Array[CARD1_type][20])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(10,TYPE1Array[CARD1_type][21])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(10,TYPE1Array[CARD1_type][22])
		elif mouse_pos[1]<140+H*12:
			CustomSearch(10,TYPE1Array[CARD1_type][23])
		elif mouse_pos[1]<140+H*13:
			CustomSearch(10,TYPE1Array[CARD1_type][24])
		elif mouse_pos[1]<140+H*14:
			CustomSearch(10,TYPE1Array[CARD1_type][25])
	elif mouse_pos[0]<1095 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(10,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(10,TYPE1Array[CARD1_type][26])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(10,TYPE1Array[CARD1_type][27])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(10,TYPE1Array[CARD1_type][28])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(10,TYPE1Array[CARD1_type][29])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(10,TYPE1Array[CARD1_type][30])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(10,TYPE1Array[CARD1_type][31])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(10,TYPE1Array[CARD1_type][32])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(10,TYPE1Array[CARD1_type][33])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(10,TYPE1Array[CARD1_type][34])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(10,TYPE1Array[CARD1_type][35])
		elif mouse_pos[1]<140+H*12:
			CustomSearch(10,TYPE1Array[CARD1_type][36])
		elif mouse_pos[1]<140+H*13:
			CustomSearch(10,TYPE1Array[CARD1_type][37])
		elif mouse_pos[1]<140+H*14:
			CustomSearch(10,TYPE1Array[CARD1_type][38])
	elif mouse_pos[0]<1385 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(10,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(10,TYPE1Array[CARD1_type][39])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(10,TYPE1Array[CARD1_type][40])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(10,TYPE1Array[CARD1_type][41])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(10,TYPE1Array[CARD1_type][42])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(10,TYPE1Array[CARD1_type][43])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(10,TYPE1Array[CARD1_type][44])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(10,TYPE1Array[CARD1_type][45])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(10,TYPE1Array[CARD1_type][46])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(10,TYPE1Array[CARD1_type][47])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(10,TYPE1Array[CARD1_type][48])
		elif mouse_pos[1]<140+H*12:
			CustomSearch(10,TYPE1Array[CARD1_type][49])
		elif mouse_pos[1]<140+H*13:
			CustomSearch(10,TYPE1Array[CARD1_type][50])
		elif mouse_pos[1]<140+H*14:
			CustomSearch(10,TYPE1Array[CARD1_type][51])
	elif mouse_pos[0]<1685 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(10,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(10,TYPE1Array[CARD1_type][52])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(10,TYPE1Array[CARD1_type][53])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(10,TYPE1Array[CARD1_type][54])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(10,TYPE1Array[CARD1_type][55])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(10,TYPE1Array[CARD1_type][56])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(10,TYPE1Array[CARD1_type][57])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(10,TYPE1Array[CARD1_type][58])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(10,TYPE1Array[CARD1_type][59])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(10,TYPE1Array[CARD1_type][60])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(10,TYPE1Array[CARD1_type][61])
		elif mouse_pos[1]<140+H*12:
			CustomSearch(10,TYPE1Array[CARD1_type][62])
		elif mouse_pos[1]<140+H*13:
			CustomSearch(10,TYPE1Array[CARD1_type][63])
		elif mouse_pos[1]<140+H*14:
			CustomSearch(10,TYPE1Array[CARD1_type][64])
	elif mouse_pos[0]<1985 and $THE_BUTTON/TXT_ALLTYPE1.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(10,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(10,TYPE1Array[CARD1_type][65])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(10,TYPE1Array[CARD1_type][66])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(10,TYPE1Array[CARD1_type][67])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(10,TYPE1Array[CARD1_type][68])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(10,TYPE1Array[CARD1_type][69])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(10,TYPE1Array[CARD1_type][70])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(10,TYPE1Array[CARD1_type][71])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(10,TYPE1Array[CARD1_type][72])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(10,TYPE1Array[CARD1_type][73])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(10,TYPE1Array[CARD1_type][74])
		elif mouse_pos[1]<140+H*12:
			CustomSearch(10,TYPE1Array[CARD1_type][75])
		elif mouse_pos[1]<140+H*13:
			CustomSearch(10,TYPE1Array[CARD1_type][76])
		elif mouse_pos[1]<140+H*14:
			CustomSearch(10,TYPE1Array[CARD1_type][77])
	elif mouse_pos[0]<455 and $THE_BUTTON/TXT_ALLTYPE2.visible==true:
		print("pass")
	elif mouse_pos[0]<700 and $THE_BUTTON/TXT_ALLTYPE2.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(11,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(11,Type2Array[0])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(11,Type2Array[1])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(11,Type2Array[2])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(11,Type2Array[3])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(11,Type2Array[4])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(11,Type2Array[5])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(11,Type2Array[6])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(11,Type2Array[7])
		elif mouse_pos[1]<140+H*10:
			CustomSearch(11,Type2Array[8])
		elif mouse_pos[1]<140+H*11:
			CustomSearch(11,Type2Array[9])
	elif mouse_pos[0]<1200 and $THE_BUTTON/TXT_ALLATTRIB.visible==true:
		print("pass")
	elif mouse_pos[0]<1450 and $THE_BUTTON/TXT_ALLATTRIB.visible==true:
		if mouse_pos[1]<140+H*0:
			print("pass")
		elif mouse_pos[1]<140+H*1:
			CustomSearch(12,false)
		elif mouse_pos[1]<140+H*2:
			CustomSearch(12,AttribArray[0])
		elif mouse_pos[1]<140+H*3:
			CustomSearch(12,AttribArray[1])
		elif mouse_pos[1]<140+H*4:
			CustomSearch(12,AttribArray[2])
		elif mouse_pos[1]<140+H*5:
			CustomSearch(12,AttribArray[3])
		elif mouse_pos[1]<140+H*6:
			CustomSearch(12,AttribArray[4])
		elif mouse_pos[1]<140+H*7:
			CustomSearch(12,AttribArray[5])
		elif mouse_pos[1]<140+H*8:
			CustomSearch(12,AttribArray[6])
		elif mouse_pos[1]<140+H*9:
			CustomSearch(12,AttribArray[7])
	elif mouse_pos[0]<1200 and $THE_BUTTON/TXT_ALLRARITY.visible==true:
		print("pass")
	elif mouse_pos[0]<1450 and $THE_BUTTON/TXT_ALLRARITY.visible==true:
		if mouse_pos[1]<140-H*1:
			print("pass")
		elif mouse_pos[1]<140+H*0:
			CustomSearch(7,false)
		elif mouse_pos[1]<140+H*1:
			CustomSearch(7,"Common")
		elif mouse_pos[1]<140+H*2:
			CustomSearch(7,"Super Rare")
		elif mouse_pos[1]<140+H*3:
			CustomSearch(7,"Ultra Rare")
		elif mouse_pos[1]<140+H*4:
			CustomSearch(7,"Secret Rare")
		elif mouse_pos[1]<140+H*5:
			CustomSearch(7,"Prismatic Secret Rare")


#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18    19
# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG,LIMIT]
func CustomSearch(SORT,TXT):

	print("SET_SELECT / CustomSearch ( SORT = "+String(SORT)+" , TXT = "+String(TXT)+" )")
	#se já estiver visualizando as cartas
	if get_viewport().get_node("COLLECTION/SET").visible == true:
		print("SET já está visivel")
		match SORT:
			3:
				if TXT is bool:
					$TXT_QTD.modulate = Color(1,1,1,0.5)
					QTD_TXT = "Qtd"
					$TXT_QTD.text = "Qtd"
				else:
					$TXT_QTD.modulate = Color(1,1,1,1)
					$TXT_QTD.text = "Qtd*"
					QTD_TXT = "Qtd*"
			4:
				SET_TXT=TXT
				if String(TXT) == "SET":
					$TXT_SET.modulate = Color(1,1,1,1)
					TXT=false
					SET_TXT="All Sets"
					$TXT_SET.text = SET_TXT
			7:
				if TXT is bool:
					$TXT_RARITY.modulate = Color(1,1,1,0.5)
					RARITY_TXT = "Rarity"
					$TXT_RARITY.text = RARITY_TXT
				else:

					$TXT_RARITY.text = String(TXT)
					RARITY_TXT = TXT
			8:
				if TXT is bool:
					$TXT_CARD1.modulate = Color(1,1,1,0.5)
					CARD1_TXT = "Which Card?"
					$TXT_CARD1.text = CARD1_TXT
				else:
					$TXT_CARD1.modulate = Color(1,1,1,1)
					$TXT_CARD1.text = TXT
					CARD1_TXT = TXT
				GLOBAL.CustomFilter[ 9] = false
				GLOBAL.CustomFilter[10] = false
				GLOBAL.CustomFilter[11] = false
				GLOBAL.CustomFilter[12] = false
			9:
				if TXT is bool:
					$TXT_CARD2.modulate = Color(1,1,1,0.5)
					CARD2_TXT = "Which Card?"
					$TXT_CARD2.text = CARD2_TXT
				else:
					$TXT_CARD2.modulate = Color(1,1,1,1)
					$TXT_CARD2.text = TXT
					CARD2_TXT = TXT
			10:
				if TXT is bool:
					$TXT_TYPE1.modulate = Color(1,1,1,0.5)
					TYPE1_TXT = "Which Type?"
					$TXT_TYPE1.text = TYPE1_TXT
				else:
					$TXT_TYPE1.modulate = Color(1,1,1,1)
					$TXT_TYPE1.text = TXT
					TYPE1_TXT = TXT
			11:
				if TXT is bool:
					$TXT_TYPE2.modulate = Color(1,1,1,0.5)
					TYPE2_TXT = "Which Type?"
					$TXT_TYPE2.text = TYPE2_TXT
				else:
					$TXT_TYPE2.modulate = Color(1,1,1,1)
					$TXT_TYPE2.text = TXT
					TYPE2_TXT = TXT
			12:
				$TXT_ATTRIB.modulate = Color(1,1,1,1)
				if TXT is bool:
					ATTRIB_TXT = "All Attrib."
					$TXT_ATTRIB.text = ATTRIB_TXT
				else:
					$TXT_ATTRIB.text = String(TXT)
					ATTRIB_TXT = TXT
			13:
				if TXT is bool:
					$TXT_LV.modulate = Color(1,1,1,0.5)
					LV_TXT = "LV"
					$TXT_LV.text = "LV"
				else:
					$TXT_LV.modulate = Color(1,1,1,1)
					$TXT_LV.text = "LV*"
					LV_TXT = "LV*"
			14:
				if TXT is bool:
					$TXT_ATK.modulate = Color(1,1,1,0.5)
					ATK_TXT = "ATK"
					$TXT_ATK.text = "ATK"
				else:
					$TXT_ATK.modulate = Color(1,1,1,1)
					$TXT_ATK.text = "ATK*"
					ATK_TXT = "ATK*"
			15:
				if TXT is bool:
					$TXT_DEF.modulate = Color(1,1,1,0.5)
					DEF_TXT = "DEF"
					$TXT_DEF.text = "DEF"
				else:
					$TXT_DEF.modulate = Color(1,1,1,1)
					$TXT_DEF.text = "DEF*"
					DEF_TXT = "DEF*"
			16:
				if TXT == "":
					TXT = false
			18:
				if TXT is bool:
					$TXT_FAV.modulate = Color(1,1,1,0.5)
					FAV_TXT = "Fav"
					$TXT_FAV.text = "Fav"
				else:
					$TXT_FAV.modulate = Color(1,1,1,1)
					$TXT_FAV.text = "Fav*"
					FAV_TXT = "Fav*"
			19:
				if TXT is bool:
					$TXT_LIMIT.modulate = Color(1,1,1,0.5)
					LIMIT_TXT = "Limits"
					$TXT_LIMIT.text = "Limits"
				else:
					$TXT_LIMIT.modulate = Color(1,1,1,1)
					$TXT_LIMIT.text = "Limits*"
					LIMIT_TXT = "Limits*"
		begin()
		GLOBAL.CustomFilter[ SORT ] = TXT
		print("GLOBAL.CustomFilter = ",GLOBAL.CustomFilter)
		var novaPool = GLOBAL.FILTER(GLOBAL.CustomFilter)
		get_viewport().get_node("COLLECTION/SET/CARDS_DISPLAY").pg = 0
		get_viewport().get_node("COLLECTION/SET/CARDS_DISPLAY").update_cards(novaPool,0) #abre pagina 0
	else:
		var temp = TXT
		if String(TXT) == "SET":
			TXT=false
		var f = false
		var F = [f]
		while F.size()!=20:
			F.append(f)
		F[4]=TXT
#		GLOBAL.CustomFilter=[f,f,f,f,TXT,f,f,f,f,f,f,f,f,f,f,f,f]
		GLOBAL.CustomFilter=F
		print("GLOBAL.CustomFilter = ",GLOBAL.CustomFilter)
		TXT = temp
		AA.GO2SET(TXT)


