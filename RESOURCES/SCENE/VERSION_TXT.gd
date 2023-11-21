extends RichTextLabel

onready var GLOBAL = get_viewport().get_node("/root/GLOBAL")

func _ready():
#	bbcode_enabled=true
	bbcode_text=String(GLOBAL.VERSAO)
