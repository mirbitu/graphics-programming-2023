//Inputs
in vec2 TexCoord;

//Outputs
out vec4 FragColor;

//Uniforms
uniform sampler2D SourceTexture;
uniform float Exposure;
uniform float Contrast;
uniform float HueShift;
uniform float Saturation;
uniform vec3 ColorFilter;


void main()
{
	vec4 sampledTexture = texture(SourceTexture, TexCoord);
	vec4 toneMappedColor = 1 - exp(-sampledTexture * Exposure);

	vec3 finalColor;
	finalColor = toneMappedColor.rgb;

	vec3 contrastColor = clamp(((finalColor - 0.5) * Contrast + 0.5), 0, 1);
	finalColor = contrastColor;


	vec3 hueshiftColor = RGBToHSV(finalColor);
	hueshiftColor = vec3(fract(hueshiftColor.r + HueShift), hueshiftColor.gb);
	hueshiftColor = HSVToRGB(hueshiftColor);
	finalColor = hueshiftColor;

	float luminance = GetLuminance(finalColor);
	vec3 saturationColor = clamp(((finalColor - luminance) * Saturation + luminance), 0, 1);
	finalColor = saturationColor;

	vec3 colorfilterColor = finalColor * ColorFilter;
	finalColor = colorfilterColor;

	FragColor = vec4(finalColor, toneMappedColor.a);
}
