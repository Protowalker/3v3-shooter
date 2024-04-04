shader_type spatial;
render_mode cull_disabled;

uniform sampler2D depth_texture : source_color, hint_depth_texture;

float rectangle(vec2 samplePosition, vec2 halfSize){
    vec2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
    float outsideDistance = length(max(componentWiseEdgeDistance, 0));
    float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0);
    return outsideDistance + insideDistance;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist = rectangle(UV - vec2(0.5,0.5), vec2(0.4));
	ALBEDO = vec3(0.1, 0.4, 1.0);
	
	float proximity_fade;
	{
		float __depth_tex = texture(depth_texture, SCREEN_UV).r;
		vec4 __depth_world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, __depth_tex, 1.0);
		__depth_world_pos.xyz /= __depth_world_pos.w;
		float fade_dist = 0.3;
		proximity_fade = clamp(1.0 - smoothstep(__depth_world_pos.z + fade_dist, __depth_world_pos.z, VERTEX.z), 0.0, 1.0);
	}
	dist = max(dist*4.0, 1.0 - proximity_fade);
	ALPHA = mix(0.1, 1.0, dist);
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
