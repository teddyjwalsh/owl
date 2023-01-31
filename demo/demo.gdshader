shader_type canvas_item;

uniform vec2 size = vec2(32.0, 28.0);
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform vec3 colors[5];

uniform sampler2D noise;

void fragment() 
{
	float min_length = 0.5;
	float max_length = 2.0;
	vec3 pre_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec3 min_color = colors[0];
	for (int i = 0; i < colors.length(); ++i)
	{
		if (length(normalize(pre_color) - normalize(colors[i])) < length(normalize(pre_color) - normalize(min_color)))
		{
			min_color = colors[i];
		}
	}
	float length_ratio = clamp(length(pre_color),min_length,max_length)/length(min_color);
	COLOR = vec4(min_color,1.0)*length_ratio;
}