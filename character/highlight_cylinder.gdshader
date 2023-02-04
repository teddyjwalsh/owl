shader_type spatial;
render_mode unshaded;

varying vec3 vtx;
instance uniform vec3 color;

void vertex() {
	vtx = VERTEX;
}

void fragment() {
	ALPHA = pow(max(0,1.0 - (vtx.y+1.0)/2.0),1);
	EMISSION = color;
	ALBEDO = color;
}
