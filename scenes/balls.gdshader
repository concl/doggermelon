shader_type canvas_item;

// Blend factor between original texture (0.0) and white (1.0)
uniform float t : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Pure white with same alpha
    vec4 white_color = vec4(1.0, 1.0, 1.0, tex_color.a);

    // Interpolate between original texture and white
    COLOR = mix(tex_color, white_color, t);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
