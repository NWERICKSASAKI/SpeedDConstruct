extends Node2D # CARD é chamado por CARD_DISP

var Rarity = 0
var CARDnumber = 99 # 0 a 9
var num = 0
var DA = []
var ID = 0
var _O = 0
onready var GLOBAL = get_node("/root/GLOBAL")
const URColor = Color(0.83,0.68,0,32)
var http_request = HTTPRequest.new()
var SP
var SP1 # para ilustraçao e atributo

func _ready():
	set_process(false)
	$DESC.selection_enabled=bool(GLOBAL.myConfs[2])
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	

# N E W !
#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18
# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG]

func loadData(CardArray): # chamado por CARDDISPLAY
	DA=CardArray
	_O=int(CardArray[1])
	ID=int(CardArray[2])
	var dynamic_font1 = DynamicFont.new()
	dynamic_font1.font_data = preload("res://Fonts/Yu-Gi-Oh! Matrix Regular Small Caps 2.ttf")
	$NAME.set("custom_fonts/normal_font", dynamic_font1)
	$NAME.set("custom_colors/default_color",Color(1,1,1,1)) #fonte branca (spell, trap, skill)
	$NAME.get_font("normal_font").outline_color=Color(0,0,0,1)
	$NAME.bbcode_text=DA[6]
	if $NAME.text.length()>18: # caso nome comprido, reduz tamanho da fonte
#		var proporcao = 0.5/(17/float($NAME.text.length()))*(-15)
#		$NAME.get_font("normal_font").extra_spacing_char=proporcao
		var np = 18/float($NAME.text.length())
		$NAME.get_font("normal_font").size=120*np
	else:
		$NAME.get_font("normal_font").size=120
	loadIllustration(int(DA[2]))
	$SET.bbcode_text="[right]"+DA[4]+"-"+DA[5]+"[/right]"
	$SET.set("custom_colors/default_color",Color(0,0,0))
	#Default
	var dynamic_font = get_node("DESC").get_font("normal_font")
	
	match DA[8]:
		"Monster":
			$NAME.set("custom_colors/default_color",Color(0,0,0,1))
			$NAME.get_font("normal_font").outline_size=0 #sem contorno (só pra skill)
			$BG.texture=load("res://BIBLIOTECA/CardSetup/Template/Monster"+String(DA[9])+"_Card.png")
			$ATTRIBUTE.visible=true # visivel pra monstros e skill
			$ATTRIBUTE.texture=load("res://BIBLIOTECA/CardSetup/Attribute/"+DA[12]+".png")
			$LV1.visible=true
			var i = 2
			while i<=12:
				if i<=int(DA[13]):
					get_node("LV1/LV"+String(i)).visible=true
				else:
					get_node("LV1/LV"+String(i)).visible=false
				i+=1
			$PROPERTIES.visible=true
			$PROPERTIES.text="["+String(DA[10])+"/"+String(DA[9])+"]"
			if (String(DA[11])!=""):
				if (String(DA[10])=="Fusion" or String(DA[10])=="Ritual"): # para fusões, ritais e outros
					$PROPERTIES.text="["+String(DA[10])+"/"+String(DA[9])+"/"+String(DA[11])+"]"
				else: # para cartas de efeito
					$PROPERTIES.text="["+String(DA[10])+"/"+String(DA[11])+"/"+String(DA[9])+"]"
			$ATK.visible=true
			$DEF.visible=true
			#ATK
			match DA[14].length():
				4:
					$ATK.text = DA[14]
				3:
					$ATK.text = "  "+DA[14]
				2:
					$ATK.text = "    "+DA[14]
				1:
					$ATK.text = "      "+DA[14]
			#DEF
			match DA[15].length():
				4:
					$DEF.text = DA[15]
				3:
					$DEF.text = "  "+DA[15]
				2:
					$DEF.text = "    "+DA[15]
				1:
					$DEF.text = "      "+DA[15]
			match DA[9]:
				"Normal":
					dynamic_font.font_data = load("res://Fonts/Yu-Gi-Oh! ITC Stone Serif LT Italic.ttf")
				_:
					dynamic_font.font_data = load("res://Fonts/Yu-Gi-Oh! Matrix Book.ttf")
			$DESC.set("custom_fonts/normal_font", dynamic_font)
			$DESC.bbcode_text="[fill]"+String(DA[16])+"[/fill]"
			$DESC.rect_position.y=1210
			$DESC.rect_size.y=209
			$SPELLTRAP.visible=false
			$SPELLTRAP_TXT.visible=false
	
		"Skill":
			$LV1.visible=false #Só monstro tem LV
			$SET.set("custom_colors/default_color",Color(1,1,1))
			$NAME.get_font("normal_font").outline_size=3
			$BG.texture=load("res://BIBLIOTECA/CardSetup/Template/Skill_Card.png")
			$ATTRIBUTE.visible=false # visivel pra monstros e skill
			$PROPERTIES.visible=true
			if CardArray[9]=="Normal":
				$PROPERTIES.text="["+String(DA[10])+"/"+String(DA[8])+"]"
			else:
				$PROPERTIES.text="["+String(DA[10])+"/"+String(DA[8])+"/"+String(DA[9])+"]"
			dynamic_font.font_data = load("res://Fonts/Yu-Gi-Oh! Matrix Book.ttf")
			$DESC.set("custom_fonts/normal_font", dynamic_font)
			$DESC.bbcode_text=String(DA[16])
			$DESC.rect_position.y=1210
			$DESC.rect_size.y=249
			$ATK.visible=false
			$DEF.visible=false
			$SPELLTRAP.visible=false
			$SPELLTRAP_TXT.visible=false
		"Token":
			$NAME.set("custom_colors/default_color",Color(0,0,0,1))
			$NAME.get_font("normal_font").outline_size=0 #sem contorno (só pra skill)
			$BG.texture=load("res://BIBLIOTECA/CardSetup/Template/Monster"+String(DA[9])+"_Card.png")
