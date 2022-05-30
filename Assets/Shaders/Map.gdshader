shader_type canvas_item;
render_mode blend_mix;
uniform vec2 coords;

vec4 blend_color(vec4 colorRGBA1, vec4 colorRGBA2){
	float alpha = 255.0 - ((255.0 - colorRGBA1.a) * (255.0 - colorRGBA2.a) / 255.0);
    float red   = (colorRGBA1.r * (255.0 - colorRGBA2.a) + colorRGBA2.r * colorRGBA2.a) / 255.0;
    float green = (colorRGBA1.g * (255.0 - colorRGBA2.a) + colorRGBA2.g * colorRGBA2.a) / 255.0;
    float blue  = (colorRGBA1.b * (255.0 - colorRGBA2.a) + colorRGBA2.b * colorRGBA2.a) / 255.0;
    return vec4(red,green,blue,alpha);
}


void fragment(){
    //vec4 A = texture(TEXTURE, UV);
	//vec4 B = vec4(126.0, 100.0, 29.0, 0.5);
	//vec4 B = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	//B.a = 0.1;
	
	
	//vec4 new = blend_color(A, B);
	//new.a = A.a * B.a;
	
	vec4 A = texture(TEXTURE, UV);
	vec4 B = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	B.a = 0.4;
	vec4 C = blend_color(A, B);
	//C.a = A.a * (B.a - 1.0);
	C.a = (A.a + 0.1 ) * (B.a - 0.0);
	COLOR = C;
	//COLOR = B;
}