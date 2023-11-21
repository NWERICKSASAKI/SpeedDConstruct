extends RichTextLabel

onready var GLOBAL = get_node("/root/GLOBAL")

func _ready():
	bbcode_enabled=true
	$TouchScreenButton.connect("released",self,"goto")
	if(GLOBAL.theresUpdate):
		bbcode_text="[right]TEM ATUALIZAÇÃO =D\nTouch Here ÓwÒ[/right]"
		$TouchScreenButton.connect("released",self,"goto")
		var shader = preload("res://SCENE/GOLDEN_SHADER.tres")
		set_material(shader)
	else:
		bbcode_text="[right]Your app is uptodate  ÚwÙ[/right]"



func goto():
	OS.shell_open("https://nwericksasaki-sdc-hmtl5.netlify.app/APK/SpeedDConstructor.apk")
