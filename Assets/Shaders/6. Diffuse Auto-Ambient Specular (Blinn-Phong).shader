Shader "Faxime/Introduction/6. Diffuse Auto-Ambient Specular (Blinn-Phong)"
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

			#pragma vertex vertex
			#pragma fragment fragment

			#include "UnityCG.cginc"

			// =============================================================================
			// Uniform Variables
			// =============================================================================

			uniform float4 _DiffuseColor;
			uniform float4 _SpecularColor;

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

				// Calculates the light's direction.
				float3 lightDirection = normalize(-_WorldSpaceLightPos0.xyz);

				// Calculates the vertex's objects surface normal.
				float3 surfaceNormal = normalize(mul(float4(input.Normal, 0.0), unity_WorldToObject).xyz);

				// Calculates the vertex's light intensity.
				float intensity = dot(surfaceNormal, lightDirection);

				// Calculates the vetex's ambient color, based on its diffuse color.
				float4 ambientColor = _DiffuseColor * 0.2;

				if (intensity > 0)
				{
					// Calculates the camera's view direction to the vertex.
					float3 viewDirection = normalize(mul(unity_ObjectToWorld, input.Vertex).xyz - _WorldSpaceCameraPos);

					// Calculates the half vector between the light vector and the view vector.
					float3 h = normalize(lightDirection + viewDirection);

					//Intensity of the specular light
					specularIntensity =  max(dot(surfaceNormal, h), 0.0);
				}
				
				output.Color = max(_DiffuseColor*intensity + _SpecularColor * specularIntensity, ambientColor);

				output.Position = mul(UNITY_MATRIX_MVP, input.Vertex);

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