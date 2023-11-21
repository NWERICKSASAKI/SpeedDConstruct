extends RichTextLabel

func _ready():
	visible=false
	if bool(get_node("/root/GLOBAL").myConfs[6])==true:
		visible=true
	var time = OS.get_date()
	var d = String(time["day"])
	if d.length()==1:
		d="0"+d
	var m = String(time["month"])
	if m.length()==1:
		m="0"+m
	text = String(time["day"])+"/"+m+"/"+String(time["year"])

