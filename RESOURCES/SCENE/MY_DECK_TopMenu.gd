extends Control

func _ready():
	$DropDown_SampleCustomDeck.add_item("View All Decks")
	$DropDown_SampleCustomDeck.add_separator()
	$DropDown_SampleCustomDeck.add_icon_item(load("res://IMAGENS_ICONES/DECKS/Sample_deck.png")," View Sample Decks")
	$DropDown_SampleCustomDeck.add_icon_item(load("res://IMAGENS_ICONES/DECKS/Tournament_deck.png")," View Tournament Decks")
	$DropDown_SampleCustomDeck.add_icon_item(load("res://IMAGENS_ICONES/DECKS/Custom_deck.png")," View Custom Decks")
	#$DropDown_SampleCustomDeck.connect("item_selected",self,"_deck_selecionado")
	
	$DropDown_Sort.add_item("Classic First")
	$DropDown_Sort.add_item("Newest First")
	$DropDown_Sort.add_separator()
	$DropDown_Sort.add_item("ABC...Z")
	$DropDown_Sort.add_item("ZYX...A")
	$DropDown_Sort.add_separator()
	$DropDown_Sort.add_item("Tier 123...9")
	$DropDown_Sort.add_item("Tier 987...1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
