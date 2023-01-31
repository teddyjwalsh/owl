shader_type spatial;
//render_mode unshaded;

uniform sampler2D noise;
varying vec3 local_pos;
varying vec3 normal;
instance uniform float local_time;

void vertex()
{
	local_pos = VERTEX;
	normal = NORMAL;
}

void fragment() 
{
	float rad = length(local_pos);
	float angle = float(int(atan(local_pos.x, local_pos.z)*100.0))/100.0;
	float start_multiplier = pow(max(0, 1.0 - local_time),3);
	float max_height = 2.0;
	ALPHA = pow(max(0, max_height - (rad + 1.0))/max_height,2);
	ALBEDO = vec3(0.0, 0.9, 0.2);// + vec3(1.0, 1.0, 1.0)*pow(max(0, max_height - (local_pos.y + 1.0))/max_height,4);
	float coord = UV.y*float(int(angle*100.0*sin(0.001*TIME))/100)*0.5;
	EMISSION = 3.0*vec3(3.0*texture(noise, vec2(angle*sin(0.01*TIME), 0.01*TIME)).x,1.0,1.0) + vec3(1.0,1.0,1.0)*start_multiplier;
	

}
