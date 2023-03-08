#version 330 core

in vec3 WorldPosition;
in vec3 WorldNormal;
in vec2 TexCoord;

out vec4 FragColor;

uniform vec4 Color;
uniform sampler2D ColorTexture;
uniform vec3 AmbientColor;
uniform float AmbientReflection;


vec3 GetAmbientReflection(vec3 ambientColor, float ambientReflection, vec4 color)
{
	return ambientColor * ambientReflection * color.rgb;
}

vec3 GetBlinnPhongReflection(vec3 ambientColor, float ambientReflection, vec4 color)
{
	return GetAmbientReflection(ambientColor, ambientReflection, color);
}

void main()
{
	FragColor = Color * texture(ColorTexture, TexCoord) * AmbientReflection;
	FragColor = vec4(GetBlinnPhongReflection(AmbientColor, AmbientReflection, FragColor), 1.0f);
}
