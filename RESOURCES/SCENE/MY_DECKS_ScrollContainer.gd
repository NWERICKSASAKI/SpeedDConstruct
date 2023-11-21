extends ScrollContainer

onready var GLOBAL = get_viewport().get_node("/root/GLOBAL")

func _ready():
	$VBoxContainer/HBoxContainer/ADeck._load_create_a_new_deck()
	_MyDecksDisplay_byFilter_bySort("All","None")
	pass # Replace with function body.

func _getting_Decks_to_1_unique_array(): # none / ABC / TierFav
	var _myDecks1array = GLOBAL._myDecks[0]+GLOBAL._myDecks[1]
	var i = 0
	while i<_myDecks1array.size():
		if(_myDecks1array[i][2]==""):
			_myDecks1array.remove(i)
		else:
			i+=1
	return _myDecks1array

func _MyDecksDisplay_byFilter_bySort(which_filter,which_sort): # ["All","Custom","Sample","Tournament"]
	var _myDecks1A = _getting_Decks_to_1_unique_array()
	var i = 1
	
	while i<_myDecks1A.size(): #escaneia CustomDecks
		if(i%4==0):
			var _HBoxContainer = HBoxContainer.new()
			$VBoxContainer.add_child(_HBoxContainer)
			_HBoxContainer.size_flags_horizontal=2
			_HBoxContainer.size_flags_vertical=2
			_HBoxContainer.alignment=1
		var _ADeck = preload("res://SCENE/ADeck.tscn").instance()
		$VBoxContainer.get_child($VBoxContainer.get_child_count()-1).add_child(_ADeck)
		match _myDecks1A[i][2]:
			"Custom":
				_ADeck._loadDeckinfos(0,i)
			_:
				_ADeck._loadDeckinfos(1,i)
		_ADeck.modulate=Color(1,1,1,0)
		_ADeck.get_node("Tween").interpolate_property(_ADeck,"modulate", Color(1,1,1,-1*i), Color(1,1,1,1), 0.2*i, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		_ADeck.get_node("Tween").start()
		_ADeck.enabled_focus_mode=false
		i+=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
