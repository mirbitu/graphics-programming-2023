#version 330 core

in vec3 WorldPosition;
in vec3 WorldNormal;
in vec2 TexCoord;

out vec4 FragColor;

uniform vec4 Color;
uniform sampler2D ColorTexture;
uniform vec3 AmbientColor;
uniform float AmbientReflection;
uniform float DiffuseReflection;
uniform vec3 LightColor;
uniform vec3 LightPosition;


float clampPositive(float value)
{
	if (value < 0) {
		return 0;
	}
	return value;
}

vec3 GetAmbientReflection(vec3 ambientColor, float ambientReflection, vec4 color)
{
	return ambientColor * ambientReflection * color.rgb;
}

vec3 GetDiffuseReflection(vec3 lightColor, float diffuseReflection, vec4 color, vec3 lightVectorL, vec3 worldNormal)
{
	float nl = clampPositive(dot(lightVectorL, worldNormal));
	return lightColor * diffuseReflection * color.rgb * nl;
}

vec3 GetBlinnPhongReflection(vec3 ambientColor, float ambientReflection, vec4 color, vec3 lightColor, float diffuseReflection, vec3 lightVectorL, vec3 worldNormal)
{
	vec3 result = GetAmbientReflection(ambientColor, ambientReflection, color);
	result = result + GetDiffuseReflection(lightColor, diffuseReflection, color, lightVectorL, worldNormal);
	return result;
}



void main()
{
	vec3 lightVectorL = normalize(LightPosition - WorldPosition); 

	FragColor = Color * texture(ColorTexture, TexCoord) * AmbientReflection;
	FragColor = vec4(GetBlinnPhongReflection(AmbientColor,
											AmbientReflection,
											FragColor,
											LightColor,
											DiffuseReflection,
											lightVectorL,
											normalize(WorldNormal)), 1.0f);
}
