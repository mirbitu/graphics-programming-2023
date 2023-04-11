//Inputs
in vec2 TexCoord;

//Outputs
out vec4 FragColor;

//Uniforms
uniform sampler2D SourceTexture;
uniform float Exposure;

void main()
{
	vec4 sampledTexture = texture(SourceTexture, TexCoord);
	vec4 toneMappedColor = 1 - exp(-sampledTexture * Exposure);
	FragColor = toneMappedColor;
	//FragColor = texture(SourceTexture, TexCoord);
}
