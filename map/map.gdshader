shader_type spatial;

uniform sampler2D noise;

varying vec3 vtx;
varying vec3 norm;

void vertex() {
  vtx = VERTEX;
  norm = NORMAL;
}

void fragment()
{
	float division = 200.0;
	float noise_val = texture(noise, vec2(float(int(UV.x*division))/division,float(int(UV.y*division))/division)).x;
	vec3 copper = vec3(0xEE,0xC5,0x84)/(255.0);
	vec3 onyx = 2.5*vec3(0x35,0x3b,0x3c)/(255.0);
	
	ALBEDO = copper;
	if (noise_val > 0.6 || norm.y < 0.1)
	{
		ALBEDO = onyx;
	}
	ALPHA = min(1.0,(5.0 + vtx.y)/20.0);
}