#			$BG.texture=load(DA[18])
			$ATTRIBUTE.visible=true # visivel pra monstros e skill
			$ATTRIBUTE.texture=load("res://BIBLIOTECA/CardSetup/Attribute/"+DA[12]+".png")
			$LV1.visible=true
			var i = 2
			while i<=12:
				if i<=int(DA[13]):
					get_node("LV1/LV"+String(i)).visible=true
				else:
					get_node("LV1/LV"+String(i)).visible=false
				i+=1
			$PROPERTIES.visible=true
			$PROPERTIES.text="[ "+String(DA[10])+"/"+String(DA[9])+" ]"
			$ATK.visible=true
			$DEF.visible=true
			#ATK
			match DA[14].length():
				4:
					$ATK.text = DA[14]
				3:
					$ATK.text = "  "+DA[14]
				2:
					$ATK.text = "    "+DA[14]
				1:
					$ATK.text = "      "+DA[14]
			#DEF
			match DA[15].length():
				4:
					$DEF.text = DA[15]
				3:
					$DEF.text = "  "+DA[15]
				2:
					$DEF.text = "    "+DA[15]
				1:
					$DEF.text = "      "+DA[15]
			match DA[9]:
				"Normal":
					dynamic_font.font_data = load("res://Fonts/Yu-Gi-Oh! ITC Stone Serif LT Italic.ttf")
				_:
					dynamic_font.font_data = load("res://Fonts/Yu-Gi-Oh! Matrix Book.ttf")
			$DESC.set("custom_fonts/normal_font", dynamic_font)
			$DESC.bbcode_text="[fill]"+String(DA[16])+"[/fill]"
			$DESC.rect_position.y=1210
			$DESC.rect_size.y=209
			$SPELLTRAP.visible=false
			$SPELLTRAP_TXT.visible=false
		_: #Spell / Trap
			$LV1.visible=false #Só monstro tem LV
			$NAME.get_font("normal_font").outline_size=0 #sem contorno (só pra skill)
			$BG.texture=load("res://BIBLIOTECA/CardSetup/Template/"+String(DA[8])+"_Card.png")
			$ATTRIBUTE.visible=true
			$ATTRIBUTE.texture=load("res://BIBLIOTECA/CardSetup/Attribute/"+String(DA[8])+".png")
			$PROPERTIES.visible=false
			dynamic_font.font_data = load("res://Fonts/Yu-Gi-Oh! Matrix Book.ttf")
			$DESC.set("custom_fonts/normal_font", dynamic_font)
			$DESC.bbcode_text="[fill]"+String(DA[16])+"[/fill]"
			$ATK.visible=false
			$DEF.visible=false
			$DESC.rect_position.y=1176
			$DESC.rect_size.y=283
			$SPELLTRAP_TXT.visible=true
			if CardArray[9]=="Normal":
				$SPELLTRAP.visible=false
				$SPELLTRAP_TXT.bbcode_text="[right]["+String(CardArray[8]+" Card][/right]")
			else:
				$SPELLTRAP.visible=true
				$SPELLTRAP.texture=load("res://BIBLIOTECA/CardSetup/Type/"+String(DA[9])+".png")
				$SPELLTRAP_TXT.bbcode_text="[right]["+String(CardArray[8]+" Card   ][/right]")
