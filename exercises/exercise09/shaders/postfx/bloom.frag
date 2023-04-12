//Inputs
in vec2 TexCoord;

//Outputs
out vec4 FragColor;

//Uniforms
uniform sampler2D SourceTexture;
uniform vec2 Range;
uniform float Intensity;

float Remap(float a, float b, float v) {
	return clamp((v - a) / (b - a), 0.0, 1.0);
}

void main()
{
	vec4 color = texture(SourceTexture, TexCoord);
	float luminance = GetLuminance(color.rgb);
	luminance = Remap(Range.x, Range.y, luminance);
	FragColor = color * luminance * Intensity;
}
