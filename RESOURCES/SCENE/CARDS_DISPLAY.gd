extends Node2D

var card_Array = [] # para acessar cada uma das 10 cartas no cenário
var card_pool = []
var pg = 0
var set = ""
var CardPool = []
var oldPool = []
onready var GLOBAL = get_node("/root/GLOBAL")
onready var DATABASE = GLOBAL.DATABASE

func _ready():
	set_process(false)
	get_parent().visible=false
	place_cards()
	$LeftArrow.connect("released",self,"changePg",[-1])
	$RightArrow.connect("released",self,"changePg",[1])


func place_cards():
	print("CARDS_DISPLAY / place_cards()")
	var i = 0
	var j = 133
	if GLOBAL.WT==0:
		var k = 0
		while i < 10:
			var CARD_NODE = preload("res://SCENE/CARD.tscn").instance()
			add_child(CARD_NODE)
			if(i>4): # segunda linha do display
				j = 609
				k = 5
			CARD_NODE.position=Vector2(139+(474-139)*(i-k),j)
			card_Array.append(CARD_NODE)
			i+=1
	else:
		while i < 40:
			var CARD_NODE = preload("res://SCENE/CARD.tscn").instance()
			CARD_NODE.scale=Vector2(1,1)/2
			add_child(CARD_NODE)
			if(i%10==0 and i!=0):
				j += 235
			CARD_NODE.position=Vector2(139+(150+17)*(i%10),j)
			card_Array.append(CARD_NODE)
			i+=1


func changePg(plus_or_minus):
	print("changePg = "+String(pg)+" + "+String(plus_or_minus))
	pg += plus_or_minus
	if(pg<=0):
		pg=0
		$LeftArrow.visible=false
	else:
		$LeftArrow.visible=true
	if((pg+1)*10>=CardPool.size()):
		$RightArrow.visible=false
	else:
		$RightArrow.visible = true
	update_cards(CardPool,pg)

func update_cards(newPool,new_pg): #AA #
	var NC = 40 # numero de cartas para display (10 p Collection e 40 para WishTrade)
	if(GLOBAL.WT==0):
		NC = 10
	if oldPool != newPool:
		$RightArrow.visible=true
		oldPool = newPool
	if(new_pg<=0):
		$LeftArrow.visible=false
	if(newPool.size()-1<NC):
		$RightArrow.visible=false
	CardPool = newPool
	var max_pg = (CardPool.size()-1)/NC
	$TXT_PG.bbcode_text="[right]"+String(new_pg)+"/"+String(max_pg)+"[/right]"
	var page = NC * new_pg
	var i = 0
	while i<NC:
		if(1+i+page>CardPool.size()):
			card_Array[i].visible=false
		else:
			card_Array[i].visible=true
			card_Array[i].DATA = CardPool[i+page]
			card_Array[i].CardNumber=i
			card_Array[i].get_node("Card_Manual").loadData(CardPool[i+page])
			card_Array[i].updateTXT()
			$Tw.interpolate_property(card_Array[i],"modulate", Color(0,0,0,-0.20*i), Color(1,1,1,1), 0.2+0.10*i, Tween.TRANS_SINE, Tween.EASE_IN)
			$Tw.start()
		i+=1
