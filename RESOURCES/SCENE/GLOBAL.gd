extends Node

var myCards=[[0,3,1]] #owned / wanted / fav_tier
var EachCardSaveSize = 3

var _myDecks=[[[0,"",""]],[[]]] # [Custom/Sample]

var DATABASE = []
var CustomFilter = []
var myConfs=[]
var WT = 0
var lock = true
var storedPics = ["a"] # [IMG_URL]

var which_DeckID
var which_DeckArray

const VERSAO="[b]V0.4.07[/b]" ############### TODA VEZ QUE FOR PUBLICAR UMA VERSÃO ATUALIZADA DO APK ALTERAR ESSA CONSTANTE (E NO LOG.TXT)
var LOG_TXT="" #texto do log.txt
var theresUpdate=false

var MAX_ATK = 0
var MAX_DEF = 0

func _ready():
	set_process(false)
	EachCardSaveSize=myCards[0].size()
	var f = false
	_load_conf()
	CustomFilter = [f]
	while CustomFilter.size()!=20:
		CustomFilter.append(f)

func checkIfNewUser():
	print("GLOBAL / checkIfNewUser()")
	loadingMyCards()
	SaveLoadStoredPics("load")
	_setMaxATKDEF()

func _setMaxATKDEF(): # para ser utilizado no SLIDER
	print("GLOBAL / _setMaxATKDEF()")
	var i = 1
	var ATK_ARRAY=[]
	var DEF_ARRAY=[]
	while (i<DATABASE.size()-1):
		ATK_ARRAY.append(int(DATABASE[i][14]))
		DEF_ARRAY.append(int(DATABASE[i][15]))
		i+=1
	MAX_ATK = int(ATK_ARRAY.max())
	MAX_DEF = int(DEF_ARRAY.max())

func SaveLoadStoredPics(command):
	var PicsFile="user://storedPics.txt"
	var F = File.new()
	if(command=="load"):
		if F.file_exists(PicsFile):
			F.open(PicsFile, File.READ)
			storedPics = F.get_var()
			F.close()
		elif typeof(storedPics)!=TYPE_ARRAY:
			storedPics=["a"]
		while(storedPics.size()<DATABASE.size()):
			storedPics.append(["a"])
	command="save"
	if(command=="save"):
		F.open(PicsFile, File.WRITE)
		F.store_var(storedPics)
		F.close()

#	http_request.connect("request_completed", self, "_http_request_completed")



func LFID(path): #List File in Directory
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files



# N E W !
#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18    19
# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG,LIMIT]
func FILTER(Filter): # Filter=[f,f,f,f,f,f...]
	print("GLOBAL / FILTER")
	var FilteredCardsArray = DATABASE.duplicate(true)
	FilteredCardsArray.remove(0) # remove LINHA 1 (CABEÇALHO)
	var i=0 # LINHA
	var j=0 # COLUNA
	while i<FilteredCardsArray.size():
		j=0
		while j<Filter.size():
			var AID = int(FilteredCardsArray[i][1]) # Actual ID
			if (Filter[j] is bool):
				j+=1
			#SEPARAR CARTAS PARA WISHLIST / TRADABLE
			elif j == 0:
				var _O = int(FilteredCardsArray[i][1]) # ID
#				match FilteredCardsArray[i][7]: #rarity
#					"Super Rare":
#						rar=1
#					"Ultra Rare":
#						rar=2
				if GLOBAL.WT==1: #TRADABLE | QTD
					if(myCards[_O][0]>myCards[_O][1]):
						j+=1
					else:
						FilteredCardsArray.remove(i)
						j=Filter.size()
						i-=1
				elif GLOBAL.WT==-1: #WISHLIST
					if(myCards[_O][0]<myCards[_O][1]):
						j+=1
					else:
						FilteredCardsArray.remove(i)
						j=Filter.size()
						i-=1
				else:
					j+=1
			#SEPARA POR QTD
			elif j == 3: 
				if (int(myCards[AID][0]) >= Filter[j][0]) and (int(myCards[AID][0]) <= Filter[j][1]): #####################################
					j+=1
				else:
					FilteredCardsArray.remove(i)
					j=Filter.size()
					i-=1
			# Filtro pra ATK / DEF / LV
			elif j >= 13 and j<=15: # corrigido ne
				if (int(FilteredCardsArray[i][j]) >= Filter[j][0]) and (int(FilteredCardsArray[i][j]) <= Filter[j][1]):
					j+=1
				else:
					FilteredCardsArray.remove(i)
					j=Filter.size()
					i-=1
			# Filtro para FAVORITE
			elif j == 18: 
				if (int(myCards[AID][2]) >= Filter[j][0]) and (int(myCards[AID][2]) <= Filter[j][1]): #####################################
					j+=1
				else:
					FilteredCardsArray.remove(i)
					j=Filter.size()
					i-=1
			# Filtro para LIMIT
			elif j == 19: 
				if (int(FilteredCardsArray[i][j]) >= Filter[j][0]) and (int(FilteredCardsArray[i][j]) <= Filter[j][1]):
					j+=1
				else:
					FilteredCardsArray.remove(i)
					j=Filter.size()
					i-=1
			# Search for WORD
			elif j == 16: #descricao
				var TEXT_SEARCH = Filter[16].split(" ")
				var k = 0
				var MATCHES = 0 # variavel pra acumular os matches das palavras chaves para decidir se entra ou nao no filtro
				while (k<TEXT_SEARCH.size()):
					#SET
					if FilteredCardsArray[i][4].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
					#NAME
					elif FilteredCardsArray[i][6].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
					#TYPE1
					elif FilteredCardsArray[i][10].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
					#TYPE2
					elif FilteredCardsArray[i][11].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
