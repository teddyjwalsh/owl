shader_type canvas_item;

uniform float current_health;
uniform float old_health;

void fragment() {
	//COLOR = vec4(1.0,0.0,0.0,1.0);

	if (UV.x < current_health)
	{
		COLOR = vec4(1.0,0.0,0.0,1.0);
	}
	else if (UV.x < old_health)
	{
		COLOR = vec4(1.0,1.0,1.0,1.0);		
	}
	else
	{
		COLOR = vec4(1.0,0.0,0.0,0.0);
	}

}
