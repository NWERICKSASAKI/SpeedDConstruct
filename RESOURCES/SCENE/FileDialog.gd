extends Node2D

var file
var mode = 0
var opos

func _ready():
	set_process(false)
	visible=true
	$IMPORT.connect("pressed",self,"IMPORT")
	$EXPORT.connect("pressed",self,"EXPORT")
	$FileDialog.connect("popup_hide",self,"CLOSE")
	$FileDialog.access=FileDialog.ACCESS_FILESYSTEM
	$FileDialog.set_filters(PoolStringArray(["*.save ; SAVE DATA"]))
	$FileDialog.connect("file_selected",self,"_CONFIRMED")


func _DEFAULT():
	set_process(true)
	OS.request_permissions()
	get_viewport().get_node("COLLECTION/LOGO").visible=false
	get_viewport().get_node("COLLECTION/AA").visible=false
	get_viewport().get_node("COLLECTION/TOP_MENU").visible=false
	$FileDialog.popup(Rect2(110,140,1700/2,(1080-280)/2))
	opos=$FileDialog.rect_position
	$FileDialog.set_current_dir("/storage/emulated/0/Download/")
	$FileDialog.set_current_path("/storage/emulated/0/Download/")

func IMPORT():
	_DEFAULT()
	mode = "load"
	$FileDialog.mode=FileDialog.MODE_OPEN_FILE
	$FileDialog.window_title="Choose a file to replace your collection"

func EXPORT():
	_DEFAULT()
	mode = "save"
	$FileDialog.mode=FileDialog.MODE_SAVE_FILE
	$FileDialog.window_title="Save your exported data"

func CLOSE():
	get_viewport().get_node("COLLECTION/LOGO").visible=true
	get_viewport().get_node("COLLECTION/AA").visible=true
	get_viewport().get_node("COLLECTION/TOP_MENU").visible=true
	set_process(false)
	$FileDialog.rect_position.y=opos[1]


func _CONFIRMED(path):
	var f = File.new()
	match mode:
		"save":
			f.open(path, File.WRITE)
			f.store_var(GLOBAL.myCards)
			f.close()
			$TXT.bbcode_text="[center]EXPORT COMPLETED"
		"load":
			if path.get_extension() == "save":
				f.open(path, File.READ)
				var newSave = f.get_var()
				f.close()
				if newSave is Array:
					GLOBAL.myCards = newSave
					GLOBAL.savingMyCards()
					$TXT.bbcode_text="[center]YOUR NEW COLLECTION IS READY"
				else:
					$TXT.bbcode_text="[center]ERROR: THIS FILE IS CORRUPTED :("
			else:
				$TXT.bbcode_text="[center]ERROR: TRY A .save FILE FORMAT"
	mode = 0

func _process(_delta):
	#print( $FileDialog.get_focus_owner().rect_pivot_offset)
	var FocusY = $FileDialog.get_focus_owner().get_global_position()[1]
	if ($FileDialog.get_focus_owner().get_class()=="LineEdit"):
		if  FocusY > ProjectSettings.get_setting("display/window/size/height")-OS.get_virtual_keyboard_height():
			$FileDialog.rect_position.y=opos[1]-OS.get_virtual_keyboard_height()
	else:
		$FileDialog.rect_position.y=opos[1]