#					#ATTRIBUTE
#					elif FilteredCardsArray[i][12].to_upper().find(TEXT_SEARCH[k])>=0:
#						MATCHES+=1
					#ATK
					elif FilteredCardsArray[i][14].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
					#DEF
					elif FilteredCardsArray[i][15].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
					#DESC1
					elif FilteredCardsArray[i][16].to_upper().find(TEXT_SEARCH[k])>=0:
						MATCHES+=1
					else:
						FilteredCardsArray.remove(i)
						j=Filter.size()
						i-=1
						k=TEXT_SEARCH.size()
					if(MATCHES==TEXT_SEARCH.size()):
						j+=1
						k=TEXT_SEARCH.size()
					k+=1
			
			elif FilteredCardsArray[i][j] == Filter[j]:
				j+=1
			else:
				FilteredCardsArray.remove(i)
				j=Filter.size()
				i-=1
		i+=1
	return FilteredCardsArray


##### SAVE E LOAD DO MY CARDS COLLECTION

var saveMyCardsFile="user://myCardsCollection.save"
func savingMyCards():
	print("GLOBAL / savingMyCards()")
	var f = File.new()
	f.open(saveMyCardsFile, File.WRITE)
	f.store_var(myCards)
	f.close()

func loadingMyCards(): #chanado pelo CheckifNewUser
	var F = File.new()
	if F.file_exists(saveMyCardsFile):
		F.open(saveMyCardsFile, File.READ)
		var myNewCards = F.get_var()
		F.close()
		print("GLOBAL / loadingMyCards() / file exist")
		if typeof(myNewCards)!=TYPE_ARRAY: # se save corrompido
			print("save corrompido")
			updateMyCards(2) # myCards=[[0,3,1]]
		elif(myNewCards[0].size()<myCards[0].size()): # se save desatualizado em relação a quantidade de colunas
			print("save com colunas menor do que era pra ser")
			updateMyCards(1) 
		elif(myNewCards.size()<DATABASE.size()): # se save desatualizado em relação a quantidade de linhas
			myCards = myNewCards # F.get_var()
			print("GLOBAL / loadingMyCards() / file outdated")
			print("GLOBAL / myCards.size()="+String(myCards.size())+" - "+"DATABASEsize()="+String(DATABASE.size()))
			updateMyCards(myCards.size())
		else:
			print("GLOBAL / loadingMyCards / tudo certo")
			myCards = myNewCards
	else:
		print("GLOBAL / loadingMyCards() / file DOES NOT exist")
		updateMyCards(2) # atualiza o save desde a linha 0 (2, porque se 0, pega yugipedia; se 1 pega o dark magician que é o default)
#	OS.set_clipboard(String(myCards))

# N E W !
#  0         1 2   3   4   5   6     7      8     9    10    11     12   13  14 15      16      17  18
# [YUGIPEDIA,0,ID,Qtd,SET,COD,Name,Rarity,CARD1,CARD2,TYPE1,TYPE2,Attrib,LV,ATK,DEF,DescEffect,Link,IMG]
func updateMyCards(CONTINUAR_DAQUI): # comeca atualizar a partir da ultima carta pra frente
	var i=CONTINUAR_DAQUI
	print("GLOBAL / updateMyCards( ",CONTINUAR_DAQUI," ) / DATABASE.size() = "+String(DATABASE.size()))
	while i<DATABASE.size():
		if DATABASE[i][0].length() <= 1: #se detectou uma linha vazia na Planilha DataBase
			print("GLOBAL / detectado vazio no i= "+String(i))
			i=DATABASE.size()
		elif(i>=myCards.size()): # se MyCards for menor que a database, adiciona uma linha 
			var sk = 0 # se for skill, 1 / resto 3
			match DATABASE[i][8]:
				"Skill":
					sk = 1
				_: 
					sk = 3
			myCards.append([0,sk,0])
		elif (DATABASE[i].size()<EachCardSaveSize): # encontrou uma linha com coluna a menos
			myCards[i].append(0)
		i+=1
	print("GLOBAL / updateMyCards() / myCards.size() = ",myCards.size()," var i = ",i)
	savingMyCards()



