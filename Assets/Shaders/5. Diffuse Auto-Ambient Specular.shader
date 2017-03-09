// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Faxime/5. Diffuse Auto-Ambient Specular (Phong)"
{
	Properties
	{
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex mainVertex
			#pragma fragment mainFrag

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
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			// =============================================================================
			// Vertex Function
			// =============================================================================

			vertexOutput mainVertex(vertexInput input)
			{
				vertexOutput output;

				//direção da luz
				float3 lightDirection = normalize(-_WorldSpaceLightPos0.xyz);
				float3 surfaceNormal = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

				float intensity = dot(surfaceNormal, lightDirection);
				float4 ambientColor = _DiffuseColor*0.2;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

				float iSpec = 0;
				if (intensity > 0)
				{
					float3 reflectionDirection = -2*dot(surfaceNormal, lightDirection)*surfaceNormal + lightDirection;
					float3 eye = normalize(mul(unity_ObjectToWorld, input.vertex).xyz - _WorldSpaceCameraPos);
					iSpec = max(dot(reflectionDirection, eye), 0.0);
				}
				
				output.col = max(_DiffuseColor*intensity + _SpecularColor*iSpec, ambientColor);

				return output;
			}

			// =============================================================================
			// Fragment Function
			// =============================================================================

			float4 mainFrag(vertexOutput input) : COLOR
			{
				return input.col;
			}

			ENDCG
		}
	}
}