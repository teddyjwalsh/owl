shader_type spatial;

uniform sampler2D noise;
varying vec3 vtx;

void vertex() {
	vtx = VERTEX;
}


void fragment() {
	float angle = atan(vtx.z,vtx.x);
	float angle_rad = 0.45 + texture(noise, vec2(angle/(2.0*PI),0)).x/10.0;
	float angle_rad2 = 0.34 + texture(noise, vec2(2.0*angle/(2.0*PI),0)).x/10.0;
	float cur_rad = sqrt(length(vtx.xz));
	ALPHA = clamp(1.0 - (cur_rad - 0.4)/0.5,0.0,1.0);
	if (angle_rad2 > cur_rad)
	{
		ALBEDO = vec3(0.55,0.3,0.3);
	}
	else if (angle_rad > cur_rad)
	{
		ALBEDO = vec3(0.3,0.1,0.1);
	}
	else
	{
		ALBEDO = vec3(0.1,0.5,0.1);
	}
}
