shader_type spatial;
render_mode unshaded, cull_disabled;

float rectangle(vec2 samplePosition, vec2 halfSize, float dropoff){
    vec2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
    float outsideDistance = length(max(componentWiseEdgeDistance, 0))*dropoff;
    float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0);
    return outsideDistance + insideDistance;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist = rectangle(UV - vec2(0.5,0.5), vec2(0.4), 1.0);
	ALBEDO = vec3(0.1, 0.4, 1.0);
	
	if(dist > 0.1) {
		ALPHA = 0.0;
		}
	else if (dist > 0.09){
		ALPHA = 0.2;
	} else {
		ALPHA = max(dist, 0.05);		
	}
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
