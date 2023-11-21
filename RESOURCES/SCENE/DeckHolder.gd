extends HBoxContainer


onready var GLOBAL = get_viewport().get_node("/root/GLOBAL")

# Called when the node enters the scene tree for the first time.
func _ready():
	placeCards()
	pass # Replace with function body.

func placeCards():
	var which_DeckArray = GLOBAL.which_DeckArray
	var which_DeckID = GLOBAL.which_DeckID
	var DeckArray = GLOBAL._myDecks[which_DeckArray][which_DeckID]
	var i = 10
	
	while i < DeckArray.size():
#		if(int(DeckArray[i])!=-1): # nao for vazio
		var _ACard = preload("res://SCENE/CardSprite_Control.tscn").instance()
		if (i==10):
			$VBC_SkillCard.add_child(_ACard)
			_ACard.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(int(DeckArray[i])))
			_ACard.rect_scale=Vector2(0.3,0.3)
		elif(i>10 and i<=40):
			$VBC_MainDeck.add_child(_ACard)
			_ACard.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(int(DeckArray[i])))
			_ACard.rect_scale=Vector2(0.1,0.1)
		elif(i>40 and i<=46):
			$VBC_ExtraDeck.add_child(_ACard)
			_ACard.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(int(DeckArray[i])))
			_ACard.rect_scale=Vector2(0.1,0.1)
		elif(i>50 and i<=56):
			$VBC_SideDeck.add_child(_ACard)
			_ACard.loadData(GLOBAL._get_DATABASE_lineArray_by_ID(int(DeckArray[i])))
			_ACard.rect_scale=Vector2(0.1,0.1)
		i+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
