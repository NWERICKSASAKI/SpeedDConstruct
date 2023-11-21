extends Node2D # CARD é chamado por CARD_DISP

var num = 0
var IMG_PATH = ""
var DATA = []
var ID = 0
var _O = 0
var CardNumber = 10
onready var GLOBAL = get_viewport().get_node("/root/GLOBAL")
onready var Gmc = GLOBAL.myCards

func _ready():
	set_process(false)
	if GLOBAL.WT == 0: #Se estiver no COLLECTION
		$TOP.connect("released",self,"updateNsave",[1])
		$BOT.connect("released",self,"updateNsave",[-1])
		$FAV.connect("released",self,"updateFav")
	else: #Se estiver no TRADEWISH
		$TOP.connect("released",self,"openCard")
		$BOT.connect("released",self,"openCard")
		$FAV.connect("released",self,"openCard") # tentar removeChild depois
		$FAV_IMG.visible=false
		$LIMIT.visible=false
	$MID.connect("released",self,"openCard")
	$TXT.visible=bool(GLOBAL.myConfs[1])



func updateFav():
	if GLOBAL.lock == true:
		get_tree().get_root().get_node("/root/COLLECTION/SET/CARDS_DISPLAY/Lock").blinkAnimation()
	else:
		var newFavNum = GLOBAL.myCards[_O][2]+1
		if newFavNum > 9:
			newFavNum=0;
			#$FAV_IMG.modulate=Color(1,1,1,0.5)
		else:
			pass
			#$FAV_IMG.modulate=Color(1,1,1,1)
		GLOBAL.myCards[_O][2]=newFavNum
		updateTXT()
		GLOBAL.savingMyCards()

# old
#  0 1   2   3   4    5     6     7     8    9     10     11   12 13  14      15         16
# [O,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,DescEffect2]

# N E W !
#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18
# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG]



func updateNsave(plus_or_minus):
#	print("CARD / updateNumber("+String(plus_or_minus)+")")
	if GLOBAL.lock == true and plus_or_minus !=0:
		get_tree().get_root().get_node("/root/COLLECTION/SET/CARDS_DISPLAY/Lock").blinkAnimation()
	else:
		num = int(GLOBAL.myCards[_O][0]) + plus_or_minus
		if num<=0:
			num=0
			$Card_Manual.grayscale(true)
		elif (num>999):
			num = 999
		else:
			$Card_Manual.grayscale(false)
		#COLLECTION
		GLOBAL.myCards[_O][0]=num
		updateTXT()
		GLOBAL.savingMyCards()

func updateTXT(): ############# provavelmente nao ta achando o RATIRY e associando com o ID certo
	_O = int(DATA[1])
	ID = int(DATA[2])
	$Card_Manual.grayscale(false)
	match DATA[7]:
		"Common":
			$PARTICLE.visible=false
			$Card_Manual.rainbow(false)
		"Super Rare":
			$PARTICLE.visible=bool(GLOBAL.myConfs[3])
			$PARTICLE.amount=50
			$Card_Manual.rainbow(true)
		"Ultra Rare":
			$PARTICLE.visible=bool(GLOBAL.myConfs[3])
			$PARTICLE.amount=500
			$Card_Manual.rainbow(true)
		"Secret Rare":
			$PARTICLE.visible=bool(GLOBAL.myConfs[3])
			$PARTICLE.amount=1500
			$Card_Manual.rainbow(true)
		_:
			$PARTICLE.visible=bool(GLOBAL.myConfs[3])
			$PARTICLE.amount=2500
			$Card_Manual.rainbow(true)
	
	match String(DATA[19]):
		"0":
			$LIMIT.visible=true
			$LIMIT.texture=load("res://IMAGENS_ICONES/forbidden.png")
		"1":
			$LIMIT.visible=true
			$LIMIT.texture=load("res://IMAGENS_ICONES/limited-1.png")
		"2":
			$LIMIT.visible=true
			$LIMIT.texture=load("res://IMAGENS_ICONES/limited-2.png")
		"3":
			$LIMIT.visible=true
			$LIMIT.texture=load("res://IMAGENS_ICONES/limited-3.png")
		_:
			$LIMIT.visible=false
	num = int(GLOBAL.myCards[_O][0])
	var des = int(GLOBAL.myCards[_O][1])
	if GLOBAL.WT==0 or GLOBAL.myConfs[4]==0:
		$TXT.bbcode_text="[center]"+String(num)+"[/center]"
	#TRADABLE
	elif GLOBAL.WT==1: # tradeable
		$TXT.bbcode_text="[center]+"+String(abs(des-num))+"[/center]"
	#WISHLIST
	elif GLOBAL.WT==-1: # wishlist
		$TXT.bbcode_text="[center]+"+String(abs(num-des))+"[/center]"
	if num == 0:
		$Card_Manual.grayscale(true)
	
	var FavNum = int(GLOBAL.myCards[_O][2])
	if(FavNum==0):
		$FAV_IMG.modulate=Color(1,1,1,0.5)
	else:
		$FAV_IMG.modulate=Color(1,1,1,1)
	$FAV_IMG.texture=load("res://IMAGENS_ICONES/FAV/FAV"+String(FavNum)+".png")



func openCard():
	get_parent().get_parent().get_node("FullScreenCard").LoadCard(DATA)
	get_parent().get_parent().get_node("FullScreenCard").CardNumber = CardNumber
