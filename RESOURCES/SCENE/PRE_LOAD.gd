extends Container

onready var GLOBAL = get_node("/root/GLOBAL")
var DatabaseUpdated=0 # (-1 falhou ao conectar ; 0 conectando ; +1 conectou)
var AppUpdateCheck=0
var DecksUpdateCheck=0
onready var theresUpdate=get_node("/root/GLOBAL").theresUpdate
onready var shader = preload("res://SCENE/GOLDEN_SHADER.tres")

func _ready():
	$VERSION_TXT.bbcode_text="[center]"+GLOBAL.VERSAO+"[/center]"
	$TXT1.bbcode_enabled=true
	$ContinueButton.connect("pressed",self,"changeScene") # coloquei pra nao dar erro quanddo chamar o disconect
	$RetryButton.connect("pressed",self,"_start")
	$HTTPRequest.connect("request_completed", self, "_on_http_request_completed_database")
	$HTTPRequest2.connect("request_completed", self, "_on_http_request_completed_AppLog")
	$HTTPRequest3.connect("request_completed", self, "_on_http_request_completed_sampleDecks")
	_start()



func _start(): # sim, ele se reinicia quando der falha de conexão
	$ContinueButton.disconnect("pressed",self,"changeScene") # coloquei pra nao dar erro ao chamar conect varias vezes
	$RetryButton.disconnect("pressed",self,"_start")
	$TXT1.bbcode_text="[center]C h e c k i n g    f o r   u p t a d e s\n&\nL o a d i n g . . .[/center]"
	$VERSION_TXT2.bbcode_text=""
	$CONTINUE_TXT.visible=false
	
	$HTTPRequest.set_download_file("user://SDCdatabase1.csv")
	var error = $HTTPRequest.request("https://nwericksasaki-sdc-hmtl5.netlify.app/SDCdatabase.csv")  # verifica atualização de Database
	if error != OK: # caso nao conseguir conectar
		print("GLOBAL / _start / erro no HTTPRequest da database")
		DatabaseUpdated=-1
		$TXT1.bbcode_text="[center] Erro ao conectar [/center]"
		loadDataBase()
	
	var error2 = $HTTPRequest2.request("https://nwericksasaki-sdc-hmtl5.netlify.app/log.txt")  # verifica atualização de versão do app
	if error2 != OK: # caso nao conseguir conectar
		print("GLOBAL / _start / erro no HTTPRequest do log")
		$VERSION_TXT2.bbcode_text="[center]Erro: Sem permissão para conexão[/center]"
		AppUpdateCheck=-1


func _on_http_request_completed_database(_result, _response_code, _headers, _body):
	var dir = Directory.new()
	print("PRE_LOAD / _on_http_request_completed_database / feito download da database")
	$TXT1.bbcode_text="[center] Download da Database realizado com sucesso [/center]"
	var file = File.new()
	if(!file.file_exists("user://SDCdatabase1.csv")): # quando não fizer o download / nao conseguir conectar
		DatabaseUpdated=-1
	else:
		var doFileExist = file.file_exists("user://SDCdatabase.csv")
		if !doFileExist:
			print("PRE_LOAD / _on_http_request_completed_database/  nao existia database, criando uma nova")
			$TXT1.bbcode_text="[center] Criando uma nova Database [/center]"
			dir.rename("user://SDCdatabase1.csv","user://SDCdatabase.csv") #deleta o antigo database & renomeia o novo arquivo
			#loadDataBase()
		else:# database ja existe, verifica se tem diferença de tamanho (possivel atualizacao)
			DatabaseUpdated=1
			file.open("user://SDCdatabase.csv", file.READ)
			if ($HTTPRequest.get_body_size() == file.get_len() ): #caso tamanho dos arquivos for igual = atualizado
				print("PRE_LOAD / _on_http_request_completed_database / database tamanho igual / $HTTPRequest.get_body_size()="+String($HTTPRequest.get_body_size()))
				$TXT1.bbcode_text="[center] Database atualizada [/center]"
				file.close()
				dir.remove("user://SDCdatabase1.csv")
			elif($HTTPRequest.get_body_size()<100000):
				$TXT1.bbcode_text="[center] Possível problema com o servidor/hospedagem [/center]"
				file.close()
				dir.remove("user://SDCdatabase1.csv")
			else: # tamanho difente, entao precisa atualizar
				print("PRE_LOAD / _on_http_request_completed_database / database tamanho diferente")
				$TXT1.bbcode_text="[center] Realizando atualização da Database [/center]"
				file.close()
				if (file.file_exists("user://SDCdatabase1.csv")):
					dir.rename("user://SDCdatabase1.csv","user://SDCdatabase.csv") #deleta o antigo database & renomeia o novo arquivo
	loadDataBase()

