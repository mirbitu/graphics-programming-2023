#version 330 core

in vec3 WorldPosition;
in vec3 WorldNormal;
in vec2 TexCoord;

out vec4 FragColor;

uniform vec4 Color;
uniform sampler2D WaterTexture;
uniform vec2 ColorTextureScale;

uniform float Time;


void main()
{
	FragColor = Color * texture(WaterTexture, (TexCoord-(Time*3)) * ColorTextureScale);
}