#	var SP
	$SecretRare.visible=false
	var Gmc = GLOBAL.myCards
	num = int(Gmc[_O][0])
	$SecretRare.scale=Vector2(2.549,2.549)
	match CardArray[7]:
		"Common":
			rainbow(false)
			SP=null
		"Super Rare":
			rainbow(true)
			SP=null
		"Ultra Rare":
			rainbow(true)
			$NAME.set("custom_colors/default_color",URColor)
#			$NAME.get_font("normal_font").outline_size=5
			SP = preload("res://SCENE/GOLDEN_SHADER.tres")
		"Secret Rare":
			rainbow(true)
			$NAME.set("custom_colors/default_color",URColor)
#			$NAME.get_font("normal_font").outline_size=5
			SP = preload("res://SCENE/GOLDEN_SHADER.tres")
			$SecretRare.visible=true
			$SecretRare.texture=load('res://BIBLIOTECA/CardSetup/Rarity/Secret.png')
		"Prismatic Secret Rare":
			rainbow(true)
			$NAME.set("custom_colors/default_color",URColor)
#			$NAME.get_font("normal_font").outline_size=5
			SP = preload("res://SCENE/GOLDEN_SHADER.tres")
			$SecretRare.scale=Vector2(1.95,1.34)
			$SecretRare.visible=true
			$SecretRare.texture=load('res://BIBLIOTECA/CardSetup/Rarity/Mosaic.png')
		_:
			rainbow(true)
			$NAME.set("custom_colors/default_color",URColor)
#			$NAME.get_font("normal_font").outline_size=5
			SP = preload("res://SCENE/GOLDEN_SHADER.tres")
			$SecretRare.visible=true
	$NAME.set_material(SP)
	visibleArray=[$SecretRare.visible,$BG.visible,$ATTRIBUTE.visible,$LV1.visible,$SPELLTRAP_TXT.visible,$PROPERTIES.visible,$DESC.visible,$ATK.visible,$DEF.visible,$SET.visible,$NAME.visible]


