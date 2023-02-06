shader_type spatial;

uniform sampler2D noise;
uniform sampler2D snow_noise;

varying vec3 vtx;
varying vec3 norm;
instance uniform int weather;

void vertex() {
  vtx = VERTEX;
  norm = NORMAL;
}

void fragment()
{
	float division = 200.0;
	float disc_noise_val = texture(noise, vec2(float(int(UV.x*division))/division,float(int(UV.y*division))/division)).x;
	float cont_noise_val = texture(noise, UV).x;
	vec3 copper = vec3(0xEE,0xC5,0x84)/(255.0);
	vec3 onyx = 2.5*vec3(0x35,0x3b,0x3c)/(255.0);
	
	ALBEDO = copper;
	if (disc_noise_val > 0.6 || norm.y < 0.1)
	{
		ALBEDO = onyx;
	}
	ALPHA = min(1.0,(5.0 + vtx.y)/20.0);
	
	if (weather == 1)
	{
		if (cont_noise_val > 0.7 || norm.y < 0.1)
		{
			ALBEDO = vec3(1.0,1.0,1.0);
			//ROUGHNESS = 0.7;
			NORMAL = texture(snow_noise,UV*100.0).rgb + vec3(0,1,0);
		}
	}
	else if (weather == 2)
	{
		if (cont_noise_val > 0.7 || norm.y < 0.1)
		{
			ALBEDO = vec3(0.2,0.4,0.2);
			//ROUGHNESS = 0.7;
			NORMAL = vec3(0,1,0);
			METALLIC = 1.0;//texture(snow_noise,UV*100.0).r;
		}
		else if (disc_noise_val > 0.6 || norm.y < 0.1)
		{
			NORMAL = texture(snow_noise,UV*20.0).rgb + vec3(0,1,0);
			METALLIC = 0.6;//texture(snow_noise,UV*100.0).r;
		}
		else
		{
			NORMAL = texture(snow_noise,UV*1000.0).rgb + vec3(0,1,0);
			METALLIC = 0.4;//texture(snow_noise,UV*100.0).r;
		}
	}
}