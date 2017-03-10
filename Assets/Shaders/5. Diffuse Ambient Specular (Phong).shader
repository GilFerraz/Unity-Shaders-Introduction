Shader "Faxime/Introduction/5. Diffuse Ambient Specular (Phong)"
{
	Properties
	{
		_DiffuseColor("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
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
				float4 Color : COLOR;
			};

			// =============================================================================
			// Vertex Function
			// =============================================================================

			vertexOutput vertex(vertexInput input)
			{
				vertexOutput output;
				float specularIntensity = 0.0;

				// Transforms the vertex position from object space to world space.
				output.Position = mul(UNITY_MATRIX_MVP, input.Vertex);

				// Calculates the light's direction in world space.
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				// Calculates the vertex's surface normal in object space.
				float3 normal = normalize(mul(float4(input.Normal, 0.0), unity_WorldToObject).xyz);

				// Calculates the light's intensity on the vertex.
				float intensity = dot(normal, lightDirection);

				// Calculates the vetex's ambient color, based on its diffuse color.
				float4 ambientColor = _DiffuseColor * AmbientFactor;

				if (intensity > 0)
				{
					// Calculates the reflection's direction.
					float3 reflectionDirection = -2.0 * intensity * normal + lightDirection;
					
					// Calculates the view direction.
					float3 viewDirection = normalize(mul(unity_ObjectToWorld, input.Vertex).xyz - _WorldSpaceCameraPos);

					// Calculates the specular intensity, based on the reflection direction and view direction.
					specularIntensity = max(dot(reflectionDirection, viewDirection), 0.0);
				}
				
				output.Color = max(_DiffuseColor * intensity + _SpecularColor * specularIntensity, ambientColor);

				return output;
			}

			// =============================================================================
			// Fragment Function
			// =============================================================================

			float4 fragment(vertexOutput input) : COLOR
			{
				return input.Color;
			}

			ENDCG
		}
	}
}