#version 330 core

in vec3 WorldPosition;
in vec3 WorldNormal;
in vec2 TexCoord;
in float Height;

out vec4 FragColor;

uniform vec4 Color;
uniform sampler2D GrassTexture;
uniform sampler2D DirtTexture;
uniform sampler2D RockTexture;
uniform sampler2D SnowTexture;
uniform vec2 ColorTextureScale;
uniform vec2 DirtGrassRange;
uniform vec2 GrassRockRange;
uniform vec2 RockSnowRange;

float calcMixVal(vec2 range, float height)
{
	if (height <= range.x) {
		return 0;
	}
	else if (height >= range.y) {
		return 1;
	}
	else {
		return (height - range.x) / (range.y - range.x);
	}
}

void main()
{
	vec4 grasstexturesample = texture(GrassTexture, TexCoord * ColorTextureScale);
	vec4 dirttexturesample = texture(DirtTexture, TexCoord * ColorTextureScale);
	vec4 rocktexturesample = texture(RockTexture, TexCoord * ColorTextureScale);
	vec4 snowtexturesample = texture(SnowTexture, TexCoord * ColorTextureScale);

	float dirtgrassMixVal = calcMixVal(DirtGrassRange, Height);
	float grassrockMixVal = calcMixVal(GrassRockRange, Height);
	float rocksnowMixVal = calcMixVal(RockSnowRange, Height);

	//vec4 dg = mix(dirttexturesample, grasstexturesample, dirtgrassMixVal);
	//vec4 gr = mix(grasstexturesample, rocktexturesample, grassrockMixVal);
	//vec4 rs = mix(rocktexturesample, snowtexturesample, rocksnowMixVal);

	vec4 finalcolor = dirttexturesample;
	finalcolor = mix(finalcolor, grasstexturesample, dirtgrassMixVal);
	finalcolor = mix(finalcolor, rocktexturesample, grassrockMixVal);
	finalcolor = mix(finalcolor, snowtexturesample, rocksnowMixVal);
	
	//FragColor = Color * (dg + gr + rs)/3;
	FragColor = Color * finalcolor;
}
