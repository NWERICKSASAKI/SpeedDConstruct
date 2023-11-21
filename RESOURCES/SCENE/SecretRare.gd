extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var d=0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d += delta
	modulate=Color(1,1,1,0.60+sin(3*d)/4)