##### SAVE E LOAD DO MY DECKS


var DecksUpdateCheck=0



func updateSampleDecks1():
	print("GLOBAL / updateSampleDecks1")
	var newDECKS: Array = []
	var file = File.new()
	if file.file_exists("user://SDCsampleDecks.csv"):
		file.open("user://SDCsampleDecks.csv", file.READ)
		while (!file.eof_reached()):
			newDECKS.append(file.get_csv_line ())
		file.close()
	else:
		print("ARQUIVO NAO ENCONTRADO")
	
	# Trocar o nome das cartas pelos seus respectivos _O
	var i = 1
	print("GLOBAL / updateSampleDecks1 / iniciando troca de nomes por ID")
	while i<newDECKS.size():
		newDECKS[i][4]=String(_get_DATABASE_ID_by_name(newDECKS[i][4]))
		newDECKS[i][5]=String(_get_DATABASE_ID_by_name(newDECKS[i][5]))
		newDECKS[i][6]=String(_get_DATABASE_ID_by_name(newDECKS[i][6]))
		var j = 10
		while j<=60:
			newDECKS[i][j]=String(_get_DATABASE_ID_by_name(newDECKS[i][j]))
			j+=1
		i+=1
	
	_myDecks[1]=newDECKS
	print("GLOBAL /finishes updateSampleDecks1 / _myDecks com valor ")
	savingMyDecks()
	if(get_tree().get_current_scene()==get_tree().get_root().get_node("PRE_LOAD")):
		get_tree().get_current_scene().verify_others_updates()
	else:
		print("DEU RUIM")

var saveMyDecksFile="user://myDecks.Dsave"
func savingMyDecks():
	print("GLOBAL / savingMyDecks()")
	var f = File.new()
	f.open(saveMyDecksFile, File.WRITE)
	f.store_var(_myDecks)
	f.close()






######### C O N F I G U R A T I O N ##########
var ConfFile="user://myCustomConf.txt"

func default_conf():
	var A=[]#myConfsDefault
	
	A.resize(7+1)
	A[0]=1# grayscale
	A[1]=1# show number
	A[2]=0# text selection
	A[3]=1# SR UR Particles
	A[4]=0# if true: Show differece
	A[5]=1# Keep Text
	A[6]=1# Date n Name
	A[7]="What's your name?"
	return A

func _load_conf():
	print("GLOBAL / _load_conf")
	var F = File.new()
	#Se encontrar o arquivo de Conf salvo
	if F.file_exists(ConfFile):
		F.open(ConfFile, File.READ)
		var NEWmyConfs = F.get_var()
		F.close()
		while NEWmyConfs.size()<=default_conf().size():
			NEWmyConfs.append(1)
		myConfs=NEWmyConfs
	#Caso nao encontrar o arquivo
	else:
		myConfs=default_conf()
		_save_conf()

func _save_conf():
	print("GLOBAL / _save_conf")
	var F = File.new()
	F.open(ConfFile, File.WRITE)
	F.store_var(myConfs)
	F.close()

##################################

func _get_DATABASE_lineArray_by_ID(the_ID):
	var IDsLINE = 1
	if(int(the_ID)==-1):
		return false
	while int(DATABASE[IDsLINE][2])!=int(the_ID): # entrou em loop infinito CORRIGIR
		IDsLINE+=1
	var returnARRAY = [DATABASE[IDsLINE][0]]
	var i = 1
	while i<DATABASE[IDsLINE].size():
		returnARRAY.append(DATABASE[IDsLINE][i])
		i+=1
	return returnARRAY

func _get_DATABASE_ID_by_name(_CARD_NAME):
	var i = 0
	if(_CARD_NAME==""):
		return -1
	while i<DATABASE.size():
		if String(DATABASE[i][6])==String(_CARD_NAME):
			return int(DATABASE[i][2])
		i+=1
	print("GLOBAL / _get_DATABASE_ID_by_name / 404 NAME NOT FOUND =",String(_CARD_NAME))
	return -1
