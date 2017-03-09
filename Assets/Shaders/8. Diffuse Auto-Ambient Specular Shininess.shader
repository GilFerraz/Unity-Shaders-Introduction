Shader "Faxime/8. Diffuse Auto-Ambient Specular (Phong)"
{
	Properties
	{
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Range(0.0, 50.0)) = 0.5
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
			uniform float _Shininess;

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
				float4 eye : TEXCOORD0;
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
					iSpec = pow(max(dot(reflectionDirection, eye), 0.0), _Shininess);
				}
				
				output.col = max(_DiffuseColor*intensity + _SpecularColor*iSpec, ambientColor);

				return output;
			}

			// =============================================================================
			// Fragment Function
			// =============================================================================

			float4 mainFrag(vertexOutput input) : COLOR
			{
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 surfaceNormal = normalize(input.normal);
				float3 eye = normalize(input.eye);

				float intensity = max(dot(surfaceNormal, lightDirection), 0.0);
				float iSpec = 0;

				if (intensity > 0)
				{
					float3 reflectionDirection = -2*dot(surfaceNormal, lightDirection)*surfaceNormal + lightDirection;
					iSpec = pow(max(dot(reflectionDirection, eye), 0.0), _Shininess);
				}

				return float4(_DiffuseColor.xyz*intensity
			}

			ENDCG
		}
	}
}