#version 330 core

layout (location = 0) in vec3 VertexPosition;
layout (location = 1) in vec3 VertexNormal;

// (todo) 03.X: Add the out variables here
out vec4 Normals;

// (todo) 03.X: Add the uniforms here
uniform mat4 WorldMatrix = mat4(1.0f);
uniform mat4 ViewProjMatrix;

void main()
{
	gl_Position = vec4(ViewProjMatrix * WorldMatrix * vec4(VertexPosition, 1.0));
	Normals = WorldMatrix*(vec4(VertexNormal, 0));
}
