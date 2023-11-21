extends Button

onready var GLOBAL = get_viewport().get_node("/root/GLOBAL")


func _ready():
#	$TSB.connect("released",self,"_changeFAV")
#	self.rect_size=Vector2(400,280)
	#_teste(true)
	pass

func _teste():
	print("appeared")
	_load_create_a_new_deck()
	$VisibilityNotifier2D.disconnect("screen_entered",self,"_teste")

func _loadWhenVisible(which_DeckArray,which_DeckID):
	$VisibilityNotifier2D.disconnect("screen_entered",self,"_loadWhenVisible")
	#print("ADeck / _loadWhenVisible (carregando depois de visivel)")
	_loadDeckinfos(which_DeckArray,which_DeckID)

func _loadDeckinfos(which_DeckArray,which_DeckID): # entra com o DeckID (para carregar nome e cartas) ou false (para Create Deck)
	if !$VisibilityNotifier2D.is_on_screen():
		$VisibilityNotifier2D.connect("screen_entered",self,"_loadWhenVisible",[which_DeckArray,which_DeckID])
		return
	#[ 0      1       2          ] which_DeckArray
	#[Custom, Sample, Tournament ]
	#[ 0       1      2     3         4          5          6           7      8     9          10         11 ........ .... 41 ......... .... 51 ........ .... 61 .....]
	#[ DeckID, Title, Type, Comments, Front (_O),Left (_O), Right (_O), Color, Tier, reservado, MainSkill, MainDeck01, ..., ExtraDeck01, ..., SideDeck01, ..., ETC1,...]
	
	var DeckArray = GLOBAL._myDecks[which_DeckArray][which_DeckID] 
	$DeckTitleTXT.bbcode_text ="[center]"+String(DeckArray[1])+"[/center]"
	$CARD_LEFT.visible=true
	$CARD_RIGHT.visible=true
	$CARD_FRONT.visible=true
	$plusTXT.visible=false
	if(DeckArray[2]=="Sample"):
		$FAV.visible=false
		$BackColor.modulate=Color(1,1,1,1)
	elif(DeckArray[2]=="Tournament"):
		$BackColor.modulate=Color(1,1,1,1)
		$FAV.texture=load("res://IMAGENS_ICONES/FAV/FAV"+String(DeckArray[8])+".png")
	else:
		$FAV.visible=true
		$BackColor.modulate=DeckArray[7]
		$FAV.texture=load("res://IMAGENS_ICONES/FAV/FAV"+String(DeckArray[8])+".png")
	$DECK_TYPE_SPRITE.visible=true
	$CARD_FRONT.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(DeckArray[4]))
	$CARD_LEFT.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(DeckArray[5]))
	$CARD_RIGHT.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(DeckArray[6]))
	$DECK_TYPE_SPRITE.texture=load("res://IMAGENS_ICONES/DECKS/"+String(DeckArray[2])+"_deck.png")
	$TSB.connect("pressed",self,"_pressed_Deck",[1,which_DeckArray,which_DeckID])
	return

func _load_create_a_new_deck(): # para ficar no modo "Create a New Deck"
	$CARD_LEFT.visible=false
	$CARD_RIGHT.visible=false
	$CARD_FRONT.visible=false
	$plusTXT.visible=true
	$FAV.visible=false
	$DECK_TYPE_SPRITE.visible=false
	$DeckTitleTXT.bbcode_text="[center]Create a new deck[/center]"
	$BackColor.modulate=Color(1,1,1,1)
	$TSB.connect("pressed",self,"_pressed_Deck",[0,false,false])
	return

func _pressed_Deck(new0_enterDeck1,which_DeckArray,which_DeckID):
#	$TSB.disconnect("pressed",self,"_pressed_Deck")
#	$TSB.connect("pressed",self,"_openDeck",[get_global_rect(),new0_enterDeck1,which_DeckArray,which_DeckID]) #RELEASED
#
#func _openDeck(previous_pos,new0_enterDeck1,which_DeckArray,which_DeckID):
#	$TSB.disconnect("pressed",self,"_openDeck") #RELEASED
#	if( $VisibilityNotifier2D.is_on_screen()): # previous_pos==get_global_rect() and  VisibilityNotifier2D.global_position[1]>=150 and
	print("ADeck / _openDeck / true")
	match new0_enterDeck1:
		0:
			print("create a new deck")
		1:
			print("acessing that deck [which_DeckArray,which_DeckID]= "+String(which_DeckArray)+" / "+String(which_DeckID))
			GLOBAL.which_DeckArray=which_DeckArray
			GLOBAL.which_DeckID=which_DeckID
			get_tree().change_scene("res://SCENE/DECK_VIEWER.tscn")
#	else:
#		print("ADeck / _openDeck / not visiv")
#	$TSB.connect("pressed",self,"_pressed_Deck",[new0_enterDeck1,which_DeckArray,which_DeckID])

func _changeFAV():
	pass

#func _process(delta):
#	pass