func loadDataBase():
	var newDATABASE=[]
	var file = File.new()
	if file.file_exists("user://SDCdatabase.csv"):
		file.open("user://SDCdatabase.csv", file.READ)
		while (!file.eof_reached()):
			newDATABASE.append(file.get_csv_line ())
		file.close()
	else:
		print("ARQUIVO NAO ENCONTRADO")
		$TXT1.bbcode_text="[center] ERRO, NÃO FOI POSSIVEL ACESSAR DATABASE [/center]"
	GLOBAL.DATABASE=newDATABASE
	print("PRE_LOAD / loadDataBase / finishes loadDataBase()")
	GLOBAL.checkIfNewUser()
	$TXT1.bbcode_text="[center] Carregando e atualizando Decks [/center]"
	loadingMyDecks()
	verify_others_updates()

func changeScene():
	get_tree().change_scene("res://SCENE/MAIN.tscn")
	$CONTINUE_TXT.bbcode_text="[center]Era pra ter ido pro menu principal ja [mas se tocar aqui faz uma nova tentativa][/center]"

func changeScene2log():
	get_tree().change_scene("res://SCENE/UPDATE_LOG.tscn")

func _on_http_request_completed_AppLog(_result, _response_code, _headers, body):
	var NEW_LOG_TXT = body.get_string_from_utf8()
	if(NEW_LOG_TXT.length()==0):
		$VERSION_TXT2.bbcode_text="[center]Failed to connect and check for app's updates[/center]"
		AppUpdateCheck=-1
	else:
		AppUpdateCheck=1
		var i = 0
		while i<=13:
			if(i==13): # os primeiros 14 digitos do LOG.RES for igual ao GLOBAL.VERSAO, então ta atualziado
				$VERSION_TXT2.bbcode_text="[center]Current version is uptodate[/center]"
				i=14
				theresUpdate=false
			elif(NEW_LOG_TXT[i]==GLOBAL.VERSAO[i]):
				i+=1
			else:
				i=14
				theresUpdate=true
				$VERSION_TXT2.bbcode_text="[center]A new version was pressed\nTouch Here to acess log & download[/center]"
				$VERSION_TXT2.set_material(shader)
				GLOBAL.theresUpdate=true
	GLOBAL.LOG_TXT=NEW_LOG_TXT
	verify_others_updates()

func verify_others_updates():
#	DecksUpdateCheck = GLOBAL.DecksUpdateCheck
	if(DatabaseUpdated==1 and AppUpdateCheck==1 and DecksUpdateCheck==1): # todas as verificações de uptades foram um sucesso
		$CONTINUE_TXT.visible=true
		$CONTINUE_TXT.bbcode_text="[center]Update's check is completed[/center]"
		$ContinueButton.connect("pressed",self,"changeScene")
		$updateButton.connect("pressed",self,"changeScene2log")
		if (theresUpdate):
			
			$CONTINUE_TXT.bbcode_text="[center]Click here to proceed to main menu[/center]"
		else:
			changeScene()
	elif(DatabaseUpdated==0 or AppUpdateCheck==0 or DecksUpdateCheck==0):  # alguma verificação ainda não terminou
		$CONTINUE_TXT.bbcode_text="[center]Still checking for updates...[/center]"
	else: # alguma verificação falhou
		$TXT1.bbcode_text="[center] Unable to connect to check for database's updates \n Touch here to try again \n or [/center]"
		$CONTINUE_TXT.bbcode_text="[center]Click here to proceed to main menu[/center]"
		$ContinueButton.connect("pressed",self,"changeScene")
		$updateButton.connect("pressed",self,"changeScene2log")





