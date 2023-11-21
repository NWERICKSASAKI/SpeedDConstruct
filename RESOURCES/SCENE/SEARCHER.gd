extends TextEdit

onready var ML = self.margin_left
onready var MR = self.margin_right
onready var MT = self.margin_top
onready var MB = self.margin_bottom
const ML2 = 1220
onready var DefaultTXT = self.text
onready var Tw = Tween.new()
var LastText=""
var operante = false # variavel criada para evitar que ao acionar o SLIDER, a caixa de texto fosse acionada em seguida

# Called when the node enters the scene tree for the first time.
func _ready():
	visible=false
	add_child(Tw)
	set_process_input(true)
	self.connect("focus_entered",self,"Clicou")
	self.readonly=true
	self.selecting_enabled=false

func Clicou(): #CLICOU NA CAIXA DE SEARCHER

	print("SEARCHER / Clicou()")
	if operante:
		if self.selecting_enabled!=true: # tem que estar antes pra evitar duplicidade
			get_parent().connected_buttons(false)
			self.selecting_enabled=true
			self.readonly=false
		
		if (text=="" or text==DefaultTXT):
			self.text = ""
		elif bool(GLOBAL.myConfs[5])==false:
			self.text = ""
	#	else:
	#		OS.show_virtual_keyboard(text)
		Tw.interpolate_property(self,"margin_left", margin_left, ML2, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		Tw.start()


func _input(event):
	
	#DEU ENTER
	if (event.is_action_pressed("enter")):
		print("SEARCHER / _input(event) | enter pressed")
		var newTXT = self.text
		newTXT.erase(newTXT.length(),1)
		if(newTXT.length()!=0):
			if(newTXT[newTXT.length()-1]==" "): # retirar o último " " para evitar erro do search de mais de uma palavras
				newTXT.erase(newTXT.length()-1,1)
		text = newTXT
		var upper_TXT = text.to_upper()
		text = upper_TXT
		get_parent().CustomSearch(16,text)
		if(text==""):
			text = DefaultTXT
		LastText = text
		Saiu()
	
	#CLICOU FORA
	elif event is InputEventMouseButton and not _is_pos_in(event.position) and self.selecting_enabled == true:
		print("SEARCHER / _input(event) | clicou fora")
		if(LastText==""):
			self.text = DefaultTXT
		else:
			self.text = LastText
		Saiu()

func _is_pos_in(checkpos:Vector2):
	var gr=get_global_rect()
	return checkpos.x>=gr.position.x and checkpos.y>=gr.position.y and checkpos.x<gr.end.x and checkpos.y<gr.end.y

func Saiu():
	print("SEARCHER / Saiu()")
	Tw.interpolate_property(self,"margin_left", margin_left, ML, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	Tw.start()
	release_focus()
	if(self.selecting_enabled==true):
		self.selecting_enabled=false
		get_parent().connected_buttons(true)
		self.readonly=true
