shader_type canvas_item;
render_mode unshaded;

uniform bool grayscale = false;

void fragment() {
	if (grayscale) {
		COLOR = texture(TEXTURE, UV);//setup the default image 
		float lum = (COLOR.r+COLOR.g+COLOR.b)/3.0;//get the average 
		COLOR.xyz = vec3(lum);//set the average to get grayscale 
	}
	else{
	COLOR = texture(TEXTURE, UV)
	}
}