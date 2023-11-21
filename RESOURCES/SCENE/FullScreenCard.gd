extends Node2D

var ID = 0
var _O = 0
var Num = Vector2(1,3)
var CardNumber = 99
onready var GLOBAL = get_node("/root/GLOBAL")
var cheatUp=0
var cheatDown=0
var cheatEnable=false

func _ready():
	visible = false
	$B_RETURN.connect("pressed",self,"CloseCard")
	$B_L_MINUS.connect("pressed",self,"ChangeNum",[0,-1,0])
	$B_L_PLUS.connect("pressed",self,"ChangeNum",[0,1,0])
	$B_O_MINUS.connect("pressed",self,"ChangeNum",[-1,0,0])
	$B_O_PLUS.connect("pressed",self,"ChangeNum",[1,0,0])
	$B_FAV.connect("pressed",self,"ChangeNum",[0,0,1])
	$B_EYE.connect("pressed",self,"ShowIMGonlyCommand")
	_ready_Add2Deck()




# N E W !
#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18
# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG]

func LoadCard(DATA): # CARD
#	print("FullScreenCard / LoadCard( DATA = ",DATA,", new_CardNumber = ",CardNumber)
	get_parent().get_node("CARDS_DISPLAY").visible=false
	get_viewport().get_node("COLLECTION/TOP_MENU").visible=false
	visible = true
	$CardSprite.loadData(DATA)
	ID = int(DATA[2])
	_O = int(DATA[1])
#	CardNumber = GLOBAL.myCards[ID][Rarity]
	loadNum(_O)
	$Sprite_Eye.modulate=Color(1,1,1,1)
	ToF=true
	$OptionButton.select(0)
	$Sprite_PlusMinus.set_material(null)
	cheatUp=0
	cheatDown=0
	cheatEnable=false

func loadNum(new_O):
	var owned = GLOBAL.myCards[new_O][0]
	var wanted = GLOBAL.myCards[new_O][1]
	var favNum = GLOBAL.myCards[new_O][2]
	Num = Vector3(owned,wanted,favNum)
#	ID = new_ID
	_O = new_O
	ChangeNum(0,0,0)

func ChangeNum(N_own,N_limit,N_fav):
	print("FullScreenCard / ChangeNum")
#	Num += Vector3(N_own,N_limit,N_fav)
	
	## cheat code fecha aspas
	#
	if(cheatEnable):
		Num += Vector3(99*N_own,99*N_limit,N_fav)
	else:
		Num += Vector3(N_own,N_limit,N_fav)
		print(N_own+N_limit)
		if(cheatUp>=5 and cheatDown>=5):
			cheatEnable=true
			var SP = preload("res://SCENE/GOLDEN_SHADER.tres")
			$Sprite_PlusMinus.set_material(SP)
		elif(N_own+N_limit>0):
			cheatUp+=1
		elif(N_own+N_limit<0):
			cheatDown+=1
	#
	## fim de cheat code fecha aspas
	
	
#	Num += Vector3(N_own,N_limit,N_fav)
	if(Num[0]<0): 
		Num[0]=0
	elif(Num[0]>=99):
		Num[0]=99
	$TXT_O.bbcode_text="[center]"+String(Num[0])+"[/center]"
	if(Num[1]<0):
		Num[1]=0
	elif(Num[1]>=99):
		Num[1]=99
	$TXT_L.bbcode_text="[center]"+String(Num[1])+"[/center]"
	if(Num[2]==0 or Num[2]>9):
		$FAV_IMG.modulate=Color(1,1,1,0.5)
		Num[2]=0
	else:
		$FAV_IMG.modulate=Color(1,1,1,1)
	$FAV_IMG.texture=load("res://IMAGENS_ICONES/FAV/FAV"+String(Num[2])+".png")
	print("FullScreenCard / ChangeNum / ",Num )
	saveNum(_O,Num)

func saveNum(new_O,newNum):
	GLOBAL.myCards[new_O][0]=newNum[0]
	GLOBAL.myCards[new_O][1]=newNum[1]
	GLOBAL.myCards[new_O][2]=newNum[2]
	GLOBAL.savingMyCards()

func CloseCard():
	print("FullScreenCard / CloseCard()")
	visible = false
	get_parent().get_node("CARDS_DISPLAY").visible=true
	get_viewport().get_node("COLLECTION/TOP_MENU").visible=true
	get_viewport().get_node("COLLECTION/SET/CARDS_DISPLAY").card_Array[CardNumber].num=Num[0]
	get_viewport().get_node("COLLECTION/SET/CARDS_DISPLAY").card_Array[CardNumber].updateNsave(0)
	$CardSprite.showIMGonly(false)

var ToF=true
func ShowIMGonlyCommand():
	$CardSprite.showIMGonly(ToF)
	if ToF:
		$Sprite_Eye.modulate=Color(1,1,1,0.5)
	else:
		$Sprite_Eye.modulate=Color(1,1,1,1)
	ToF=!ToF




func _ready_Add2Deck():
	$OptionButton.add_icon_item(load("res://IMAGENS_ICONES/add2deck.png")," Add it to a deck")
	$OptionButton.add_separator()
	$OptionButton.add_item("Deck 01")
	$OptionButton.add_item("Deck 02")
	$OptionButton.add_item("Em desenvolvimento")
	$OptionButton.add_item("Funcao inoperante")
	$OptionButton.add_item("Em fase de teste")
	$OptionButton.add_item("Sim eu sei que ta bugado")
	$OptionButton.connect("item_selected",self,"_deck_selecionado")
#	$OptionButton.get_popup().rect_position=Vector2(1000,1000)
	$OptionButton.get_popup().rect_rotation=270
#	var i = 0
#	while i<10:
#		i+=1
##		$OptionButton.add_item("others1")


func _deck_selecionado(NDeck):
	$OptionButton.select(0)
	$OptionButton.text=" Card added to: "+$OptionButton.get_item_text(NDeck)

	$Tween.interpolate_property($OptionButton,"modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()


