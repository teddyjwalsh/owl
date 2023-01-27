

shader_type spatial;

uniform sampler2D noise;
uniform float angle = -0.3;
uniform float position = -0.2;
uniform float spread : hint_range(0.0, 1.0) = 0.5;

varying vec3 vtx;

void vertex() {
  vtx = VERTEX;
}

void fragment()
{
	float ring_start = 0.75;
	float ring_end = 1.0;
	float radial_width = ring_end - ring_start;
	float l = length(vtx);
	float radial_proximity = (l - (ring_end + ring_start)/2.0)/(radial_width/2.0);
	radial_proximity = 1.0 - pow(radial_proximity,2);
	float val = texture(noise, vec2(UV.x*radial_proximity, UV.y*sin(TIME))).x*1.0*radial_proximity;
	if (val > 0.3)
	{
		ALPHA = 1.0
	}
	else
	{
		ALPHA = 0.0;
	}
	vec3 out_col = vec3(0.3,1.0,0.4);
	ALBEDO = texture(noise, vec2(UV.x*radial_proximity, UV.y*TIME/1999.0)).x*out_col;
	EMISSION = out_col;
	
}