shader_type spatial;

uniform sampler2D noise;

varying vec3 vtx;

void vertex() {
  vtx = VERTEX;
}

void fragment()
{
	float division = 200.0;
	float noise_val = texture(noise, vec2(float(int(UV.x*division))/division,float(int(UV.y*division))/division)).x;
	vec3 copper = vec3(0xD2,0x7E,0x62)/(255.0);
	vec3 onyx = vec3(0x35,0x3b,0x3c)/(255.0);
	
	ALBEDO = copper;
	if (noise_val > 0.6)
	{
		ALBEDO = onyx;
	}
}