extends RichTextLabel

onready var GLOBAL = get_node("/root/GLOBAL")

func _ready():
	bbcode_enabled=true
	visible_characters=0
	bbcode_text=GLOBAL.LOG_TXT
	var NC = self.text.length() #Numero de caracteres
	var t = float(NC)/1000 #caracteres/milisegundos (quanto tempo em segundos vai levar pra carregar tudo)
	$Tw.interpolate_property(self,"visible_characters", 0, NC, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tw.start()
