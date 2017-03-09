Shader "Faxime/Diffuse"
{
	Properties
	{
		_DiffuseColor("Cor Difusa", Color) = (1,1,1,1)
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
				float3 ldir = normalize(-_WorldSpaceLightPos0.xyz);
				float3 n = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

				float intensity = dot(n, ldir);

				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
				output.col = float4(_DiffuseColor.xyz*intensity, 1.0);

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