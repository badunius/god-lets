shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

void vertex() {
	// Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec2 base_uv = UV;
	vec2 px_size = vec2(textureSize(texture_albedo, 0));
	float px_max = float(max(px_size.x, px_size.y));
	vec2 size = vec2(px_size.x / px_max, px_size.y / px_max);
	float x_offset = (1.0 - size.x) * 0.5;
	float y_offset = (1.0 - size.y);
	vec2 offset = vec2(x_offset, y_offset);

	vec2 bound_uv = base_uv - offset;
	bound_uv = bound_uv / size;
	vec2 clamp_uv = clamp(bound_uv, vec2(0.0), vec2(1.0));
	vec4 albedo_tex = texture(texture_albedo, clamp_uv);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
	//ALBEDO *= albedo.rgb;
	if (bound_uv != clamp_uv) {
		//ALPHA = 0.0;
		discard;
	}
}
