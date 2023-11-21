extends RichTextLabel

onready var GLOBA = get_node("/root/GLOBAL")

func _ready():
	if bool(get_node("/root/GLOBAL").myConfs[6])==true:
		visible=true
	print(get_node("/root/GLOBAL").myConfs[7])
	if get_node("/root/GLOBAL").myConfs[7] is int or get_node("/root/GLOBAL").myConfs[7]=="":
		bbcode_text="[center] Finge que seu nome tá aqui -q mas você pode editar nas configurações, tá?"
	else:
		bbcode_text="[center]"+get_node("/root/GLOBAL").myConfs[7]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
