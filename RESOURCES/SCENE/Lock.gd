extends CheckBox

onready var GLOBAL = get_node("/root/GLOBAL")

func _ready():
	connect("pressed",self,"pressed_b")
	update_alpha()
	visible=false
	if(GLOBAL.WT==0):
		visible=true

func pressed_b():
	GLOBAL.lock = pressed
	update_alpha()

func update_alpha():
	if pressed:
		modulate=Color(1,1,1,1)
	else:
		modulate=Color(1,1,1,0.5)

func blinkAnimation():
	get_parent().get_node("Tw").interpolate_property(self,"modulate", Color(0,0,0,0), Color(1,1,1,1), 0.25, Tween.TRANS_SINE, Tween.EASE_IN)
	get_parent().get_node("Tw").start()
