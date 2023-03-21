Shader "CG2023/Hatching"
{
    Properties
    {
        _Albedo("Albedo", Color) = (1,1,1,1)
        _AlbedoTexture("Albedo Texture", 2D) = "white" {}
        _Reflectance("Reflectance (Ambient, Diffuse, Specular)", Vector) = (1, 1, 1, 0)
        _SpecularExponent("Specular Exponent", Float) = 100.0

        // TODO exercise 6 - Add the required properties here
        _Hatching0("Hatching0", 2D) = "hatch_0" {}
        _Hatching1("Hatching1", 2D) = "hatch_1" {}
        _Hatching2("Hatching2", 2D) = "hatch_2" {}
        _Hatching3("Hatching3", 2D) = "hatch_3" {}
        _Hatching4("Hatching4", 2D) = "hatch_4" {}
        _Hatching5("Hatching5", 2D) = "hatch_5" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        GLSLINCLUDE
        #include "UnityCG.glslinc"
        #include "ITUCG.glslinc"

        uniform vec4 _Albedo;
        uniform sampler2D _AlbedoTexture;
        uniform vec4 _AlbedoTexture_ST;
        uniform vec4 _Reflectance;
        uniform float _SpecularExponent;
        
        // TODO exercise 6 - Add the required uniforms here
        uniform sampler2D _Hatching0;
        uniform sampler2D _Hatching1;
        uniform sampler2D _Hatching2;
        uniform sampler2D _Hatching3;
        uniform sampler2D _Hatching4;
        uniform sampler2D _Hatching5;
        uniform vec4 _HatchingTexture_ST;


        // TODO exercise 6 - Compute the hatching intensity here
        float ComputeHatching(vec3 lighting, vec2 texCoords)
        {
            // TODO exercise 6.3 - Compute the lighting intensity from the lighting color luminance
            float intensity = GetColorLuminance(lighting);

            // TODO exercise 6.3 - Clamp the intensity value between 0 and 1
            intensity = clamp(intensity, 0.0f, 1.0f);

            // TODO exercise 6.3 - Multiply the intensity by the number of levels. This time the number of levels is fixed, 7, given by the number of textures + 1
            intensity = intensity * 7;

            // TODO exercise 6.3 - Compute the blending factor, as the fractional part of the intensity
            float blendingFactor = fract(intensity);

            // TODO exercise 6.3 - Depending on the intensity, choose up to 2 textures to sample and mix them based on the blending factor. That would be the hatching intensity
            vec3 sampleValue1;
            vec3 sampleValue2;

            if (intensity <= 1)
            {
                sampleValue1 = vec3(0.0f);
                sampleValue2 = texture(_Hatching5, texCoords).rgb;
            }
            else if (intensity <= 2)
            {
                sampleValue1 = texture(_Hatching5, texCoords).rgb;
                sampleValue2 = texture(_Hatching4, texCoords).rgb;
            }
            else if (intensity <= 3)
            {
                sampleValue1 = texture(_Hatching4, texCoords).rgb;
                sampleValue2 = texture(_Hatching3, texCoords).rgb;
            }
            else if (intensity <= 4)
            {
                sampleValue1 = texture(_Hatching3, texCoords).rgb;
                sampleValue2 = texture(_Hatching2, texCoords).rgb;
            }
            else if (intensity <= 5)
            {
                sampleValue1 = texture(_Hatching2, texCoords).rgb;
                sampleValue2 = texture(_Hatching1, texCoords).rgb;
            }
            else if (intensity <= 6)
            {
                sampleValue1 = texture(_Hatching1, texCoords).rgb;
                sampleValue2 = texture(_Hatching0, texCoords).rgb;
            }
            else if (intensity <= 7)
            {
                sampleValue1 = texture(_Hatching0, texCoords).rgb;
                sampleValue2 = vec3(1.0f);
            }

            intensity = mix(sampleValue1, sampleValue2, blendingFactor).x;
            // TODO exercise 6.4 - Replace the previous step with 2 samples from the texture array. Mix them based on the blending factor to get the hatching intensity

            return intensity;
        }
        ENDGLSL

        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }

            GLSLPROGRAM

            struct vertexToFragment
            {
                vec3 worldPos;
                vec3 normal;
                vec4 texCoords;
            };

            #ifdef VERTEX
            out vertexToFragment v2f;

            void main()
            {
                v2f.worldPos = (unity_ObjectToWorld * gl_Vertex).xyz;
                v2f.normal = (unity_ObjectToWorld * vec4(gl_Normal, 0.0f)).xyz;
                v2f.texCoords.xy = TransformTexCoords(gl_MultiTexCoord0.xy, _AlbedoTexture_ST);

                // TODO exercise 6.3 - Transform hatching texture coordinates and pass to the fragment
                v2f.texCoords.zw = TransformTexCoords(gl_MultiTexCoord0.zw, _HatchingTexture_ST);

                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
            #endif // VERTEX

            #ifdef FRAGMENT
            in vertexToFragment v2f;

            void main()
            {
                vec3 lightDir = GetWorldSpaceLightDir(v2f.worldPos);
                vec3 viewDir = GetWorldSpaceViewDir(v2f.worldPos);

                vec3 normal = normalize(v2f.normal);

                vec3 albedo = texture(_AlbedoTexture, v2f.texCoords.xy).rgb;
                albedo *= _Albedo.rgb;

                // Like in the cel-shading exercise, we replace the albedo here with 1.0f
                vec3 lighting = BlinnPhongLighting(lightDir, viewDir, normal, vec3(1.0f), vec3(1.0f), _Reflectance.x, _Reflectance.y, _Reflectance.z, _SpecularExponent);

                float hatch = ComputeHatching(lighting, v2f.texCoords.zw);

                // Like in the cel-shading exercise, we multiply by the albedo and the light color at the end
                gl_FragColor = vec4(hatch * albedo * _LightColor0.rgb, 1.0f);
            }
            #endif // FRAGMENT

            ENDGLSL
        }
        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardAdd" }

            ZWrite Off
            Blend One One

            GLSLPROGRAM

            struct vertexToFragment
            {
                vec3 worldPos;
                vec3 normal;
                vec4 texCoords;
            };

            #ifdef VERTEX
            out vertexToFragment v2f;

            void main()
            {
                v2f.worldPos = (unity_ObjectToWorld * gl_Vertex).xyz;
                v2f.normal = (unity_ObjectToWorld * vec4(gl_Normal, 0.0f)).xyz;
                v2f.texCoords.xy = TransformTexCoords(gl_MultiTexCoord0.xy, _AlbedoTexture_ST);

                // TODO exercise 6.3 - Transform hatching texture coordinates and pass to the fragment
                v2f.texCoords.zw = TransformTexCoords(gl_MultiTexCoord0.zw, _HatchingTexture_ST);

                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
            #endif // VERTEX

            #ifdef FRAGMENT
            in vertexToFragment v2f;

            void main()
            {
                vec3 lightDir = GetWorldSpaceLightDir(v2f.worldPos);
                vec3 viewDir = GetWorldSpaceViewDir(v2f.worldPos);

                vec3 normal = normalize(v2f.normal);

                vec3 albedo = texture(_AlbedoTexture, v2f.texCoords.xy).rgb;
                albedo *= _Albedo.rgb;

                // Like in the cel-shading exercise, we replace the albedo here with 1.0f. Notice that ambient reflectance is still 0.0f
                vec3 lighting = BlinnPhongLighting(lightDir, viewDir, normal, vec3(1.0f), vec3(1.0f), 0.0f, _Reflectance.y, _Reflectance.z, _SpecularExponent);

                float hatch = ComputeHatching(lighting, v2f.texCoords.zw);

                // Like in the cel-shading exercise, we multiply by the albedo and the light color at the end
                gl_FragColor = vec4(hatch * albedo * _LightColor0.rgb, 1.0f);
            }
            #endif // FRAGMENT

            ENDGLSL
        }
        Pass
        {
            Name "SHADOWCASTER"
            Tags { "LightMode" = "ShadowCaster" }

            GLSLPROGRAM

            #ifdef VERTEX
            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
            #endif // VERTEX

            #ifdef FRAGMENT
            void main()
            {
            }
            #endif // FRAGMENT

            ENDGLSL
        }
        // TODO exercise 6 - Add the outline pass here
        Pass
        {
            Cull Front

            Name "OUTLINE"
            Tags { "LightMode" = "ForwardBase" }

            GLSLPROGRAM

            #ifdef VERTEX
            
            void main()
            {
                vec3 worldPos = (unity_ObjectToWorld * gl_Vertex).xyz;
                vec3 normal = (unity_ObjectToWorld * vec4(gl_Normal, 0.0f)).xyz;
                float thickness = 0.012f;
                worldPos = worldPos + (normal * thickness);

                gl_Position = unity_MatrixVP * vec4(worldPos, 1.0f);
            }
            #endif // VERTEX

            #ifdef FRAGMENT
            
            void main()
            {
                gl_FragColor = vec4(0.0f, 0.0f, 0.0f, 1.0f);
            }
            #endif // FRAGMENT

            ENDGLSL
        }
    }
}