var saveMyDecksFile="user://myDecks.Dsave"
var _myDecks

func loadingMyDecks(): #chanado pelo CheckifNewUser
	_myDecks=GLOBAL._myDecks
	DecksUpdateCheck = 0
	var F = File.new()
	if F.file_exists(saveMyDecksFile):
		F.open(saveMyDecksFile, File.READ)
		var myNewDecks = F.get_var()
#		myDecks = F.get_var()
		F.close()
		print("PRE_LOAD / loadingMyDecks() / file exist")
		if typeof(myNewDecks)!=TYPE_ARRAY: # se save corrompido
			print("myDecks save corrompido")
			updateSampleDecks() # myCards=[[0,3,1]]
		else:
			print("PRE_LOAD / loadingMyDecks / tudo certo")
			GLOBAL._myDecks = myNewDecks
			print("PRE_LOAD / loadingMyDecks / _myDecks com valor ")
			DecksUpdateCheck=1
	else:
		print("PRE_LOAD / loadingMyDecks() / myDecks.Dsave file DOES NOT exist")
		updateSampleDecks()


func updateSampleDecks():
	print("PRE_LOAD / updateSampleDecks")
	DecksUpdateCheck = 0
	$HTTPRequest3.set_download_file("user://SDCsampleDecks1.csv")
	var error = $HTTPRequest3.request("https://nwericksasaki-sdc-hmtl5.netlify.app/SDCdecks.csv")  # verifica atualização de Database
	if error != OK: # caso nao conseguir conectar
		print("PRE_LOAD / updateSampleDecks / Erro ao conectar")
		DecksUpdateCheck = -1
		GLOBAL.updateSampleDecks1()
		verify_others_updates()

func _on_http_request_completed_sampleDecks(_result, _response_code, _headers, _body):
	print("PRE_LOAD / _on_http_request_completed_sampleDecks")
	var dir = Directory.new()
	var file = File.new()
	if(!file.file_exists("user://SDCsampleDecks1.csv")): # quando não fizer o download / nao conseguir conectar
		print("PRE_LOAD / _on_http_request_completed_sampleDecks / acusou ter baixado mas arquivo nao foi encontrado")
		DecksUpdateCheck = -1
	else:
		print("PRE_LOAD / _on_http_request_completed_sampleDecks / encontrado SDCsampleDecks1.csv")
		var doFileExist = file.file_exists("user://SDCsampleDecks.csv")
		if !doFileExist:
			print("PRE_LOAD / _on_http_request_completed_sampleDecks/  nao existia sampleDecks, criando uma nova")
			dir.rename("user://SDCsampleDecks1.csv","user://SDCsampleDecks.csv") #deleta o antigo database & renomeia o novo arquivo
			GLOBAL.updateSampleDecks1()
		else:# database ja existe, verifica se tem diferença de tamanho (possivel atualizacao)
			file.open("user://SDCsampleDecks.csv", file.READ)
			if ($HTTPRequest3.get_body_size() == file.get_len() ): #caso tamanho dos arquivos for igual = atualizado
				print("PRE_LOAD / _on_http_request_completed_sampleDecks / myDecks tamanho igual / HTTP_REQUEST.get_body_size()="+String($HTTPRequest3.get_body_size()))
				file.close()
				dir.remove("user://SDCsampleDecks1.csv")
				GLOBAL.updateSampleDecks1()
			elif($HTTPRequest3.get_body_size()<20000):
				print("PRE_LOAD / _on_http... / arquivo baixado muito leve ALERTA")
				file.close()
				dir.remove("user://SDCsampleDecks1.csv")
			else: # tamanho difente, entao precisa atualizar
				print("PRE_LOAD / _on_http_request_completed_sampleDecks / database tamanho diferente")
				file.close()
				if (file.file_exists("user://SDCsampleDecks1.csv")):
					dir.rename("user://SDCsampleDecks1.csv","user://SDCsampleDecks.csv") #deleta o antigo database & renomeia o novo arquivo
					GLOBAL.updateSampleDecks1()
		DecksUpdateCheck = 1
	verify_others_updates()
#	get_tree().get_current_scene().remove_child(HTTP_REQUEST)
