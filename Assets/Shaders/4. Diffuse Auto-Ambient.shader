Shader "Faxime/Diffuse Auto-Ambient"
{
	Properties
	{
		_DiffuseColor("Cor Difusa", Color) = (1,1,1,1)
		_AmbientColor("Cor Ambiente", Color) = (1,1,1,1)
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
			uniform float4 _AmbientColor;

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
				output.col = max(float4(_DiffuseColor.xyz*intensity, 1.0), float4(_AmbientColor.xyz, 1.0));

				//if (intensity > 0)
				//{
				//	output.col = float4(_DiffuseColor.xyz*intensity, 1.0F);
				//}
				//else
				//{
				//	output.col = float4(ambientColor.xyz, 1.0F);
				//}

				output.col = max(_DiffuseColor*intensity, ambientColor);

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