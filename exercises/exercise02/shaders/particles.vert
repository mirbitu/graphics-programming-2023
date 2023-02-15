#version 330 core

layout (location = 0) in vec2 ParticlePosition;
// (todo) 02.X: Add more vertex attributes
layout (location = 1) in float ParticleSize;
layout (location = 2) in float ParticleDuration;
layout (location = 3) in float ParticleBirth;


// (todo) 02.5: Add Color output variable here


// (todo) 02.X: Add uniforms
uniform float CurrentTime;

float particleSize = ParticleSize;
float particleDuration = ParticleDuration;
float particleAge = CurrentTime - ParticleBirth;


void main()
{
	gl_Position = vec4(ParticlePosition, 0.0, 1.0);
	gl_PointSize = particleSize;

	if (particleAge > particleDuration) { gl_PointSize = 0; }
}
