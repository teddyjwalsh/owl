shader_type spatial;
//render_mode unshaded;

uniform sampler2D noise;
varying vec3 local_pos;
varying vec3 normal;

void vertex()
{
	local_pos = VERTEX;
	normal = NORMAL;
}

void fragment() 
{

	float max_height = 2.0;
	ALPHA = pow(max(0, max_height - (local_pos.y + 1.0))/max_height,2);
	ALBEDO = vec3(0.0, 0.9, 0.2);// + vec3(1.0, 1.0, 1.0)*pow(max(0, max_height - (local_pos.y + 1.0))/max_height,4);
	float coord = UV.y*float(int(local_pos.x*100.0*sin(TIME))/100)*0.5;
	EMISSION = vec3(0.0,3.0*texture(noise, vec2(UV.x*sin(0.1*TIME), coord)).x,0.0);
	if (abs(normal.y) > 0.5)
	{
		ALBEDO = vec3(1.0,1.0,1.0);
	}

}
