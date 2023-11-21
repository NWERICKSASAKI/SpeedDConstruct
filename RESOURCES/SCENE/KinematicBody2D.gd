extends KinematicBody2D

var can_grab = false
var grabbed_offset = Vector2()
var original_pos = 0
var a_off=false
var ID = 9999
var SetAi
var HTTPRequest1 = HTTPRequest.new()
var link1

func _ready():
	add_child(HTTPRequest1)
	HTTPRequest1.connect("request_completed", self, "_http_request_completed")
	original_pos = position.y
	set_process(false)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()
		a_off=false
		set_process(true)


func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position.y = get_global_mouse_position()[1] + grabbed_offset[1]
	else:
		a_off=true
	if position.y>200 and a_off==false:
		get_parent().GO2SET(ID)
		a_off=true
	elif position.y>original_pos:
		position.y-=2500*delta
	elif position.y<original_pos:
		position.y = original_pos
	elif a_off:
		set_process(false)
		print("KinematicBody2D / set_process(false)")


var texture = ImageTexture.new()
var image = Image.new()
var file = File.new()

func loadIllustration(SetAi1):
	SetAi=SetAi1
	if file.file_exists("user://SET_"+String(SetAi)+".png"):
		image.load("user://SET_"+String(SetAi)+".png")
		texture.create_from_image(image)
		$Sprite.texture=texture
	else:
		$Sprite.texture=load("res://BIBLIOTECA/downloading.jpg")
		var link = "http://nwericksasaki-sdc-hmtl5.netlify.app/img/"+String(SetAi)+".png"
		print(link)
		link1 = "user://SET_"+String(SetAi)+".png"
		#link ="https://ms.yugipedia.com//thumb/e/ed/SGX2-BoxEN.png/257px-SGX2-BoxEN.png"
		var http_error = HTTPRequest1.request(link)
		if http_error != OK:
			print("An error occurred in the SET HTTP request.")
			$Sprite.texture=load("res://BIBLIOTECA/erro.jpg")

func _http_request_completed(_result, _response_code, _headers, body):
	print("_http_request_completed - carregou uma imagem de SET")
	image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the SET image.")
		$Sprite.texture=load("res://BIBLIOTECA/erro.jpg")
	else:
		texture.create_from_image(image)
		image.save_png(link1)
		$Sprite.texture=texture

