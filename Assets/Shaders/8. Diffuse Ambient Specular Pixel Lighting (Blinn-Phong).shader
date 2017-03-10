Shader "Faxime/Introduction/8. Diffuse Ambient Specular Pixel Lighting (Blinn-Phong)"
{
	Properties
	{
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecularStrength("Shininess", Range(1.0, 256.0)) = 1.5
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
												
			// =============================================================================
			// Pragma Directives
			// =============================================================================

			#pragma vertex vertex
			#pragma fragment fragment
									
			// =============================================================================
			// Include Directives
			// =============================================================================

			#include "UnityCG.cginc"

			// =============================================================================
			// Uniform Variables
			// =============================================================================

			uniform float4 _DiffuseColor;
			uniform float4 _SpecularColor;
			uniform float _SpecularStrength;
						
			// =============================================================================
			// Constants
			// =============================================================================

			static const float AmbientFactor = 0.2;
		
			// =============================================================================
			// Structures
			// =============================================================================

			struct vertexInput 
			{
				float4 Vertex : POSITION;
				float3 Normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 Position : SV_POSITION;
				float3 Normal : TEXCOORD0;
				float3 ViewDirection : TEXCOORD1;
			};
		
			// =============================================================================
			// Vertex Function
			// =============================================================================

			vertexOutput vertex(vertexInput input)
			{
				vertexOutput output;

				// Transforms the vertex position from object space to world space.
				output.Position = mul(UNITY_MATRIX_MVP, input.Vertex);

				// Calculates the vertex's surface normal in object space.
				output.Normal = normalize(mul(float4(input.Normal, 0.0), unity_WorldToObject).xyz);

				// Calculates the camera's view direction to the vertex.
				output.ViewDirection = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, input.Vertex).xyz);

				return output;
			}

			// =============================================================================
			// Fragment Function
			// =============================================================================
		
			float4 fragment(vertexOutput input) : COLOR
			{
				float specularIntensity = 0.0;

				// Calculates the vetex's ambient color, based on its diffuse color.
				float4 ambientColor = _DiffuseColor * AmbientFactor;

				// Calculates the light's direction in world space.
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

				float3 normal = normalize(input.Normal);
				float3 viewDirection = normalize(input.ViewDirection);

				// Calculates the light's intensity on the vertex.
				float intensity = max(dot(normal, lightDirection), 0.0);

				if (intensity > 0) 
				{
					// Calculates the half vector between the light vector and the view vector.
					float3 h = normalize(lightDirection + viewDirection);

					// Calculates the specular intensity, based on the reflection direction and view direction.
					specularIntensity =  pow(max(dot(normal, h), 0.0), _SpecularStrength);
				}

				return max(_DiffuseColor * intensity + _SpecularColor * specularIntensity, ambientColor);
			}
		
			ENDCG
		}
	}
}
