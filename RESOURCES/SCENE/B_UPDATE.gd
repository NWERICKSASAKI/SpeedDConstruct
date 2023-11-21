extends TouchScreenButton


func _ready():
	connect("released",self,"goto")

	var file = File.new()
	var webfile = File.new()
	if file.file_exists("https://nwericksasaki-sdc-hmtl5.netlify.app/log.res"):
		file.open("res://others/log.res", file.READ)
		$UPDATE_TXT.text = file.get_as_text()
		file.close()
	else:
		$UPDATE_TXT.text="ERROR: Version not found! D:"

func goto():
	OS.shell_open("https://nwericksasaki-sdc-hmtl5.netlify.app/SpeedDConstructor.apk")
