shader_type canvas_item;

render_mode unshaded;

uniform int blurSize : hint_range(0,20); 

void fragment() 
{
COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, float(blurSize)/10.0).rgb; 
}

//uniform float amount : hint_range(0,5);
//
//void fragment() {
//
//	COLOR.rgb = textureLod(SCREEN_TEXTURE,SCREEN_UV,amount).rgb;
//}