var downloading=false
var downloading_ID
func loadIllustration(newID):
	var ID_ARRAY = GLOBAL._get_DATABASE_lineArray_by_ID(newID)
	var IMG_URL = ID_ARRAY[18]
	ID = newID
	if(String(GLOBAL.storedPics[ID])!=IMG_URL and downloading==false): #Verifica se houve alteração do link
		downloading=true
		downloading_ID=ID
		GLOBAL.storedPics[ID]=IMG_URL
		$Illustration.texture=load("res://BIBLIOTECA/downloading.jpg") 
		var http_error = http_request.request(IMG_URL)
		if http_error != OK:
			print("An error occurred in the HTTP request.")
			downloading=false
			$Illustration.texture=load("res://BIBLIOTECA/erro.jpg")
	elif(String(GLOBAL.storedPics[ID])!=IMG_URL and downloading==true): #
		$Illustration.texture=load("res://BIBLIOTECA/tryagain.jpg") 
	elif(GLOBAL.storedPics[ID]==IMG_URL):
		var texture = ImageTexture.new()
		var image = Image.new()
		var file = File.new()
		if file.file_exists("user://cards_ID_"+String(ID)+".png"):
			image.load("user://cards_ID_"+String(ID)+".png")
			texture.create_from_image(image)
			$Illustration.texture=texture
		elif (downloading==true):
			$Illustration.texture=load("res://BIBLIOTECA/tryagain.jpg") 
		else:
			GLOBAL.storedPics[ID]="0"
			$Illustration.texture=load("res://BIBLIOTECA/tryagain1.jpg") 
	else:
		print("loadIllustration resultou em ELSE!!!!!!")
		$Illustration.texture=load("res://BIBLIOTECA/404.png") 

func _http_request_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	var JPG_or_PNG=true
	downloading=false
	if image_error != OK:
		print("An error occurred while trying to display the PNG image.")
		image_error = image.load_jpg_from_buffer(body)
		if(image_error != OK):
			$Illustration.texture=load("res://BIBLIOTECA/erro.jpg")
			JPG_or_PNG=false
			print("An error occurred while trying to display the JPG image.")
	if JPG_or_PNG==true:
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		image.save_png("user://cards_ID_"+String(downloading_ID)+".png")
		GLOBAL.SaveLoadStoredPics("save")
		if(downloading_ID==ID):
			$Illustration.texture=texture

func grayscale(bool_key):
	#var SP 
	if bool_key and bool(GLOBAL.myConfs[0]):
		SP = preload("res://SCENE/GRAYSCALE_SHADER.tres")
		SP1 = preload("res://SCENE/GRAYSCALE_SHADER.tres")
	else:
		SP = null
	$Illustration.set_material(SP1)
	#$NAME.set_material(SP)
	$BG.set_material(SP)
	$ATTRIBUTE.set_material(SP1)
	$SPELLTRAP.set_material(SP)
	$LV1.set_material(SP)
	var i = 2;
	while i<=12:
		get_node("LV1/LV"+String(i)).set_material(SP)
		i+=1

func rainbow(bool_key): # CARD - UpdateNum()
#	var SP
#	if bool_key and bool(GLOBAL.myConfs[0]):
	if bool_key:
		SP1 = preload("res://SCENE/RAINBOW_SHADER.tres")
	else:
		SP1=null
	$Illustration.set_material(SP1)
	$ATTRIBUTE.set_material(SP1)
	$LV1.set_material(SP1)
	var i = 2;
	while i<=12:
		get_node("LV1/LV"+String(i)).set_material(SP1)
		i+=1
#	SP = preload("res://SCENE/RAINBOW_SHADER.tres")





var visibleArray=[]

func showIMGonly(ToF):
	if ToF:
		$SecretRare.visible=false
		$BG.visible=false
		$ATTRIBUTE.visible=false
		$LV1.visible=false
		$SPELLTRAP_TXT.visible=false
		$PROPERTIES.visible=false
		$DESC.visible=false
		$ATK.visible=false
		$DEF.visible=false
		$SET.visible=false
		$NAME.visible=false
		rainbow(false)
	else:
		$SecretRare.visible=visibleArray[0]
		$BG.visible=visibleArray[1]
		$ATTRIBUTE.visible=visibleArray[2]
		$LV1.visible=visibleArray[3]
		$SPELLTRAP_TXT.visible=visibleArray[4]
		$PROPERTIES.visible=visibleArray[5]
		$DESC.visible=visibleArray[6]
		$ATK.visible=visibleArray[7]
		$DEF.visible=visibleArray[8]
		$SET.visible=visibleArray[9]
		$NAME.visible=visibleArray[10]
		if DA[7]!="Common":
			rainbow(true)
